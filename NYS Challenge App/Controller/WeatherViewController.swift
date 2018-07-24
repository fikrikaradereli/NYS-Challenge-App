//
//  WeatherViewController.swift
//  NYS Challenge App
//
//  Created by Fikri Karadereli on 21.07.2018.
//  Copyright © 2018 Fikri Karadereli. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    
    // Constants
    let SECRET_KEY = "c0452f58ff89bd40e962e271ecce5651"
    
    
    // Variables
    let locationManager = CLLocationManager()
    let todayWeather = Weather()
    let firstDayWeather = Weather()
    let secondDayWeather = Weather()
    let thirdDayWeather = Weather()

    
    // IBOutlets
    @IBOutlet weak var todayTemperatureLabel: UILabel!
    @IBOutlet weak var todayIconImageView: UIImageView!
    
    @IBOutlet weak var firstDayIconImageView: UIImageView!
    @IBOutlet weak var firstDayTemperatureLabel: UILabel!
    @IBOutlet weak var secondDayIconImageView: UIImageView!
    @IBOutlet weak var secondDayTemperatureLabel: UILabel!
    @IBOutlet weak var thirdDayIconImageView: UIImageView!
    @IBOutlet weak var thirdDayTemperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // for permission
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        addShareBarItemButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addShareBarItemButton()
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            print("\nlatitude: \(latitude) longitude: \(longitude)")

            getWeatherData(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        todayTemperatureLabel.text = "Location unavailable"
    }
    
    
    //MARK: - Networking
    /***************************************************************/

    func getWeatherData(latitude: String, longitude: String) {
        
        let coordinates = String(describing: latitude) + "," + String(describing: longitude)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.darksky.net"
        components.path = "/forecast/\(SECRET_KEY)/\(coordinates)"
        
        let url = components.url
        let parameters = ["exclude":"minutely,hourly,alerts,flags", "lang":"tr", "units":"si"]
        
        Alamofire.request(url!, method: .get, parameters: parameters).responseJSON { response in
            
            if response.result.isSuccess {

                let weatherJSON: JSON = JSON(response.result.value!)
                self.parseWeatherData(json: weatherJSON)

            } else {
                print("Error \(String(describing: response.result.error))")
                self.todayTemperatureLabel.text = "Connection issues"
            }
        }
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func parseWeatherData(json: JSON) {

        if let temperature = json["currently"]["temperature"].int {

            todayWeather.temperature = temperature
            todayWeather.iconName = json["currently"]["icon"].stringValue

        } else {
            todayTemperatureLabel.text = "Weather Unavailable"
        }
        
        let data = json["daily"]["data"]
        
        // data[0] is today's weather info
        
        firstDayWeather.temperature = data[1]["temperatureHigh"].intValue
        firstDayWeather.iconName = data[1]["icon"].stringValue
        
        secondDayWeather.temperature = data[2]["temperatureHigh"].intValue
        secondDayWeather.iconName = data[2]["icon"].stringValue
        
        thirdDayWeather.temperature = data[3]["temperatureHigh"].intValue
        thirdDayWeather.iconName = data[3]["icon"].stringValue
        
        updateUIWithWeatherData()
    }
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData() {
        
        todayTemperatureLabel.text = String(todayWeather.temperature) + "°"
        todayIconImageView.image = UIImage(named: todayWeather.iconName)
        
        firstDayTemperatureLabel.text = String(firstDayWeather.temperature) + "°"
        firstDayIconImageView.image = UIImage(named: firstDayWeather.iconName)
        
        secondDayTemperatureLabel.text = String(secondDayWeather.temperature) + "°"
        secondDayIconImageView.image = UIImage(named: secondDayWeather.iconName)
        
        thirdDayTemperatureLabel.text = String(thirdDayWeather.temperature) + "°"
        thirdDayIconImageView.image = UIImage(named: thirdDayWeather.iconName)
    }
    
    
    //MARK: - Share Button Functions
    /***************************************************************/
    
    func addShareBarItemButton() {
        
        let shareBarButtonItem = UIBarButtonItem(title: "Paylaş", style: .plain, target: self, action: #selector(WeatherViewController.shareButtonAction(_:)))

        self.tabBarController?.navigationItem.setRightBarButton(shareBarButtonItem, animated: true)
    }
    
    @objc func shareButtonAction(_ sender: UIBarButtonItem) {
        let ss = takeScreenshot()
        shareContentAsImage(ss!)
    }
    
    func takeScreenshot() -> UIImage? {
        
        var screenshotImage :UIImage?
        let layer = self.view.layer //UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshotImage
    }
    
    func shareContentAsImage(_ image: UIImage) {
        
        let shareItems = [image] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(activityViewController, animated: true) {
            // Some stuff
        }
    }
    
}
