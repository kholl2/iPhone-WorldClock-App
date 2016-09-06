//
//  ViewController.swift
//  project3
//
//  Created by Kruthika Holla on 11/6/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit



class ViewController: UIViewController,PassCityDelegate, UITableViewDelegate, UITableViewDataSource, MainModelDelegate {
    
    let model = WorldClockModel()
    var selectedCity :String?
    var passedModel: CitiesAfterSelectionModel?
    var selectedIndexPath: Bool = false
    var timeModel: TimeLocationModel = TimeLocationModel()
    var cityText = String()
    var cityModel: CitiesAfterSelectionModel = CitiesAfterSelectionModel()
    
    @IBOutlet weak var worldClockTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        worldClockTableView.delegate = self
        worldClockTableView.dataSource = self
        let tblView =  UIView(frame: CGRectZero)
        worldClockTableView.tableFooterView = tblView
        worldClockTableView.tableFooterView!.hidden = true
        worldClockTableView.backgroundColor = UIColor.clearColor()
        worldClockTableView.layer.masksToBounds = true
        worldClockTableView.layer.borderColor = UIColor.grayColor().CGColor
        worldClockTableView.layer.borderWidth = 0.3
        model.delegate = self
        selectedIndexPath = false
    }
    
    
    func receiveFailedForTime() {
        print("couldn't parse data")
    }
    
    //Update the world clock view as cities are added
    override func viewDidAppear(animated: Bool) {
        timeModel = TimeLocationModel()
        cityModel = CitiesAfterSelectionModel()
        if let city = selectedCity {
            if city != " "{
                cityText = String()
                model.cityAdded(city)
                model.saveRetrievedData()
                var indPath:[NSIndexPath] = [NSIndexPath]()
                indPath.append(NSIndexPath(forRow:(timeModel.timeLocationsArray.count - 1), inSection:0))
                worldClockTableView.beginUpdates()
                worldClockTableView.insertRowsAtIndexPaths(indPath, withRowAnimation: UITableViewRowAnimation.None)
                worldClockTableView.endUpdates()
                
            }
        }
    }
    
    //Segue to add cities
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let to: TableViewController = segue.destinationViewController as! TableViewController
        to.delegate = self
        to.model = model
    }
    
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return timeModel.timeLocationsArray.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
       
        //Analog clock
        if (selectedIndexPath){
            let cell = tableView.dequeueReusableCellWithIdentifier("worldClockCell", forIndexPath: indexPath)
            for subview in cell.contentView.subviews{
                subview.removeFromSuperview()
            }
            cell.textLabel?.text = timeModel.timeLocationsArray[indexPath.row]
            cell.textLabel?.font = UIFont(name: cell.textLabel!.font.fontName, size: 20)
            let clockFace = ClockView(frame: CGRectZero)
            let clockView = ClockHoldingView.init(frame: CGRectMake(cell.contentView.bounds.width - 100, 10, 90, 90))
            cell.contentView.addSubview(clockView)
            clockView.addSubview(clockFace)
            cell.detailTextLabel!.hidden = true
            let timeAtLocation: String = model.getCurrentTimeForLocationWithSeconds(timeModel.timeLocationsArray[indexPath.row])
            clockFace.clockLayer.getCurrentTime(timeAtLocation)
            for subview in clockView.subviews{
                if subview is ClockHoldingViewProtocol{
                    model.moveHands(subview, location: timeModel.timeLocationsArray[indexPath.row])
                }
            }

            
            let timeDetailsLabel = UILabel.init(frame: CGRectMake(15, 70, 180, 20))
            timeDetailsLabel.textAlignment = .Left
            timeDetailsLabel.font = UIFont(name: timeDetailsLabel.font.fontName, size: 13)
            timeDetailsLabel.text = model.getOffset(timeModel.timeLocationsArray[indexPath.row])
            cell.contentView.addSubview(timeDetailsLabel)
            cell.separatorInset = UIEdgeInsetsZero
            
            return cell
        }
            //digital clock
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("worldClockCell", forIndexPath: indexPath)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            for subview in cell.contentView.subviews{
                subview.removeFromSuperview()
            }
            cell.textLabel?.text = timeModel.timeLocationsArray[indexPath.row]
            cell.textLabel?.font = UIFont(name: cell.textLabel!.font.fontName, size: 20)
            let timeAtLocation = model.getCurrentTimeForLocation(timeModel.timeLocationsArray[indexPath.row])
            cell.detailTextLabel!.hidden = false
            cell.detailTextLabel!.text = timeAtLocation
            model.getDigitalTimeUpdate(timeModel.timeLocationsArray[0])
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.font = UIFont(name: cell.textLabel!.font.fontName, size: 20)
            cell.detailTextLabel?.textAlignment = NSTextAlignment.Left
            let timeDetailsLabel = UILabel.init(frame: CGRectMake(15, 70, 180, 20))
            timeDetailsLabel.textAlignment = .Left
            timeDetailsLabel.font = UIFont(name: timeDetailsLabel.font.fontName, size: 13)
            timeDetailsLabel.text = model.getOffset(timeModel.timeLocationsArray[indexPath.row])
            cell.contentView.addSubview(timeDetailsLabel)
            cell.separatorInset = UIEdgeInsetsZero
            return cell
        }
    }
    
    func reload() {
        if(!selectedIndexPath){
            worldClockTableView.reloadData()
        }
    }
    
    //Delete world clock data
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            model.deleteData(timeModel.timeLocationsArray[indexPath.row] )
            
            if let cModel = passedModel {
                cModel.cityLocationsArray.append(timeModel.timeLocationsArray[indexPath.row])
                
                model.deleteCityData()
                model.cityAfterAdd?.removeAll()
                model.saveAddedCityData()
                for city in cModel.cityLocationsArray{
                    model.cityAfterAdd?.append(AfterAddingCityData(cityArray: city))
                }
                model.saveAddedCityData()
            }
            else{
                let cityArr = cityModel.cityLocationsArray
                model.deleteCityData()
                model.cityAfterAdd?.removeAll()
                model.saveAddedCityData()
                for city in cityArr{
                    model.cityAfterAdd?.append(AfterAddingCityData(cityArray: city))
                }
                model.cityAfterAdd?.append(AfterAddingCityData(cityArray: timeModel.timeLocationsArray[indexPath.row]))
                model.saveAddedCityData()
               
            }
            
            timeModel.timeLocationsArray.removeAtIndex(indexPath.row)
            worldClockTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110.0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(!selectedIndexPath){
            selectedIndexPath = true
            tableView.reloadData()
        }
        else{
            selectedIndexPath = false
            tableView.reloadData()
        }
        
    }
    
    
    
    
    
}
































