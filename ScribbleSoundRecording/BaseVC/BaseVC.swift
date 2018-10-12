//
//  BaseVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 12/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class BaseVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagerPicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagerPicker = UIImagePickerController()
        self.imagerPicker.delegate = self
    }

    func showAlert(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))

        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            
            imagerPicker.sourceType = .camera
            imagerPicker.allowsEditing = true
            self.present(imagerPicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @objc func openGallery(){
        imagerPicker.sourceType = .photoLibrary
        imagerPicker.isEditing = true
        self.present(imagerPicker, animated: true, completion: nil)
    }

}
