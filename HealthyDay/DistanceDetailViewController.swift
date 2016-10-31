//
//  DistanceDetailViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/13.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit
import CoreData

internal struct DistanceDetailItem {
    let date : Date
    let distance : Double
    let duration : Int
    let durationPerKilometer : Int
}

fileprivate struct DistancesInfo{
    let month : String
    var count : Int
}

internal class DistanceDetailViewController: UIViewController {

//MARK: IBOutlet
    @IBOutlet weak var distanceDetailTableView: UITableView!
//MARK: Property
    fileprivate var objects = [NSManagedObject]()
    fileprivate var distances = [DistanceDetailItem]()
    fileprivate var distancesInfo = [DistancesInfo]()
//MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        initDistancesFromCoreData()
        distancesInfo = classifyDistances(distances: distances)
        distanceDetailTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDistanceStatisticsVC"{
            guard let distanceStatisticsVC = segue.destination as? DistanceStatisticsViewController else {return}
            distanceStatisticsVC.distanceDetailItem = distances
        }
    }
    
//MARK: Helper
    private func initDistancesFromCoreData(){
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
            saveDistancesToCoreData()
        }
    }
    
    //Classify distances with month
    private func classifyDistances(distances:[DistanceDetailItem])->[DistancesInfo]{
        assert(distances.count > 0)
        var info = [DistancesInfo]()
        var dateDescription = distances[0].date.formatDescription()
        var month = dateDescription.substring(to: dateDescription.index(dateDescription.startIndex, offsetBy: 7))
        var infoIndex = 0
        info.append(DistancesInfo(month: month, count: 0))
        for distance in distances {
            if distance.date.formatDescription().contains(month){
                info[infoIndex].count += 1
            }else{
                dateDescription = distance.date.formatDescription()
                month = dateDescription.substring(to: dateDescription.index(dateDescription.startIndex, offsetBy: 7))
                info.append(DistancesInfo(month: month, count: 1))
                infoIndex += 1
            }
        }
        return info
    }

    fileprivate func getManagedContext()->NSManagedObjectContext{
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
    
    private func saveDistancesToCoreData(){
        DispatchQueue.global().async{[unowned self] in
            let managedContext = self.getManagedContext()
            let entity = NSEntityDescription.entity(forEntityName: "Running", in:managedContext)
            for distance in self.distances {
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
    
    fileprivate func indexInDistancesArray(withIndexPath indexPath:IndexPath)->Int{
        var offset = 0
        if indexPath.section == 0 {
            return indexPath.row
        }else{
            for section in 0...indexPath.section-1{
                offset += distancesInfo[section].count
            }
            return indexPath.row + offset
        }
    }
}

extension DistanceDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    @objc(tableView:canFocusRowAtIndexPath:) func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexInDistancesArray(withIndexPath: indexPath)
            let managedContext = getManagedContext()
            managedContext.delete(objects[index])
            do {
                try managedContext.save()
            }
            catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            objects.remove(at: index)
            distances.remove(at: index)
            distancesInfo[indexPath.section].count -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension DistanceDetailViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return distancesInfo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distancesInfo[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceDetailTableViewCell", for: indexPath) as! DistanceDetailTableViewCell
        let index = indexInDistancesArray(withIndexPath: indexPath)
        cell.date = distances[index].date
        cell.distance = distances[index].distance
        cell.duration = distances[index].duration
        cell.durationPerKilometer = distances[index].durationPerKilometer
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = distancesInfo[section].month
        title.append("月")
        return title.replacingOccurrences(of: "-", with: "年")
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView{
            header.textLabel?.font = UIFont.systemFont(ofSize: 14)
            header.textLabel?.textColor = theme.darkTextColor
        }
    }
}
