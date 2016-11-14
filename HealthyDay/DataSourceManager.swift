//
//  DataSourceManager.swift
//  HealthyDay
//
//  Created by Linsw on 16/11/14.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import CoreData

internal final class DataSourceManager{
    static let sharedDataSourceManager = DataSourceManager()

    fileprivate var objects = [NSManagedObject]()

    private init(){
    }
    
//MARK: DataSource API
    internal func getAllRunningData()->[DistanceDetailItem]{
        return dataSource == .linshiwei_win ? getAllRunningDataFromServer() : getAllRunningDataFromCoreData()
    }
    
    internal func saveOneRunningData(dataItem: DistanceDetailItem){
        dataSource == .linshiwei_win ? saveOneRunningDataToServer(dataItem: dataItem) : saveOneRunningDataToCoreData(dataItem: dataItem)
    }
    
    internal func deleteOneRunningData(dataItem: DistanceDetailItem){
        dataSource == .linshiwei_win ? deleteOneRunningDataInServer(dataItem: dataItem) : deleteOneRunningDataInCoreData(dataItem: dataItem)
    }
    
//MARK: CoreData data
    private func getAllRunningDataFromCoreData()->[DistanceDetailItem]{
        var distances = [DistanceDetailItem]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Running")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            objects = try getManagedContext().fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if objects.count > 0 {
            for object in objects {
                if let date = object.value(forKey: "date") as? Date,let distance = object.value(forKey: "distance") as? Double,let duration = object.value(forKey: "duration") as? Int,let durationPerKilometer = object.value(forKey: "durationPerKilometer") as? Int{
                    distances.append(DistanceDetailItem(date: date, distance: distance, duration: Int(duration), durationPerKilometer: Int(durationPerKilometer)))
                }
            }
        }else{
            distances = mockDistancesData()
            saveDistancesToCoreData(distances: distances)
        }
        return distances
    }
    
    private func saveOneRunningDataToCoreData(dataItem: DistanceDetailItem){
        DispatchQueue.global().async{[unowned self] in
            let managedContext = self.getManagedContext()
            let entity = NSEntityDescription.entity(forEntityName: "Running", in:managedContext)
            let distanceObject = NSManagedObject(entity: entity!, insertInto: managedContext)
            distanceObject.setValue(Date().addingTimeInterval(-(Double)(dataItem.duration)), forKey: "date")
            distanceObject.setValue(dataItem.duration, forKey: "duration")
            distanceObject.setValue(dataItem.distance, forKey: "distance")
            distanceObject.setValue(dataItem.durationPerKilometer, forKey: "durationPerKilometer")
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    private func deleteOneRunningDataInCoreData(dataItem: DistanceDetailItem){
        let managedContext = getManagedContext()
        let count = objects.count
        for (index,object) in objects.enumerated() where object.value(forKey: "date") as! Date == dataItem.date {
            managedContext.delete(object)
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            objects.remove(at: index)
        }
        assert(objects.count == count - 1)
    }
    //MARK: CoreData helper
    private func getManagedContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }
    
    private func mockDistancesData()->[DistanceDetailItem]{
        var date = Date(timeIntervalSinceNow: -3600*24*100)
        var items = [DistanceDetailItem]()
        for _ in 0...20{
            let secondOffset = Double(arc4random_uniform(3600*24*2))+3600*24*3
            let distance = Double(arc4random_uniform(2000)+UInt32(9000))
            let durationPerKilometer = Int(arc4random_uniform(60))+330
            let duration = Int(distance / 1000 * Double(durationPerKilometer))
            date.addTimeInterval(secondOffset)
            items.append(DistanceDetailItem(date: date, distance: distance, duration: duration, durationPerKilometer: durationPerKilometer))
        }
        return items
    }

    private func saveDistancesToCoreData(distances: [DistanceDetailItem]){
        DispatchQueue.global().async{[unowned self] in
            let managedContext = self.getManagedContext()
            let entity = NSEntityDescription.entity(forEntityName: "Running", in:managedContext)
            for distance in distances {
                let distanceObject = NSManagedObject(entity: entity!, insertInto: managedContext)
                distanceObject.setValue(distance.date, forKey: "date")
                distanceObject.setValue(distance.duration, forKey: "duration")
                distanceObject.setValue(distance.distance, forKey: "distance")
                distanceObject.setValue(distance.durationPerKilometer, forKey: "durationPerKilometer")
                self.objects.append(distanceObject)
            }
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
//MARK: Web server
    private func getAllRunningDataFromServer()->[DistanceDetailItem]{
        
        return []
    }
    
    private func saveOneRunningDataToServer(dataItem: DistanceDetailItem){
        
    }
    
    private func deleteOneRunningDataInServer(dataItem: DistanceDetailItem){
        
    }
}
