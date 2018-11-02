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
    var imageToIdentify:UIImage = UIImage()
    var mlObjName:String = ""
    var recordingData:[RecodingData] = [RecodingData]()
    let imageObservationData = MLkitImageProcessing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAlert()
        recordingData = RecodingData.share.getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // imagerPicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCapturePick(_ sender: UIButton) {
       // showAlert()
    }
    
    @IBAction func btnIdentifyImage(_ sender: UIButton) {
      
    }
    
   

}

extension CustomCameraVC {
    
    //Mark: UIImagePicker Delegate Method's
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageObservationData.classifyImage(image: image!)
         self.checkDataAvailable(objData: self.imageObservationData.observationData, imgPicker: image ?? #imageLiteral(resourceName: "background"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           
            self.imageToIdentify = image ?? #imageLiteral(resourceName: "stop-button")
            self.lblItemNamee.text = self.imageObservationData.observationData
            self.imagerPicker.dismiss(animated: true, completion: nil)
        }
        
       
        
        
    }
    
    func checkDataAvailable(objData:String, imgPicker:UIImage){

        recordingData = recordingData.filter{$0.objectName == objData}
        if recordingData.isEmpty{
            let alert = UIAlertController(title: "Warning", message: "No match found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        } else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
            vc.isFromSearch = true
            vc.currentRecordingData = recordingData[0]
           vc.recordingData = recordingData
           
          //  vc.audioIndex = Int(recordingData[0].audioIndex)
          //  vc.audioIndex = recordingData
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        lblItemNamee.text = imageObservationData.observationData
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
 

