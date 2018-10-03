//
//  MainVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 24/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class MainVC: UIViewController,PageScrollDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let pageVC = self.childViewControllers.first as? PageVC
        pageVC?.pageScrollDelegate = self
    }
    func pageScrolled(offSet: CGFloat) {
       
    }
    
}
