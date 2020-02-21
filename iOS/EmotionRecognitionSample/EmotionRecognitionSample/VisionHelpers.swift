//
//  VisionHelpers.swift
//
//  Copyright © 2019 Shuichi Tsutsumi. All rights reserved.
//

import Vision

extension VNDetectedObjectObservation {
    
    func boundingBoxInImage(with imageSize: CGSize) -> CGRect {
        let imageW = imageSize.width
        let imageH = imageSize.height
        
        let size = CGSize(width: boundingBox.width * imageW, height: boundingBox.height * imageH)
        let origin = CGPoint(x: boundingBox.minX * imageW, y: (1 - boundingBox.minY) * imageH - size.height)

        return CGRect(origin: origin, size: size)
    }
}

class ImageBasedDetector {
    
    var request: VNImageBasedRequest?

    func perform(cgImage: CGImage) {
        guard let request = request else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try! handler.perform([request])
    }
    
    func perform(cvPixelBuffer: CVPixelBuffer) {
        guard let request = request else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:])
        try! handler.perform([request])
    }
}
