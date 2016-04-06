//
//  CurrentWeather.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import UIKit
import CoreData



enum Icon: String {
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"
    case Fog = "fog"
    case Cloudy = "cloudy"
    case PartlyCloudyDay = "partly-cloudy-day"
    case PartlyCloudyNight = "partly-cloudy-night"


func toImage() -> UIImage? {
    var imageName: String
    
    switch self {
    case .ClearDay:
        imageName = "clear-day.png"
    case .ClearNight:
        imageName = "clear-night.png"
    case .Rain:
        imageName = "rain.png"
    case .Snow:
        imageName = "snow.png"
    case .Sleet:
        imageName = "sleet.png"
    case .Wind:
        imageName = "wind.png"
    case .Fog:
        imageName = "fog.png"
    case .Cloudy:
        imageName = "cloudy.png"
    case .PartlyCloudyDay:
        imageName = "cloudy-day.png"
    case .PartlyCloudyNight:
        imageName = "cloudy-night.png"
    }

    return UIImage(named: imageName)
}
}


struct CurrentWeather {
    
    let temperature: Int?
    let temperatureMin : Float?
    let temperatureMax: Float?
    let humidity: Int?
    let precipProbability: Int?
    let summary: String?
    let dewPoint : Float?
    let windSpeed : Float?
    let pressure : Float?
    let visibility : Float?
    let time : Double?
    var currentWeatherParams = [NSManagedObject]()
    let iconName : String?

    
    var icon : UIImage? = UIImage(named: "default.png")
    
    init(weatherDictionary: [String : AnyObject]) {
        
        temperature = weatherDictionary["temperature"] as? Int
        
        if let humidityFloat = weatherDictionary["humidity"] as? Double {
            humidity = Int(humidityFloat * 100)
        }
        else{
            humidity = nil
        }
        if let precipProbabilityFloat = weatherDictionary["precipProbability"] as? Double {
            precipProbability = Int(precipProbabilityFloat * 100)
        }
        else{
            precipProbability = nil
        }
        
        if let summaryInfo = weatherDictionary["summary"] as? String {
        summary = summaryInfo
        }
        else{
        summary = nil
        }
        
        if let iconInfo = weatherDictionary["icon"] as? String,let weatherIcon : Icon = Icon(rawValue : iconInfo)  {
            
            icon = weatherIcon.toImage()
            
        }
        if let iconName = weatherDictionary["icon"] as? String {
            
            self.iconName = iconName
        }
        else{
            self.iconName = nil
        }
        
        if let minTemp = weatherDictionary["temperatureMin"] as? Float {
            self.temperatureMin = minTemp
        }
        else{
            self.temperatureMin = nil
        }
        
        if let maxTemp = weatherDictionary["temperatureMax"] as? Float {
            self.temperatureMax = maxTemp
        }
        else{
            self.temperatureMax = nil
        }
        
        if let windSpeedInfo = weatherDictionary["windSpeed"] as? Float {
            self.windSpeed = windSpeedInfo
        }
        else{
            self.windSpeed = nil
        }

        if let dewPointInfo = weatherDictionary["dewPoint"] as? Float {
            self.dewPoint = dewPointInfo
        }
        else{
            self.dewPoint = nil
        }

        if let visibilityInfo = weatherDictionary["visibility"] as? Float {
            self.visibility = visibilityInfo
        }
        else{
            self.visibility = nil
        }

        if let pressureInfo = weatherDictionary["pressure"] as? Float {
            self.pressure = pressureInfo
        }
        else{
            self.pressure = nil
        }

        if let timeInfo = weatherDictionary["time"] as? Double {
            self.time = timeInfo
        }
        else{
            self.time = nil
        }
    
    }
    
    
    }