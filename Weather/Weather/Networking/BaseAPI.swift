//
//  BaseAPI.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import Foundation
import Alamofire
import Combine

protocol EndpointPath {
    var description: String { get }
}

class BaseAPI<T: TargetType>: NSObject {
    var acceptedStatusCodes = 200...300
    var genericError: NSError = NSError(domain: Server.baseURL, code: 999, userInfo: [NSLocalizedDescriptionKey: Message.genericError])
    
    // Only use this when the Backend is handling "Cache-Control Header"
    private let cacheSessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        let interceptor = BaseInterceptor()
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.urlCredentialStorage = nil
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
          let userInfo = ["date": Date()]
          return CachedURLResponse(response: response.response, data: response.data, userInfo: userInfo, storagePolicy: .allowed)
        })
        return Session(configuration: configuration, interceptor: interceptor, cachedResponseHandler: responseCacher)
    }()
    
    private let regularSessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        let interceptor = BaseInterceptor()
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        configuration.urlCredentialStorage = nil
        return Session(configuration: configuration,interceptor: interceptor)
    }()
    
    func sendRequest(target: T) -> AnyPublisher<Any?, ErrorResponse> {
        var error: NSError = genericError
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        printRequest(target: target)
        return regularSessionManager.request(target.baseURL + target.path.description, method: method, parameters: params.0, encoding: params.1, headers: headers)
            .responseJSON { error = self.parseErrorIfAny(in: $0) }
            .validate(statusCode: acceptedStatusCodes)
            .publishData()
            .value()
            .mapError { _ in error.userInfo["NSLocalizedDescription"] as! ErrorResponse }
            .map {_ in nil}
            .eraseToAnyPublisher()
    }
    
    func fetchData<M: Decodable>(target: T, shouldUseCache: Bool = false) -> AnyPublisher<M, ErrorResponse> {
        var error: NSError = genericError
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        printRequest(target: target)
        let session = shouldUseCache ? cacheSessionManager : regularSessionManager
        return session.request(target.baseURL + target.path.description, method: method, parameters: params.0, encoding: params.1, headers: headers)
            .responseJSON {
                error = self.parseErrorIfAny(in: $0)
                print(error.userInfo)
               
            }
            .validate(statusCode: acceptedStatusCodes)
            .publishDecodable(type: M.self)
            .value()
            .mapError { _ in error.userInfo["NSLocalizedDescription"] as! ErrorResponse }
            .eraseToAnyPublisher()
    }
    
    func upload<M: Decodable>(target: T, shouldUseCache: Bool = false) -> AnyPublisher<M, ErrorResponse> {
        var error: NSError = genericError
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        
        printRequest(target: target)
        let session = shouldUseCache ? cacheSessionManager : regularSessionManager
        return session.upload(multipartFormData: buildData(task: target.task), to: target.baseURL + target.path.description, method: method, headers: headers)
            .responseJSON { error = self.parseErrorIfAny(in: $0) }
            .validate(statusCode: self.acceptedStatusCodes)
            .uploadProgress(closure: { (progress) in
                print(progress)
            })
            .publishDecodable(type: M.self)
            .value()
            .mapError { _ in error.userInfo["NSLocalizedDescription"] as! ErrorResponse }
            .eraseToAnyPublisher()
    }
    
    func parseErrorIfAny(in response: AFDataResponse<Any>) -> NSError {
        guard let statusCode = response.response?.statusCode else { return genericError }
        var error = NSError(domain: genericError.domain, code: statusCode, userInfo: genericError.userInfo)
        if !(self.acceptedStatusCodes.contains(statusCode)) {
            // Error Handeling
            guard let data = response.data,
                  let responseObj = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            else { return error }
            error = NSError(domain: Server.baseURL, code: statusCode, userInfo: [NSLocalizedDescriptionKey: responseObj])
        }
        
        return error
    }
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        case .data:
            return ([:], URLEncoding.default)
        }
    }
    
    private func buildData(task: Task) -> MultipartFormData {
        switch task {
        case .data(let formData):
            return formData
        default:
            return MultipartFormData()
        }
    }
    
    private func printRequest(target: T) {
        print("###")
        print("request called: \(target.baseURL)\(target.path)")
        print("http method: \(target.method)")
        if let headers = target.headers {
            print("headers: \(headers)")
        }
        print("parameters: \(target.task)")
        print("###")
    }
}

class ErrorResponse: Decodable, Error {
    var status: String?
    var msg: String?
}
