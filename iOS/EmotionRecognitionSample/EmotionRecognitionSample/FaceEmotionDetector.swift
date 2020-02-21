//
//  FaceEmotionDetector.swift
//
//  Created by Shuichi Tsutsumi on 2019/12/26.
//  Copyright © 2019 Shuichi Tsutsumi. All rights reserved.
//

import Vision

class FaceEmotionDetector: ImageBasedDetector {
    
    private let model: VNCoreMLModel
    
    init(mlModel: MLModel) {
        model = try! VNCoreMLModel(for: mlModel)
        super.init()
    }

    func prepare(completionHandler: @escaping ([VNClassificationObservation]) -> Void) {
        
        request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            if let error = error {
                print(error)
                completionHandler([])
                return
            }
            guard let results = request.results as? [VNClassificationObservation] else {
                completionHandler([])
                return
            }
            completionHandler(results)
        })
    }
}

