//
//  ViewController.swift
//  StyleTransferSample
//
//  Created by Shuichi Tsutsumi on 2020/01/26.
//  Copyright © 2020 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import Vision
import CircularCarousel

let numStyles: Int = 26

class ViewController: UIViewController {
        
    private var model: VNCoreMLModel!
    
    private var originalImage: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var carousel : CircularCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carousel.delegate = self
        carousel.dataSource = self

        originalImage = imageView.image!
        
        let stylizer = stylize()
        let mlModel = stylizer.model
        model = try! VNCoreMLModel(for: mlModel)
    }
    
    func selectStyle(with index: Int) {
        let multiArray = try! MLMultiArray(shape: [26,1,1,1,1], dataType: .double)
        for i in 0..<numStyles {
            multiArray[i] = 0
        }
        multiArray[index] = 1
        let featureValue = MLFeatureValue(multiArray: multiArray)
        model.featureProvider = try! MLDictionaryFeatureProvider(dictionary: [
            "style_num__0": featureValue,
        ])

        let request = VNCoreMLRequest(model: model) { (request, error) in
            if let error = error {
                print("error:\(error)")
                return
            }
            guard let observation = request.results?.first as? VNPixelBufferObservation else { fatalError() }
            let image = observation.image
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.imageView.image = image
            }
        }
                
        guard let cgImage = originalImage.cgImage else { fatalError() }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try! handler.perform([request])
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        imageView.image = originalImage
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
