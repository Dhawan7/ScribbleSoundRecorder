//
//  NoImageTrimVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 03/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class NoImageTrimVC: BaseVC {
    
    @IBOutlet weak var imgToSave: UIImageViewX!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfNotes: UITextField!
    @IBOutlet weak var imgBackground: UIImageView!
    
    
    //Mark: let, var
    var urlFromCustomPopUP: URL!
    let context = CoreDataStack.sharedInstance.getContext()
    var imageData:Data = Data()
    let imageObservationData = MLkitImageProcessing()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(false, animated: true)
    }
    
    @IBAction func btnPickImage(_ sender: UIButtonX) {
        showAlert()
    }

    @IBAction func btnSave(_ sender: UIButton) {
        let objName = imageObservationData.observationData
        let entity = RecordingData.insertRequest(context: context)

        if (tfTitle.text?.isEmpty)!{
            if (tfNotes.text?.isEmpty)!{
                entity.setData(urlD: urlFromCustomPopUP, imageD: (imgToSave.image?.jpeg)!, dateD: Date(), nameD: tfTitle.text!, notesD: tfNotes.text!, objectNameD: objName)
            }
        }
    }
}

extension NoImageTrimVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagerPicker.dismiss(animated: true, completion: nil)
        let imageToDisplay = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageObservationData.classifyImage(image: imageToDisplay)
        imgToSave.image = imageToDisplay
        imgBackground.image = imageToDisplay
        
    }
}

extension UIImage {
    var jpeg: Data? {
        return UIImageJPEGRepresentation(self, 1)
    }
    var png: Data? {
        return UIImagePNGRepresentation(self)
    }
}

