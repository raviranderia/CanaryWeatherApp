//
//  ForecastService.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

struct ForecastService {
    
    let forecastAPIKey : String
    let forecastBaseURL : NSURL?
    private var coreData = CoreDataFunctions()
    init(APIKey : String){
        
        self.forecastAPIKey = APIKey
        self.forecastBaseURL = NSURL(string:  "https://api.forecast.io/forecast/\(self.forecastAPIKey)/")
    }
    
    func getForecast(lat: Double, long: Double, completion: (CurrentWeather?,[CurrentWeather]?) -> (Void) ){
        
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: self.forecastBaseURL){
            
            let networkOperation = NetworkOperation(url: forecastURL)
            networkOperation.downloadJSONFromURL({ (JSONDictionary) in
                
                if JSONDictionary != nil {
                
                completion(self.currentWeatherFromJSON(JSONDictionary), self.getWeekForecast(JSONDictionary))
                }
                else{
                    completion(nil,nil)
                }
                
            })
            
        }
        else{
            print(forecastBaseURL)
            print("could not construct valid url")
            completion(nil,nil)
        }
        
    }
    
    func currentWeatherFromJSON(jsonDictionary : [String : AnyObject]?) -> CurrentWeather? {
        
        if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String: AnyObject]{
            
//            coreData.saveCurrentWeatherInPhoneStorage(CurrentWeather(weatherDictionary: currentWeatherDictionary))
            coreData.saveCurrentWeatherInPhoneStorage(CurrentWeather(weatherDictionary: currentWeatherDictionary), entityName: "CurrentWeather")
            return CurrentWeather(weatherDictionary: currentWeatherDictionary)
            
        }
        else{
            print("returned nil for currently key")
            return nil
        }
        
    }
    
    
    func getWeekForecast(jsonDictionary : [String : AnyObject]?) -> [CurrentWeather]? {
        
        var weeklyForecast = [CurrentWeather]()
        if let weeklyWeatherDictionary = jsonDictionary?["daily"] as? [String: AnyObject]{
            
            if let dayInAWeekDictionary = weeklyWeatherDictionary["data"] as? [[String:AnyObject]] {
                var count = 1
                for day in dayInAWeekDictionary {
                    
                        weeklyForecast.append(CurrentWeather(weatherDictionary: day))
                        self.coreData.saveCurrentWeatherInPhoneStorage(CurrentWeather(weatherDictionary: day), entityName: "CurrentWeather\(count)")
                        count += 1
                    
                }
               return weeklyForecast
            }
            else{
                print("not parse properly")
                return nil
            }
        }
        else{
            print("returned nil for currently key")
            return nil
        }
    }
}