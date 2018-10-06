//
//  CustomCameraVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 24/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class CustomCameraVC: UIViewController {
    let customCamera = CameraController()
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var btnCamera: UIButtonX!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func configureCameraController() {
            customCamera.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.customCamera.displayPreview(on: self.cameraView)
            }
        }
        
        btnCamera.bringSubview(toFront: cameraView)
        configureCameraController()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func swipeDownAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
//        func pushTransition(duration:CFTimeInterval) {
//            let animation:CATransition = CATransition()
//            animation.timingFunction = CAMediaTimingFunction(name:
//                kCAMediaTimingFunctionEaseInEaseOut)
//            animation.type = kCATransitionMoveIn
//            animation.subtype = kCATransitionFromLeft
//            animation.duration = duration
//            animation.repeatCount = 99
//            self.view.addAnimation(animation, forKey: kCATransitionPush)
//        }
    
}
