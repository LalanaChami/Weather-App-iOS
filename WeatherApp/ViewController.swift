//
//  ViewController.swift
//  WeatherApp
//
//  Created by Lalana Thanthirigama on 2024-11-04.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tempToggleButton: UISwitch!
    @IBOutlet weak var searchInputFeild: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    
    let locationManager = CLLocationManager()
    private var isCelcius: Bool = true
    private var weatherData: WeatherResponseType? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLocationClick()
        tempToggleButton.isEnabled = false
    }
    
    @IBAction func onTempToggle(_ sender: UISwitch) {
        isCelcius.toggle()
        if let weatherData = self.weatherData {
            self.weatherLabel.text = isCelcius ?  "\(weatherData.current?.tempC ?? 0)°C" : "\(weatherData.current?.tempF ?? 0)°F"
        }
    }
    
    @IBAction func onLocationClick() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled")
        }
        
        searchInputFeild.endEditing(true)
        
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            print("Current location: \(currentLocation)")
            let longitude = currentLocation.coordinate.longitude
            let latitude = currentLocation.coordinate.latitude
            
            self.getWeather(for: "\(latitude),\(longitude)")
            locationManager.stopUpdatingLocation()
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted.")
        case .denied, .restricted:
            print("Location access denied.")
        case .notDetermined:
            print("Location access not determined yet.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }
    
    @IBAction func onSearchClick(_ sender: UIButton) {
        let searchText = searchInputFeild.text
        if let searchText = searchText {
            getWeather(for: searchText)
        }
        searchInputFeild.endEditing(true)
    }
    
    @IBAction func onSearchTextChange(_ sender: Any) {
        
    }
    
    private func getWeather(for location: String) {
        let baseURL = "https://api.weatherapi.com/v1/current.json?key="
        let apiKey = "c1c6b9b8a1b4454a80f20034240511"
        let location = "&q=\(location)&aqi=no"
        let urlString = baseURL + apiKey + location
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data else { return }
            
            do {
                let weather = try JSONDecoder().decode(WeatherResponseType.self, from: data)
                self.weatherData = weather
                self.setWeatherData(weather)
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }.resume()
        
    }
    
    
    private func setWeatherData(_ weather: WeatherResponseType?) {
        DispatchQueue.main.async {
            self.tempToggleButton.isEnabled = true
            let code = weather?.current?.condition?.code ?? 0
            let isDaytime = weather?.current?.isDay == 1 ? true : false
            let weatherCondition = self.getWeatherCondition(for: code, isDaytime: isDaytime)
            
            self.weatherLabel.text = self.isCelcius ? "\(weather?.current?.tempC ?? 0)°C" : "\(weather?.current?.tempF ?? 0)°F"
            self.weatherDescription.text = weather?.current?.condition?.text
            self.searchInputFeild.text = weather?.location?.name
            self.locationLabel.text = weather?.location?.name
            
            let icon = UIImage(systemName: weatherCondition.icon)
            let paletteConfig = UIImage.SymbolConfiguration(paletteColors: [UIColor.systemBlue, UIColor.systemYellow])
            let multiColorIcon = icon?.applyingSymbolConfiguration(paletteConfig)

            self.weatherIcon.image = multiColorIcon
            self.addAnimation(to: self.weatherIcon)
            self.backgroundImage.image = weatherCondition.backgroundImage
        }
    }

    private func addAnimation(to view: UIView) {
        let pulsate = CAKeyframeAnimation(keyPath: "transform.scale")
            pulsate.values = [1.0, 1.1, 1.0]
            pulsate.keyTimes = [0, 0.5, 1]
            pulsate.duration = 1.2
            pulsate.repeatCount = .infinity
            view.layer.add(pulsate, forKey: "pulsateAnimation")
    }


    
    
    
    
    private func getWeatherCondition(for code: Int?, isDaytime: Bool?) -> WeatherCondition {
        if let code = code, let isDaytime = isDaytime {
            switch code {
            case 1000:
                return WeatherCondition(
                    backgroundImage: UIImage(named: isDaytime ? "sunnyDayBackground" : "clearNightBackground")!,
                    icon: "sun.max.fill",
                    description: isDaytime ? "Sunny" : "Clear"
                )
            case 1003:
                return WeatherCondition(
                    backgroundImage: UIImage(named: isDaytime ? "partlyCloudyDayBackground" : "partlyCloudyNightBackground")!,
                    icon: "cloud.sun.fill",
                    description: "Partly cloudy"
                )
            case 1006:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "cloudyBackground")!,
                    icon: "cloud.fill",
                    description: "Cloudy"
                )
            case 1009:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "overcast")!,
                    icon: "smoke.fill",
                    description: "Overcast"
                )
            case 1030:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "mistBackground")!,
                    icon: "cloud.fog.fill",
                    description: "Mist"
                )
            case 1063:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "patchyRainPossibleBackground")!,
                    icon: "cloud.drizzle.fill",
                    description: "Patchy rain possible"
                )
            case 1066:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "patchySnowPossibleBackground")!,
                    icon: "cloud.snow.fill",
                    description: "Patchy snow possible"
                )
            case 1069:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "patchySleetPossibleBackground")!,
                    icon: "cloud.sleet.fill",
                    description: "Patchy sleet possible"
                )
            case 1072:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "patchyFreezingDrizzlePossibleBackground")!,
                    icon: "cloud.hail.fill",
                    description: "Patchy freezing drizzle possible"
                )
            case 1087:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "thunderyOutbreaksPossibleBackground")!,
                    icon: "cloud.bolt.fill",
                    description: "Thundery outbreaks possible"
                )
            case 1114:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "blowingSnowBackground")!,
                    icon: "wind.snow",
                    description: "Blowing snow"
                )
            case 1117:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "blizzardBackground")!,
                    icon: "cloud.snow.fill",
                    description: "Blizzard"
                )
            case 1135:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "fogBackground")!,
                    icon: "cloud.fog.fill",
                    description: "Fog"
                )
            case 1147:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "freezingFogBackground")!,
                    icon: "cloud.fog.fill",
                    description: "Freezing fog"
                )
            case 1150:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "patchyLightDrizzleBackground")!,
                    icon: "cloud.drizzle.fill",
                    description: "Patchy light drizzle"
                )
            case 1153:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "patchyLightDrizzleBackground")!,
                    icon: "cloud.drizzle.fill",
                    description: "Light drizzle"
                )
            case 1168:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "freezingDrizzleBackground")!,
                    icon: "cloud.hail.fill",
                    description: "Freezing drizzle"
                )
            case 1171:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "heavyFreezingDrizzleBackground")!,
                    icon: "cloud.hail.fill",
                    description: "Heavy freezing drizzle"
                )
            case 1180:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "patchyLightRainBackground")!,
                    icon: "cloud.rain.fill",
                    description: "Patchy light rain"
                )
            case 1183:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "patchyLightRainBackground")!,
                    icon: "cloud.rain.fill",
                    description: "Light rain"
                )
            case 1186:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "moderateRainBackground")!,
                    icon: "cloud.heavyrain.fill",
                    description: "Moderate rain"
                )
            case 1195:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "heavyRainBackground")!,
                    icon: "cloud.heavyrain.fill",
                    description: "Heavy rain"
                )
            case 1204:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "lightSleetBackground")!,
                    icon: "cloud.sleet.fill",
                    description: "Light sleet"
                )
            case 1243:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "heavyRainBackground")!,
                    icon: "cloud.heavyrain.fill",
                    description: "Heavy rain showers"
                )
                
            default:
                return WeatherCondition(
                    backgroundImage: UIImage(named: "defaultBackground")!,
                    icon: "questionmark.circle",
                    description: "Unknown"
                )
            }
        } else {
            return WeatherCondition(
                backgroundImage: UIImage(named: "defaultBackground")!,
                icon: "questionmark.circle",
                description: "Unknown"
            )
        }
    }
}
