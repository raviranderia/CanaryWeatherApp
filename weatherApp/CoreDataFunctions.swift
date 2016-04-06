//
//  CoreDataFunctions.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation
import CoreData
import UIKit


struct CoreDataFunctions {
    var currentWeatherList = [NSManagedObject]()

    
    func saveCurrentWeatherInPhoneStorage(currentWeather : CurrentWeather, entityName : String){
        self.deletePreviousValues(entityName)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //Data is in this case the name of the entity
        let entity = NSEntityDescription.entityForName(entityName,
                                                       inManagedObjectContext: managedContext)
        let options = NSManagedObject(entity: entity!,
                                      insertIntoManagedObjectContext:managedContext)
        options.setValue(currentWeather.time, forKey: "time")
        options.setValue(currentWeather.dewPoint, forKey: "dewPoint")
        options.setValue(currentWeather.humidity, forKey: "humidity")
        options.setValue(currentWeather.precipProbability, forKey: "precipProbability")
        options.setValue(currentWeather.pressure, forKey: "pressure")
        options.setValue(currentWeather.summary, forKey: "summary")
        options.setValue(currentWeather.temperature, forKey: "temperature")
        options.setValue(currentWeather.visibility, forKey: "visibility")
        options.setValue(currentWeather.windSpeed, forKey: "windSpeed")
        options.setValue(currentWeather.temperatureMin, forKey: "temperatureMin")
        options.setValue(currentWeather.temperatureMax, forKey: "temperatureMax")
        options.setValue(currentWeather.iconName, forKey: "icon")

            do {
                try managedContext.save()
            }
            catch{
                print(error)
            }
    }
    
    func read(completion : (CurrentWeather?,[CurrentWeather]?) -> () )
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "CurrentWeather")
        
        do{
        let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            self.readWeekly({ (weeklyWeather) in
                
                if let weeklyWeather = weeklyWeather {
                    
                    if fetchedResults.count > 0 {
                        let single_result = fetchedResults[0]
                        print(single_result.toDictionary())
                        completion(CurrentWeather(weatherDictionary: single_result.toDictionary()),weeklyWeather)
                    }
                }
            })
//            completion(CurrentWeather(weatherDictionary: single_result.toDictionary()))
        }
        catch{
            completion(nil,nil)
            print("error")
        }
    }
    
    func readWeekly(completion : ([CurrentWeather]?) -> ()) {
        
        var weeklyUpdate = [(CurrentWeather)]()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        for var i = 1 ; i < 8 ; i += 1 {
            
            let fetchRequest = NSFetchRequest(entityName: "CurrentWeather\(i)")

            
            do{
                let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
                
                if fetchedResults.count > 0 {
                    
                    let single_result = fetchedResults[0]
                    print(single_result.toDictionary())
                    weeklyUpdate.append(CurrentWeather(weatherDictionary: single_result.toDictionary()))
                }
                
                //            completion(CurrentWeather(weatherDictionary: single_result.toDictionary()))
            }
            catch{
                print("error")
            }
        }
        completion(weeklyUpdate)
        
        
    }
    
    
    func deletePreviousValues(nameOfEntity : String) {
        
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: nameOfEntity)
        
            do{
                let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
                
                for item in fetchedResults {
                    managedContext.deleteObject(item)
                }
                do {
                    try managedContext.save()
                }
                catch{
                    print("could not delete all objects")
                }
            }
            catch{
                print("error")
            }
    }
    
    
}


extension NSManagedObject{
    
    // The method copies NSManageObject into a Dictionary. the method initially goes through NSManageObject's attributes, copying each attribute then it goes through its relations. By recurisve calls relation objects are transformed into dictionary, which are then placed into the parent Dictionary. In order to avaid circular relations, the Objects that have already been traversed are placed in to a set  and if they are visited again they are ignored
    private func toDictionaryWithTraversal(traversalHistory: NSMutableSet? = nil)->[String: AnyObject]{
        
        let attributes = self.entity.attributesByName
        let relationships = self.entity.relationshipsByName
        let capacity = self.entity.attributesByName.count + self.entity.relationshipsByName.count + 1
        var dict = [String: AnyObject]()
        
        let localTraversalHistory = traversalHistory ?? NSMutableSet(capacity: capacity)
        localTraversalHistory.addObject(self)
        dict["class"] = self.entity.name!
        
        //println("Going through Object attributes...")
        for (attr, _) in attributes{
            let value: AnyObject? = self.valueForKey(attr as String)
            if value != nil {
                if let v = value as? NSCoding{
                    dict[attr as String]  = value!
                }else{
                    print("Attribute is not NSCoding complient")
                }
            }
        }
        //println("attributes copied")
        
        //println("Going through Object relationships...")
        for (rel, _) in relationships{
            let value: AnyObject? = self.valueForKey(rel as String)
            switch value {
            // To-many relationship
            case let relatedObjects as NSSet:
                // Our set holds a collection of dictionaries
                var dictSet = [[String: AnyObject]]()
                
                for object in relatedObjects {
                    if !localTraversalHistory.containsObject(object){
                        dictSet.append(
                            (object as! NSManagedObject).toDictionaryWithTraversal(localTraversalHistory))
                    }
                }
                dict[rel as String] =  dictSet
            // To-one relationship
            case let object as NSManagedObject where !localTraversalHistory.containsObject(object) :
                // Call toDictionary on the referenced object and put the result back into our dictionary.
                dict[rel as String] =  object.toDictionaryWithTraversal(localTraversalHistory)
            default:
                // there are two types of nil
                //1. non initialised/set attribtues/objects
                //2. inverse relationships
                print("inverse reached")
                
                
            }
        }
        //println("\(self.entity.name!) Relationships copied")
        
        if traversalHistory == nil {
            localTraversalHistory.removeAllObjects()
        }
        return dict
    }
    
    
    //Public method
    func toDictionary()->[String: AnyObject]{
        return self.toDictionaryWithTraversal()
    }

    
    
}