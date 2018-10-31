//
//  NoImageTrimVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 03/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import RETrimControl


class NoImageTrimVC: BaseVC, RETrimControlDelegate {
    
    @IBOutlet weak var imgToSave: UIImageViewX!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfNotes: UITextField!
    @IBOutlet weak var imgBackground: UIImageView!
    
    
    //Mark: let, var
    var audioURL: URL!
    var imageData:Data = Data()
    let imageObservationData = MLkitImageProcessing()
    var recordingNo:Int!
    var recordingName:String!
    var audioTrim:RETrimControl!
    var isFromBrowse:Bool = false
    var browseData:RecodingData!
    var sizeAudio:Int64!
    var audioLength:Float!

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isFromBrowse{
            let image = UIImage(data: browseData.image!)
            imgToSave.image = image ?? #imageLiteral(resourceName: "background")
            imgBackground.image = image ?? #imageLiteral(resourceName: "background")
            tfTitle.text = browseData.name
            tfNotes.text = browseData.note
        } else{
           
        }
        
       // audioTrim.delegate = self
    }
    
    @IBAction func btnPickImage(_ sender: UIButtonX) {
        showAlert()
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        if (isFromBrowse){
        let objName = imageObservationData.observationData
        let entity = RecodingData.insertRequest(context: context)
        if !(tfTitle.text?.isEmpty)!{
            do{
                let orignalPath = getDirectory().appendingPathComponent("\(recordingNo!).m4a")
                let destinationPath = getDirectory().appendingPathComponent("\(tfTitle.text!).m4a")
                try FileManager.default.moveItem(at: orignalPath, to: destinationPath)
                sizeAudio = Int64(destinationPath.fileSize)
                audioURL = destinationPath
            } catch{
                print(error)
            }
            
            if !(tfNotes.text?.isEmpty)!{
                
                entity.setData(urlD: audioURL, imageD: (imgToSave.image?.jpeg!)! , dateD: Date(), nameD: tfTitle.text!, noteD: tfNotes.text!, objectNameD: objName, recordIndex: Int16(recordingNo!), bookmarkAudio: false, audioSize: sizeAudio ?? 1024)
                do{
                    try context.save()
                    self.navigationController?.popToRootViewController(animated: true)
                    
                } catch let error as NSError{
                    print("Could not save \(error) \(error.userInfo)")
                }
            } else{
                
            }

        } else{
            
        }
        } else{
            browseData.image = (imgToSave.image?.jpeg!)!
            browseData.name = tfTitle.text
            browseData.note = tfNotes.text
            do{
                try context.save()
                self.navigationController?.popToRootViewController(animated: true)
                
            } catch let error as NSError{
                print("Could not save \(error) \(error.userInfo)")
            }
           
        }
        }
    
    @IBAction func btnTrim(_ sender: UIButton) {
        if isFromBrowse{
            
        } else{
            let stroryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = stroryboard.instantiateViewController(withIdentifier: "AudioTrimVC") as! AudioTrimVC
            vc.trackTotalLength = audioLength
            vc.audioData = browseData
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func trimControl(_ trimControl: RETrimControl!, didChangeLeftValue leftValue: CGFloat, rightValue: CGFloat) {
       
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

