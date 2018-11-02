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
    let context = CoreDataStack.sharedInstance.getContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagerPicker = UIImagePickerController()
        self.imagerPicker.delegate = self
    }
    
    func dateString(date:Date){
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
       // dateStr = dateFormatter.string(from: date)
        
    }
    
    func getDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDiretory = paths[0]
        return documentDiretory
    }
    
    //Mark: Get File Size
    func getSize(fileSize:Int64){
        
        var floatSize = Float(fileSize / 1024)
        
        if fileSize < 1023 {
            print("\(floatSize).bytes")
        }
        
        if floatSize < 1023 {
            print("\(floatSize) KB")
        }
        // MB
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            print("\(floatSize) MB")
        }
        // GB
        floatSize = floatSize / 1024
        print("\(floatSize) GB")
    }
    
    //Mark: Delete recording from File Manager
    func deleteRecordingFile(audioName:String){
        do{
            try FileManager.default.removeItem(at: getDirectory().appendingPathComponent(audioName))
        } catch let error as NSError{
            print("Error: \(error.domain)")
            
        }
    }
    
    
    //Mark: Split int in hours, min, sec
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    //func that displays alert
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    func showAlert(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        

        
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

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
