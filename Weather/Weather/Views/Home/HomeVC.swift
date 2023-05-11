//
//  HomeVC.swift
//  Weather
//
//  Created by Islam Elgaafary on 11/05/2023.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func forecast(_ sender: Any) {
        let vc = ForecastVC.create()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
