//
//  ViewController.swift
//  SuperResolutionSample
//
//  Created by Shuichi Tsutsumi on 2020/02/11.
//  Copyright © 2020 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var inImageView: UIImageView!
    @IBOutlet weak var outImageView: UIImageView!

    var vnModel: VNCoreMLModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let mlModel = srcnn_flexible_shapes()
        vnModel = try! VNCoreMLModel(for: mlModel.model)

        guard let image = inImageView.image else { fatalError() }

        // 元サイズのまま使用
        guard let cgImage = image.cgImage else { fatalError() }
        
        // リサイズして使用
//        let resizedImage = image.resize(size: CGSize(width: 100, height: 100))
//        inImageView.image = resizedImage
//        guard let cgImage = resizedImage?.cgImage else { fatalError() }

        applySRCNN(cgImage: cgImage) { result in
            DispatchQueue.main.async {
                self.outImageView.image = result.image
                print(result.image.size)
            }
        }
    }

    private func applySRCNN(cgImage: CGImage, completion: @escaping (VNPixelBufferObservation) -> Void) {
        let request = VNCoreMLRequest(model: vnModel) { (request, error) in
            if let error = error {
                print(error)
                return
            }
            guard let result = request.results?.first as? VNPixelBufferObservation else { fatalError() }
            completion(result)
        }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try! handler.perform([request])
    }
}

extension VNPixelBufferObservation {
    var image: UIImage {
        let context = CIContext()
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        return UIImage(cgImage: cgImage)
    }
}

// https://qiita.com/ruwatana/items/473c1fb6fc889215fca3
extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContext(resizedSize)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
