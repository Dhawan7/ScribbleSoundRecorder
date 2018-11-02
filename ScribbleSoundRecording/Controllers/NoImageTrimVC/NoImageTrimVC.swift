//
//  NoImageTrimVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 03/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation
import RangeSeekSlider

class NoImageTrimVC: BaseVC {
    
    @IBOutlet weak var imgToSave: UIImageViewX!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfNotes: UITextField!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var viewTrimAudio: UIView!
    @IBOutlet weak var selectAudioRange: RangeSeekSlider!
    
    
    
    //Mark: let, var
    var audioURL: URL!
    var imageData:Data = Data()
    let imageObservationData = MLkitImageProcessing()
    var recordingNo:Int!
    var recordingName:String!
    var isFromBrowse:Bool = false
    var browseData:RecodingData!
    var sizeAudio:Int64!
    var audioLength:Float!
    var isGoingForward:Bool = false
    var previousAudioName = "rec1"

    override func viewDidLoad() {
        super.viewDidLoad()
       setSliderValues()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(NoImageTrimVC.backToInitial(sender:)))
        if !isFromBrowse{
            let image = UIImage(data: browseData.image!)
            imgToSave.image = image ?? #imageLiteral(resourceName: "background")
            imgBackground.image = image ?? #imageLiteral(resourceName: "background")
            tfTitle.text = browseData.name
            tfNotes.text = browseData.note
            previousAudioName = tfTitle.text ?? "rec"
        } else{
           
        }
        
       // audioTrim.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
         viewTrimAudio.alpha = 0.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    func setSliderValues(){
        selectAudioRange.minValue = 0.0
        selectAudioRange.maxValue = CGFloat(audioLength ?? 10.0)
    }
    
    @objc func backToInitial(sender: AnyObject) {
        if isFromBrowse{
            if !isGoingForward{
                 deleteRecordingFile(audioName: "\(recordingNo!).m4a")
            }
        } else{
            
        }
        self.navigationController?.popToRootViewController(animated: true)
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
            trimSelectedAudio()
          
        }
        }
    
    @IBAction func btnTrim(_ sender: UIButton) {
        isGoingForward = false
        if isFromBrowse{
            
        } else{
           viewTrimAudio.alpha = 1.0
        }
        
    }
    
    func trimSelectedAudio(){
        let name = browseData.name!
        if let asset = AVURLAsset(url: getDirectory().appendingPathComponent("\(tfTitle.text!).m4a")) as? AVAsset{
            exportAsset(asset, fileName: name)
        }
    }
    
    func exportAsset(_ asset: AVAsset, fileName:String){
        let trimmedSoundFileUrl = getDirectory().appendingPathComponent("\(tfTitle.text!)_trimmed.m4a")
                print("Saving to \(trimmedSoundFileUrl.absoluteString)")
       
        
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A){
            exporter.outputFileType = AVFileType.m4a
            exporter.outputURL = trimmedSoundFileUrl
            
            let duration = CMTimeGetSeconds(asset.duration)
            if duration < 5.0{
                print("Audio is not song long")
                return
            }
            let startTime = CMTimeMake(Int64(selectAudioRange.selectedMinValue), 1)
            let stopTime = CMTimeMake(Int64(selectAudioRange.selectedMaxValue), 1)
            exporter.timeRange = CMTimeRangeFromTimeToTime(startTime, stopTime)
            
            exporter.exportAsynchronously(completionHandler: {
                print("export complete \(exporter.status)")
                
                switch exporter.status {
                case  AVAssetExportSessionStatus.failed:
                    
                    if let e = exporter.error {
                        print("export failed \(e)")
                    }
                    
                case AVAssetExportSessionStatus.cancelled:
                    print("export cancelled \(String(describing: exporter.error))")
                default:
                    print("export complete")
                    self.deleteFileAlreadyPresent()
                    // change core data data here
                }
            })
        } else{
            print("cannot create AVAssetExportSession for asset \(asset)")
        }
    }
    
    func deleteFileAlreadyPresent(){
        let PresentAudioUrl = getDirectory().appendingPathComponent("\(previousAudioName).m4a")
                if FileManager.default.fileExists(atPath: PresentAudioUrl.path){
                    print("Sound exists, removing \(PresentAudioUrl.path)")
                    do{
                        if try PresentAudioUrl.checkResourceIsReachable(){
                            print("is reachable")
                            self.deleteRecordingFile(audioName: "\(previousAudioName).m4a")
                            self.saveTrimedData()
                        }
                       // try FileManager.default.removeItem(atPath: trimmedSoundFileUrl.absoluteString)
                    } catch{
                        print("Could not remove \(PresentAudioUrl.absoluteString)")
                    }
                }
    }
    
    func saveTrimedData(){
        browseData.image = (imgToSave.image?.jpeg!)!
        browseData.note = tfNotes.text
        browseData.name = "\(tfTitle.text!)_trimmed"
        do{
            try context.save()
            self.navigationController?.popToRootViewController(animated: true)
            
        } catch let error as NSError{
            print("Could not save \(error) \(error.userInfo)")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.viewTrimAudio.alpha = 0.0
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

