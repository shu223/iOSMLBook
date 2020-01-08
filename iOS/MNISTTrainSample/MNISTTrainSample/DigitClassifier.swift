//
//  DigitClassifier.swift
//  KerasMNISTSample
//
//  Created by Shuichi Tsutsumi on 2019/12/05.
//  Copyright © 2019 Shuichi Tsutsumi. All rights reserved.
//

import Foundation
//import Vision
import CoreML

class DigitClassifier {
        
//    func run(inputImage: CGImage, completion: @escaping ([VNClassificationObservation]) -> Void) {
//        let model =  try! VNCoreMLModel(for: ModelUpdater.liveModel.model)
//
//        let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
//            guard let observations = request.results as? [VNClassificationObservation]
//                else { fatalError() }
//            completion(observations)
//        })
//        let handler = VNImageRequestHandler(cgImage: inputImage)
//        try! handler.perform([request])
//    }

    func runWithoutVision(featureValue: MLFeatureValue) -> UpdatableMNISTDigitClassifierOutput? {
        guard let imageBuffer = featureValue.imageBufferValue else {
            return nil
        }
        let model =  ModelUpdater.liveModel

        let modelConfig = MLModelConfiguration()
        modelConfig.computeUnits = .all

        let input = UpdatableMNISTDigitClassifierInput(image: imageBuffer)
        return try? model.prediction(input: input)
    }
}
