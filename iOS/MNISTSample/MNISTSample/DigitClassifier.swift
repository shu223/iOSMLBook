//
//  DigitClassifier.swift
//  KerasMNISTSample
//
//  Created by Shuichi Tsutsumi on 2019/12/05.
//  Copyright © 2019 Shuichi Tsutsumi. All rights reserved.
//

import Foundation
import Vision

class DigitClassifier {
    
    private let model: VNCoreMLModel
    
    init() {
        model =  try! VNCoreMLModel(for: ModifiedMNISTDigitClassifier().model)
    }
    
    func run(inputImage: CGImage, completion: @escaping ([VNClassificationObservation]) -> Void) {
        let request = VNCoreMLRequest(model: model, completionHandler: { request, error in
            guard let observations = request.results as? [VNClassificationObservation]
                else { fatalError() }
            completion(observations)
        })
        let handler = VNImageRequestHandler(cgImage: inputImage)
        try! handler.perform([request])
    }
}
