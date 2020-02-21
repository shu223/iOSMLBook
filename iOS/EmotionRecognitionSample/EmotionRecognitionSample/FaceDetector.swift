//
//  FaceDetector.swift
//
//  Copyright © 2019 Shuichi Tsutsumi. All rights reserved.
//

import Vision

class FaceDetector: ImageBasedDetector {
    
    func prepare(completionHandler: @escaping ([VNFaceObservation]) -> Void) {
        
        request = VNDetectFaceLandmarksRequest { (request, error) in
            if let error = error {
                print(error)
                completionHandler([])
                return
            }
            guard let faces = request.results as? [VNFaceObservation] else {
                completionHandler([])
                return
            }
            completionHandler(faces)
        }
    }
}
