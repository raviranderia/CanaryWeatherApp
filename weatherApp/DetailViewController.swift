//
//  DetailViewController.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var daySelected : CurrentWeather?
    
    @IBOutlet var summaryLabel: UILabel?
    @IBOutlet var minimumTemperatureLabel: UILabel?
    @IBOutlet var maximumTemperatureLabel: UILabel?
    @IBOutlet var humidityLabel: UILabel?
    @IBOutlet var precipitationProbablityLabel: UILabel?
    @IBOutlet var windSpeedLabel: UILabel?
    @IBOutlet var dewPointLabel: UILabel?
    @IBOutlet var visibilityLabel: UILabel?
    @IBOutlet var pressureLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentDay = daySelected {
            if let summaryInfo = currentDay.summary {
            summaryLabel?.text = summaryInfo
            }
       
            
            if let minTemp = currentDay.temperatureMin {
                
                minimumTemperatureLabel?.text = "\(minTemp)"
                
            }
            if let maxTemp = currentDay.temperatureMax {
                maximumTemperatureLabel?.text = "\(maxTemp)"

                
            }
            if let humidityInfo = currentDay.humidity {
                humidityLabel?.text = "\(humidityInfo)"

            }
            if let precipInfo = currentDay.precipProbability {
                
                precipitationProbablityLabel?.text = "\(precipInfo)"

            }
            if let windSpeedInfo = currentDay.windSpeed {
                windSpeedLabel?.text = "\(windSpeedInfo)"
            }
            
            if let dewPointInfo = currentDay.dewPoint {
                dewPointLabel?.text = "\(dewPointInfo)"

            }
            if let visibilityInfo = currentDay.visibility {
                visibilityLabel?.text = "\(visibilityInfo)"

            }
            
            if let pressureInfo = currentDay.pressure {
                pressureLabel?.text = "\(pressureInfo)"

            }
        
            
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
