//
//  ForecastVC.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import UIKit

class ForecastVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    class func create() -> ForecastVC {
        let vc = StoryboardScene.Main.forecastVC.instantiate()
        return vc
    }

}
