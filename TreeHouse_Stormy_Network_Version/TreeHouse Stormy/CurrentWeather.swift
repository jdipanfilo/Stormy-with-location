//
//  CurrentWeather.swift
//  TreeHouse Stormy
//
//  Created by John DiPanfilo on 8/9/15.
//  Copyright (c) 2015 bc9000. All rights reserved.
//

import Foundation
import UIKit

//Enum for using the "icon" data from the weatherDictionary to dislay a coresponding icon on the main view.
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
    
    //Method to display the correct image.
    func toImage() -> UIImage? {
        var imageName: String
        //There was a incorrect image name in course that I corrected.
        switch self {
        case Icon.ClearDay:
            imageName = "clear-day"
        case Icon.ClearNight:
            imageName = "clear-night"
        case Icon.Rain:
            imageName = "rain"
        case Icon.Snow:
            imageName = "snow"
        case Icon.Sleet:
            imageName = "sleet"
        case Icon.Wind:
            imageName = "wind"
        case Icon.Fog:
            imageName = "fog"
        case Icon.Cloudy:
            imageName = "cloudy"
        case Icon.PartlyCloudyDay:
//            imageName = "partly-cloudy-day"
            imageName = "cloudy-day"
        case Icon.PartlyCloudyNight:
//            imageName = "partly-cloudy-night"
            imageName = "cloudy_night"
        }
        
        return UIImage(named: imageName)
    }
}


//Struct that works through the weatherDictionary created from the pulled JSON data
struct CurrentWeather {
    let temperature: Int?
    let humidity: Int?
    let precipProbability: Int?
    let summary: String?
    var icon: UIImage? = UIImage(named: "default.png")
    
    init(weatherDictionary: [String: AnyObject]) {
        temperature = weatherDictionary["temperature"] as? Int
        if let humidityFloat = weatherDictionary["humidity"] as? Double {
           humidity = Int(humidityFloat*100)
            
        } else {
            humidity = nil
        }
        if let precipFloat = weatherDictionary["precipProbability"] as? Double {
           precipProbability = Int(precipFloat*100)
            
        } else {
            precipProbability = nil
        }
        summary = weatherDictionary["summary"] as? String
        
        if let iconString = weatherDictionary["icon"] as? String, let weatherIcon: Icon = Icon(rawValue: iconString) {
            icon = weatherIcon.toImage()
        }
    }
}
