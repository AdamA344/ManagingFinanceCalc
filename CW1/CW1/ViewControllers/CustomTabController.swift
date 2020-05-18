//
//  CustomTabController.swift
//  CW1
//
//  Created by Adam Ayub on 03/03/2020.
//  Copyright © 2020 Adam Ayub. All rights reserved.
//

import UIKit

class CustomTabController: UITabBarController ,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // the view to bring the tab bar to the top height of the view controller while pushing the view controller underneath it so place the tab bar to the top of the view.
/*
    override func viewDidLayoutSubviews() {
        tabBar.frame = CGRect(x: 0, y: 35 , width: tabBar.frame.size.width, height: tabBar.frame.size.height)
        super.viewDidLayoutSubviews()
        delegate = self
        selectedViewController?.view.frame.origin = CGPoint(x: 0, y: tabBar.frame.size.height)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
     selectedViewController?.view.frame.origin = CGPoint(x: 0, y: 0)
    }
  

    */
    
}
