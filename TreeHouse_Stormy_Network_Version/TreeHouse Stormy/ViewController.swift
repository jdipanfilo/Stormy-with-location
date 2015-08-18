//
//  ViewController.swift
//  TreeHouse Stormy
//
//  Created by John DiPanfilo on 8/9/15.
//  Copyright (c) 2015 bc9000. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIAlertViewDelegate {
    
    //Creating an outlet for the temperature label. Learning practive of not forcing the unwrap for the label.
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    //Humidity label
    @IBOutlet weak var currentHumidityLabel: UILabel?
    //Precipitation label
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    //Current Weather Icon
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    //Current Weather Summary label
    @IBOutlet weak var currentWeatherSummary: UILabel?
    //Refresh Button outlet for animation purposes
    @IBOutlet weak var refreshButton: UIButton?
    //Activity Indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //Location Name label
    @IBOutlet weak var locationNameLabel: UILabel?
    
    //API Key for forecast.io
    private let forecastAPIKey = ""
    //Creating a constant that holds my desired URL, this one is a demo URL
//    let foreCasturl = NSURL(string: "https://api.forecast.io/forecast/602ee81999703a8e51b694954669d8e5/37.8267,-122.423")
    
    //Location services init
    let locationManagerService = CLLocationManager()
    //Error messages for location services
    let authorizationErrorMessage = "Stormy cannot tell you the weather if I can't see where I am."
    let networkErrorMessage = "Unable to access the network."
    let locationErrorMessage = "Unable to obtain your location."
    
    
    //Variables utilized to create location service functions.
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var userLocation : String!
    var userLatitude : Double?
    var userLongitude : Double?
    
    //Original location stagnant constant
//    let coordinate: (lat: Double, long: Double) = (37.8267,-122.423)

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //I am presently working on making the status bar switch to the light content mode. I have not had any luck:(
//                UIApplication.sharedApplication().statusBarStyle = .LightContent
        refreshWeather()

    }

    //Location services in three functions
    //This function triggers location services and checks if the user has approved for "Always".
    func getCurrentLocation() {
        locationManagerService.delegate = self
        locationManagerService.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            locationManagerService.requestAlwaysAuthorization()
        } else {
            locationManagerService.startUpdatingLocation()
        }
    }
    
    //Checks is the user authoized location services and if so spins up the service.
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        let authorized = status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.AuthorizedAlways
        println(authorized)
        if(authorized) {
            locationManagerService.startUpdatingLocation()
        }
    }
    

    
    //Function to pull the location data and place it into an array
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location: CLLocation = locations[0] as! CLLocation
        let coordinate: CLLocationCoordinate2D = location.coordinate
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if(error == nil) {
                if (placemarks.count > 0) {
                    let placemark = placemarks[0] as! CLPlacemark
//                    self.userLatitude = placemark.location.coordinate.latitude
//                    self.userLongitude = placemark.location.coordinate.longitude
                    println(coordinate.latitude)
                    println(coordinate.longitude)
                    self.locationNameLabel!.text! = "\(placemark.subLocality), \(placemark.locality)"
                    println(placemark.locality)
                    self.retriveWeatherForecast(coordinate.latitude, long: coordinate.longitude)
                    println()
            } else {
                self.handleErrorWithMessage(self.locationErrorMessage)
            }
            } else {
            self.handleErrorWithMessage(self.locationErrorMessage)
        }
    })

    }


    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        handleErrorWithMessage(locationErrorMessage)
    }
    
    


    


//    Updated with pulled lat and long data. This function
    func retriveWeatherForecast(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        let locationServiceLat = lat
        let locationServicesLong = long
        
        forecastService.getForecast(locationServiceLat, long: locationServicesLong) {
            (let currently) in
            if let currentWeather = currently {
                //Update UI
                dispatch_async(dispatch_get_main_queue()) {
                    //Execute closure
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                    }
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "\(precipitation)%"
                    }
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    if let summary = currentWeather.summary {
                        self.currentWeatherSummary?.text = summary
                    }
                    self.toggleRefreshAnimation(false)
                }
            }
        }
    }
    
    
    
    //Refresh button
    @IBAction func refreshWeather() {
        
        toggleRefreshAnimation(true)
        getCurrentLocation()
        self.viewDidLoad()
    
        println(userLocation)
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton?.hidden = on
        if on {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }
    
    //When researhing location services I came across this method and foud that it was a champ at error handling.
    func handleErrorWithMessage(message: String) {
        let networkIssueController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        networkIssueController.addAction(okButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        networkIssueController.addAction(cancelButton)
        
        presentViewController(networkIssueController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




