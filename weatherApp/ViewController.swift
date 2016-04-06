//
//  ViewController.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData



class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var refreshButtonOutlet: UIButton?
    @IBOutlet var temperatureLabelOutlet: UILabel?
    @IBOutlet var precipitationLabelOutlet: UILabel?
    @IBOutlet var humidityLabelOutlet: UILabel?
    @IBOutlet var currentWeatherIcon: UIImageView?
    @IBOutlet var summaryOutletLabel: UILabel?
    @IBOutlet var currentLocationLabelOutlet: UILabel!
    
    let transition = PopAnimator()
    var selectedImage: UIImageView?
    var transitionIndexPath = NSIndexPath()

    
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    var weeklyForecast = [CurrentWeather]()
    var coreData = CoreDataFunctions()
    
    let locationDelegate = LocationServices()
    let weekOperation = WeekOperation()
    var defaultAddress = "Alcatraz, California"
    
    private let forecastAPIKey = "Your_API_Key"
    
    var coordinate: (lat : Double, long : Double) = (37.8267,-122.423)
    
    // Add your code below
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveWeatherForecast()
       }
    
    func toggleRefreshButton(on : Bool) {
        
        refreshButtonOutlet?.hidden = on
        if on {
            activityIndicator?.startAnimating()
        }
        else{
            activityIndicator?.stopAnimating()
        }
        
        
    }

    func retrieveWeatherForecast(){
        
        self.checkForCurrentLocation { (success) in
            if success {
                let forecastService = ForecastService(APIKey: self.forecastAPIKey)
                forecastService.getForecast(self.coordinate.lat, long: self.coordinate.long) { (currently,weekly) -> (Void) in
            
                    if let currentWeather = currently,let weekWeather = weekly {
                        dispatch_async(dispatch_get_main_queue()) {
                            //Execute Closure
                            self.populateLabels(currentWeather, weekWeather: weekWeather)
                        }
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue()) {
                        self.coreData.read({ (value,weeklyValue) in
                            if let value = value, let weeklyValue = weeklyValue {
                            self.populateLabels(value, weekWeather: weeklyValue)
                            }
                            else{
                                self.populateLabels(value!, weekWeather: nil)
                            }
                        })
                        }
                    }
                }
            }
        }
    }
    
    
    func populateLabels(currentWeather : CurrentWeather, weekWeather : [CurrentWeather]?){
        
        
        if let temperature = currentWeather.temperature {
            self.temperatureLabelOutlet?.text = "\(temperature)º"
        }
        if let precProb = currentWeather.precipProbability {
            self.precipitationLabelOutlet?.text = "\(precProb)%"
        }
        if let humidity = currentWeather.humidity{
            self.humidityLabelOutlet?.text = "\(humidity)%"
        }
        if let iconInfo = currentWeather.icon {
            self.currentWeatherIcon?.image = iconInfo
        }
        if let summaryInfo = currentWeather.summary{
            self.summaryOutletLabel?.text = summaryInfo
        }
        
        if let weekWeather = weekWeather {
        self.weeklyForecast = weekWeather
        }
        self.collectionViewOutlet.reloadData()
        
        self.currentLocationLabelOutlet.text = self.defaultAddress
        self.toggleRefreshButton(false)
        
        
    }
    
    func checkForCurrentLocation(completion : (Bool) -> ()){
        locationDelegate.getCurrentLocation { (currentLocation, address) in
            if let currentLocation = currentLocation {
                self.coordinate = (currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
            }
            if let address = address {
                self.defaultAddress = address
            }
         completion(true)
        }
        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.weeklyForecast.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(self.weeklyForecast[indexPath.row].summary)
        self.transitionIndexPath = indexPath
        self.selectedImage?.image = self.weeklyForecast[indexPath.row].icon
        let detailView = storyboard!.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
        detailView.daySelected = self.weeklyForecast[indexPath.row]
        detailView.transitioningDelegate = self
        presentViewController(detailView, animated: true, completion: nil)
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailSegue" {
            
            if let destinationVC =  segue.destinationViewController as? DetailViewController {
                
                if let selectedRow = collectionViewOutlet.indexPathsForSelectedItems()?.first!.row {
                destinationVC.daySelected = self.weeklyForecast[selectedRow]
                }
            }
            
        }
    }
  
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ForecastCollectionViewCell
        let currentRow = indexPath.row
        cell.summaryLabelOutlet.text = self.weeklyForecast[currentRow].summary
        cell.iconImageOutlet.image = self.weeklyForecast[currentRow].icon
        
        
        if let time = self.weeklyForecast[currentRow].time {
            
            if let dayOfWeek = weekOperation.getDayOfWeek(time) {
                cell.dayLabelOutlet.text = dayOfWeek
            }
            
        }
       
        if let minTemp = self.weeklyForecast[currentRow].temperatureMin, let maxTemp = self.weeklyForecast[currentRow].temperatureMax {
             cell.minMaxTemperatureLabel.text = "↓\(minTemp)" + "\n" + "↑\(maxTemp)"
        }
        
       
        
        return cell
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        toggleRefreshButton(true)
        retrieveWeatherForecast()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
                             sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            
//            transition.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame, toView: nil)
            transition.originFrame = self.collectionViewOutlet.cellForItemAtIndexPath(self.transitionIndexPath)!.convertRect( (self.collectionViewOutlet.cellForItemAtIndexPath(self.transitionIndexPath)?.contentView.frame)!, toView: nil)

            transition.presenting = true
            return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
}

