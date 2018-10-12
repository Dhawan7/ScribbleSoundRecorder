//
//  ViewController.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 15/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate{
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnList: UIButton!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func swipeUpGesture(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraVC
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func btnListAction(_ sender: UIButton) {
       
    }


}


	
