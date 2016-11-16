//
//  DistanceDetailViewController.swift
//  HealthyDay
//
//  Created by Linsw on 16/10/13.
//  Copyright © 2016年 Linsw. All rights reserved.
//

import UIKit

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
    fileprivate let dataSourceManager = DataSourceManager.sharedDataSourceManager
    
    fileprivate var distances = [DistanceDetailItem]()
    fileprivate var distancesInfo = [DistancesInfo]()
//MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceManager.getAllRunningData{ [unowned self] (success,items) in
            if success ,let distanceItems = items {
                self.distances = distanceItems
                self.distancesInfo = self.classifyDistances(distances: self.distances)
                self.distanceDetailTableView.reloadData()
            }
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDistanceStatisticsVC"{
            guard let distanceStatisticsVC = segue.destination as? DistanceStatisticsViewController else {return}
            distanceStatisticsVC.distanceDetailItem = distances
        }
    }
    
//MARK: Helper
    //Classify distances with month
    private func classifyDistances(distances:[DistanceDetailItem])->[DistancesInfo]{
        var info = [DistancesInfo]()
        if distances.count > 0 {
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
        }
        return info
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
            dataSourceManager.deleteOneRunningData(dataItem: distances[index]){ success in
                if !success {
                    print("fail to delete distance dataItem")
                }
            }
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
