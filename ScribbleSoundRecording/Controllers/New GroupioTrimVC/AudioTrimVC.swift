//
//  AudioTrimVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 29/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation
import RETrimControl
import RangeSeekSlider
import AVFoundation

class AudioTrimVC: BaseVC {
    
    //Mark: outlet's
    @IBOutlet weak var audioRangeSlider: RangeSeekSlider!
    
    //Mark: let, var
    var fileName:String = "rrrr"
    var tfName:String = "Edited Audio"
    var audioData:RecodingData!
    var trackTotalLength:Float!
    var audioPlayer:AVAudioPlayer!
    var startingTime:Int = 0
    var endingTime:Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        //cropAudio()
        audioRangeSlider.minValue = 0.0
        audioRangeSlider.maxValue = CGFloat(trackTotalLength)
        
    }
    

    func cropAudio(){
        
       
            let orignalURL = getDirectory().appendingPathComponent("\(fileName).m4a")
           // let outputURL = getDirectory().appendingPathComponent("\(tfName).m4a")
          //  try FileManager.default.moveItem(at: orignalURL, to: outputURL)
            let asset = AVURLAsset(url: orignalURL)
            let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)!
        let outputUrl = getDirectory()
            let filemanager = FileManager.default
        
        do{
            try filemanager.createDirectory(at: outputUrl, withIntermediateDirectories: true, attributes: nil)
        } catch{
            
        }
        outputUrl.appendingPathComponent("New edited.m4a")
        do{
                try filemanager.removeItem(at: outputUrl)
        } catch{
            
        }
            exportSession.outputURL = orignalURL
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.outputFileType = AVFileType.m4a
        let start = CMTimeMakeWithSeconds(Float64(startingTime), 1)
        let duration = CMTimeMakeWithSeconds(Float64(endingTime), 1)
            let range = CMTimeRangeMake(start, duration)
            exportSession.timeRange = range
            exportSession.exportAsynchronously {
                switch (exportSession.status){
                case .completed:
                    print("Completed")
                    break
                case .failed:
                    print("Failed")
                    break
                case .completed:
                    print("Completed")
                    break
                default: break
                }
            }
            
        
        
       
        
    }
    
    func trimAudio(){
        if let asset = AVAsset(url: audioData.url!) as? AVAsset{
            exportAsset(asset, fileName: "\(audioData.name!)")
        }
    }

    func exportAssetf(asset:AVAsset, fileName:String){
        let trimmedSoundName = getDirectory().appendingPathComponent(fileName)
        print("Saving to \(trimmedSoundName.absoluteString)")
        let filemanager = FileManager.default
        if filemanager.fileExists(atPath: trimmedSoundName.absoluteString){
            print("Sound exists")
        }
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exporter?.outputFileType = AVFileType.m4a
        exporter?.outputURL = trimmedSoundName
        
        let duration = CMTimeGetSeconds(asset.duration)
        if (duration < 5){
            print("Sound is not long enough")
            return
        }
        
        let startTime = CMTimeMake(1, 1)
        let stopTIme = CMTimeMake(6, 1)
        let exportTimeRange = CMTimeRange(start: startTime, end: stopTIme)
        exporter?.timeRange = exportTimeRange
        
        exporter?.exportAsynchronously {
            switch (exporter?.status){
            case .completed?:
                print("Completed")
                break
            case .failed?:
                print("Failed")
                break
            case .completed?:
                print("Completed")
                break
            default: break
            }
        }
        

    }
    
    func exportAsset(_ asset: AVAsset, fileName:String){
        let documentDirectrory = getDirectory()
        let trimmedSoundFileUrl = documentDirectrory.appendingPathComponent("rec3.m4a")
        print("Saving to \(trimmedSoundFileUrl.absoluteString)")
        
        if FileManager.default.fileExists(atPath: trimmedSoundFileUrl.absoluteString){
            print("Sound exists, removing \(trimmedSoundFileUrl.absoluteString)")
            do{
                if try trimmedSoundFileUrl.checkResourceIsReachable(){
                    print("Is reachable")
                }
                try FileManager.default.removeItem(atPath: trimmedSoundFileUrl.absoluteString)
            } catch{
                print("Could not remove \(trimmedSoundFileUrl.absoluteString)")
            }
        }
        print("Create export session for \(asset)")
        
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A){
            exporter.outputFileType = AVFileType.m4a
            exporter.outputURL = trimmedSoundFileUrl
            
            let duration = CMTimeGetSeconds(asset.duration)
            if duration < 5.0{
                print("Audio is not song long")
                return
            }
            
            let startTime = CMTimeMake(1, 1)
            let stopTime = CMTimeMake(6, 1)
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
                }
            })
        } else{
            print("cannot create AVAssetExportSession for asset \(asset)")
        }
    }

    
    @IBAction func btnPlayAudio(_ sender: Any) {
        startingTime = Int(audioRangeSlider.selectedMinValue)
        endingTime = Int(audioRangeSlider.selectedMaxValue)
        trimAudio()
            let path = audioData.url!
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                
            } catch{
                
            }
        
       
    }
    
    
    
}
