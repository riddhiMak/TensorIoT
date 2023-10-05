//
//  WeatherDetailViewController.swift
//  TensorIoT
//
//  Created by Riddhi Makwana on 05/10/23.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    var daily : Daily!
    @IBOutlet weak var lblWindSpeed : UILabel!
    @IBOutlet weak var lblHumidity: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        lblWindSpeed.text = getWindSpeed()
        lblHumidity.text = "\(daily.humidity) %"
    }
    
    func configureNavigationBar() {
        navigationItem.title = str.WeatherDetails
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // change title color
        let textChangeColor = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textChangeColor
        navigationController?.navigationBar.largeTitleTextAttributes = textChangeColor
    }
    func getWindSpeed() -> String{
        
        let windSpeed = "\((daily.wind_speed * 3.6).roundedString(to: 1)) Km/h"
        switch daily.wind_deg {
        case 0, 360: return "N \(windSpeed)"
        case 90: return "E \(windSpeed)"
        case 180: return "S \(windSpeed)"
        case 270: return "W \(windSpeed)"
        case 1..<90: return "NE \(windSpeed)"
        case 91..<180: return "SE \(windSpeed)"
        case 181..<270: return "SW \(windSpeed)"
        case 271..<360: return "NW \(windSpeed)"
        default: return windSpeed
        }
    }
}
    


