//
//  AudioTrimVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 29/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation
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
        getDirectoryData()
    }
    
    
    func getDirectoryData(){
        do{
            let directoryContents = try FileManager.default.contentsOfDirectory(at: getDirectory(), includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
        } catch{
            print(error.localizedDescription)
        }
//        let path = getDirectory().appendingPathComponent("rec1.m4a")
//        if FileManager.default.fileExists(atPath: path.path){
//            print("yes")
//        }else{
//            print("No")
//        }
//        deleteRecordingFile(audioName: "rr.m4a")

    }
    
    
    func newAudioTrim(){
        startingTime = Int(audioRangeSlider.selectedMinValue)
        endingTime = Int(audioRangeSlider.selectedMaxValue)
        let currentTime = CFAbsoluteTimeGetCurrent()
        let composition = AVMutableComposition()
        let soundFileURL = getDirectory().appendingPathComponent("rec1.m4a")
        let soundFileURL1 = getDirectory().appendingPathComponent("rec1.m4a")
        let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        compositionAudioTrack?.preferredVolume = 0.8
        let asset = AVURLAsset(url: soundFileURL, options: nil)
        print(asset)
        var tracks = asset.tracks(withMediaType: .audio)
        let clipAudioTrack = tracks[0]
        do{
            try compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: clipAudioTrack, at: kCMTimeZero)
        } catch _ {
            
        }
        let compositionAudioTrack1 = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        compositionAudioTrack1?.preferredVolume = 0.8
        let asset1 = AVURLAsset.init(url: soundFileURL1)
        print(asset1)
        
        var tracks1 = asset1.tracks(withMediaType: .audio)
        let clipAudioTrack1 = tracks1[0]
        do{
            try compositionAudioTrack1?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset1.duration), of: clipAudioTrack1, at: kCMTimeZero)
        } catch _ {
            
        }
        
        let strOutputFilePath = getDirectory().appendingPathComponent("rec1.m4a")
        print("stored output path \(strOutputFilePath)")
        
        let requiredOutputPath = getDirectory().appendingPathComponent("rec1.m4a")
        print("output path is \(requiredOutputPath)")
        
        let soundFile1 = NSURL.fileURL(withPath: "\(requiredOutputPath)")
        print("output path \(soundFile1)")
        
        do{
            try FileManager.default.removeItem(at: soundFile1)
        } catch _ {
            
        }
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exporter?.outputURL = soundFile1
        exporter?.outputFileType = AVFileType.m4a
        let duration = CMTimeGetSeconds(asset1.duration)
        print(duration)
        if (duration < 5.0){
            print("audio is not long enough")
            return
        }
        let startTime = CMTimeMake(Int64(startingTime), 1)
        let endTime = CMTimeMake(Int64(endingTime), 1)
        let exportTimeRange = CMTimeRangeMake(startTime, endTime)
        print(exportTimeRange)
        exporter?.timeRange = exportTimeRange
        print(exporter?.timeRange)
        
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

    @IBAction func btnPlayAudio(_ sender: Any) {
        
        
        let path = audioData.url!
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        } catch{
            
        }
        
        
    }
    
  
    
    
    
    @IBAction func btnTrim(_ sender: UIButton) {
        
        if let asset = AVURLAsset(url: getDirectory().appendingPathComponent("rec1.m4a")) as? AVAsset{
            exportAsset(asset, fileName: "")
        }
    //        let assetIn = AVURLAsset(url: getDirectory().appendingPathComponent("rec1.m4a"))
    //        exportAsset(assetIn, fileName: "")
    }
    
    
    func exportAsset(_ asset: AVAsset, fileName:String){
        let trimmedSoundFileUrl = getDirectory().appendingPathComponent("rec2.m4a")
//        print("Saving to \(trimmedSoundFileUrl.absoluteString)")
//
//
//        if FileManager.default.fileExists(atPath: trimmedSoundFileUrl.path){
//            print("Sound exists, removing \(trimmedSoundFileUrl.path)")
//            do{
//                if try trimmedSoundFileUrl.checkResourceIsReachable(){
//                    print("is reachable")
//                    self.deleteRecordingFile(audioName: "rec1.m4a")
//                }
//               // try FileManager.default.removeItem(atPath: trimmedSoundFileUrl.absoluteString)
//            } catch{
//                print("Could not remove \(trimmedSoundFileUrl.absoluteString)")
//            }
//        }
//        print("Create export session for \(asset)")
        
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
                    self.setData()
                }
            })
        } else{
            print("cannot create AVAssetExportSession for asset \(asset)")
        }
    }
    
    func setData(){
        audioData.date = Date()
        audioData.name = "rec2"
    }
    
    func cropAudio(){
        
        let asset = AVURLAsset(url: getDirectory().appendingPathComponent("rec1.m4a"))
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
        exportSession.outputURL = outputUrl
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
    
}


    /*

 
    
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
    }  */

    

