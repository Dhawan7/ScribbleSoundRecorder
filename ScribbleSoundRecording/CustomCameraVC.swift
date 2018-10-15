//
//  CustomCameraVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 24/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit


class CustomCameraVC: BaseVC {
    
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var btnCamera: UIButtonX!
    @IBOutlet weak var takeImage: UIImageView!
    @IBOutlet weak var lblItemNamee: UILabel!
    
    //Mark: let, var
   // let customCamera = CameraController()
    var imageForData: UIImage = UIImage()
    let mlImageProcessing = MLkitImageProcessing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // imagerPicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCapturePick(_ sender: UIButton) {
        showAlert()
    }
    
    @IBAction func btnIdentifyImage(_ sender: UIButton) {
       mlImageProcessing.classifyImage(image: imageForData)
        lblItemNamee.text = mlImageProcessing.observationData
    }

}

extension CustomCameraVC {
    
    //Mark: UIImagePicker Delegate Method's
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageForData = image ?? #imageLiteral(resourceName: "stop-button")
        imagerPicker.dismiss(animated: true, completion: nil)
        takeImage.image = image
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


//    @objc func openCamera(){
//        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
//
//            imagerPicker.sourceType = .camera
//            imagerPicker.allowsEditing = true
//            self.present(imagerPicker, animated: true, completion: nil)
//        }
//        else{
//            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//        }
//    }
//
//    @objc func openGallery(){
//        imagerPicker.sourceType = .photoLibrary
//        imagerPicker.isEditing = true
//        self.present(imagerPicker, animated: true, completion: nil)
//    }
//
    
/*    override func viewDidLoad() {
        super.viewDidLoad()
//        func configureCameraController() {
//            customCamera.prepare {(error) in
//                if let error = error {
//                    print(error)
//                }
//
//                try? self.customCamera.displayPreview(on: self.cameraView)
//            }
//        }
//
//        btnCamera.bringSubview(toFront: cameraView)
//        configureCameraController()
        // Do any additional setup after loading the view.
    }
    
//    @IBAction func swipeDownAction(_ sender: Any) {
//        let transition = CATransition()
//        transition.duration = 0.7
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromBottom
//        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
//        self.dismiss(animated: false, completion: nil)
//    }
    
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
 
 */
 

