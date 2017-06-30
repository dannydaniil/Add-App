//
//  RootPageViewController.swift
//  addapp
//
//  Created by Anmol Jain on 6/29/17.
//  Copyright © 2017 Daniil, Daniel Chris. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    lazy var viewControllerList:[UIViewController] = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyboard.instantiateViewController(withIdentifier: "homeVC")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "cameraVC")
        
        return [vc1, vc2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstVC = viewControllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
       
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else { return nil}
        
        guard  viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
    }
}
