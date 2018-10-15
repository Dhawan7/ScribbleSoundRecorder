//
//  MLkitImageProcessing.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 15/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class MLkitImageProcessing: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var imageForData = UIImage()
    var observationData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classifyImage(image: imageForData)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let model = try? VNCoreMLModel(for: Resnet50.init().model) else{ return }
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else {return}
            guard let observation = results.first else{return}
            let classifications = results.filter({$0.confidence > 0.001}).map({ "\($0.identifier) \(String(format:"%.10f%%", Float($0.confidence)*100))" })
            print(classifications.joined(separator: "\n"))
            DispatchQueue.main.async(execute: {
                print(observation.identifier)
                print(observation)
                print("\(Int(observation.confidence * 100))% \(observation.identifier)")
                self.observationData = "\(Int(observation.confidence * 100))% \(observation.identifier)"
            })
        }
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // executes request
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func classifyImage(image: UIImage){
        guard let ciImage = CIImage(image: image) else{
            print("could not continue - no CiImage constructed")
            return
        }
      //  lblItemNamee.text = "classifying..."
        guard let trainedModel = try? VNCoreMLModel(for: Resnet50.init().model) else {
            print("can't load ML model")
            return
        }
        let classificationRequest = VNCoreMLRequest(model: trainedModel)
        { [weak self] classificationRequest, error in
            guard let result = classificationRequest.results as? [VNClassificationObservation], let firstResult = result.first else{
                print("unexpected result type from VMCoreMLRequest")
                return
            }
            
            print("classifications: \(result.count)")
            let classifications = result.filter({$0.confidence > 0.001 }).map({" \($0.identifier) \(String(format:"%.10f%%", Float($0.confidence)*100))" })
            print(classifications.joined(separator: "\n"))
            DispatchQueue.main.async { [weak self] in
                print("\(Int(firstResult.confidence * 100))% \(firstResult.identifier)")
                self?.observationData = "\(firstResult.identifier)"
            }
        }
        //perform an image request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try imageRequestHandler.perform([classificationRequest])
            } catch {
                print(error)
            }
        }
    }

}
