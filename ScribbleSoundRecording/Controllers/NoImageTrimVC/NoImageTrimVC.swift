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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(false, animated: true)
    }
    
    @IBAction func btnPickImage(_ sender: UIButtonX) {
        showAlert()
    }
    

    @IBAction func btnSave(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SaveEditSoundVC") as! SaveEditSoundVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NoImageTrimVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagerPicker.dismiss(animated: true, completion: nil)
        imgToSave.image = info[UIImagePickerControllerOriginalImage] as! UIImage
    }

}
