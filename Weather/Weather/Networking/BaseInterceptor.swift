//
//  BaseInterceptor.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
  let retryLimit = 3
  let retryDelay: TimeInterval = 5
  
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//    var urlRequest = urlRequest
//    if let token = KeyChainManager.shared.token {
//      urlRequest.setValue("Token=\(token)", forHTTPHeaderField: "Authorization")
//    }
    completion(.success(urlRequest))
  }
  
  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    let response = request.task?.response as? HTTPURLResponse
    //Retry for 5xx status codes
    if let statusCode = response?.statusCode, (500...599).contains(statusCode), request.retryCount < retryLimit {
        completion(.retryWithDelay(retryDelay))
    } else {
      return completion(.doNotRetry)
    }
  }
}
