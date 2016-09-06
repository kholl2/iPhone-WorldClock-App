//
//  MainNavigationController.swift
//  project3
//
//  Created by Kruthika Holla on 11/23/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit
import SlideMenuKit

class MainNavigationController: MasterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        menuButtonTintColor = UIColor.blackColor()
        let controller = storyboard!.instantiateViewControllerWithIdentifier("WorldClockController")
        controller.willMoveToParentViewController(self)
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        
        let array = [
            MenuCell(controllerIdentifier: "WorldClockController", storyboardTitle: "Main", cellTitle: "World Clock"),
            MenuCell(controllerIdentifier: "TimerController", storyboardTitle: "Main", cellTitle: "Timer"),
            MenuCell(controllerIdentifier: "ThirdController", storyboardTitle:  "Main", cellTitle: "About")
        ]
        addMenuSelectionItems(array)
    }
    
//    override func didSelectCell(cell: MenuCell) {
//        super.didSelectCell(cell)
//        if cell.controllerIdentifier == "TimerController" {
//            menuButtonTintColor = UIColor.blueColor()
//        }
//        else {
//            menuButtonTintColor = UIColor.blackColor()
//        }
//    }
    

    

}
