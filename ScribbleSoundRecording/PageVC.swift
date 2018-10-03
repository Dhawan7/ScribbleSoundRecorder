//
//  PageVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 24/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

protocol PageScrollDelegate {
    func pageScrolled(offSet:CGFloat)
}

class PageVC: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate {
   
    var controllers:[UIViewController] = []
    var pageScrollDelegate: PageScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let storyboard = storyboard else {
            return
        }
        controllers = [storyboard.instantiateViewController(withIdentifier: "RecordingsVC") as! RecordingsVC,
                       storyboard.instantiateViewController(withIdentifier: "RecorderVC") as! RecorderVC,
                       storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC]
        setViewControllers([controllers[1]], direction: .forward, animated: false, completion: nil)
        delegate = self
        dataSource = self
        self.view.subviews.forEach { (subView) in
            if let scrollV = subView as? UIScrollView{
                scrollV.delegate = self
                scrollV.showsHorizontalScrollIndicator = false
            }
        }
        // Do any additional setup after loading the view.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("Scrolled at ",scrollView.decelerationRate)
        let scrolledContent = (scrollView.contentOffset.x / UIScreen.main.bounds.width)
       /* let panState = scrollView.panGestureRecognizer.state
        switch panState {
        case .began:
            
            pageScrollDelegate?.pageScrolled(offSet: scrolledContent)
            break
        case .changed:
            
            pageScrollDelegate?.pageScrolled(offSet: scrolledContent)
            break
        case .ended:
            
            break
        default:
            break
        }
        */
        
        if scrolledContent > 0.0 && scrolledContent < 1.0{
            pageScrollDelegate?.pageScrolled(offSet: scrolledContent)
            print("Content Scrolled in left = ",scrolledContent)
        }
        else if scrolledContent > 1.0 && scrolledContent < 2.0{
            print("Content Scrolled in right = ",scrolledContent/2)
            pageScrollDelegate?.pageScrolled(offSet: scrolledContent)
        }
        
        //print("Content Scrolled = ",scrolledContent)
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.index(of: viewController) else{
            return nil
        }
        if index == 0{
            return nil
        }
        return controllers[index.advanced(by: -1)]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.index(of: viewController) else{
            return nil
        }
        if index.advanced(by: 1) == controllers.count{
            return nil
        }
        
        return controllers[index.advanced(by: 1)]
    }
    
}
