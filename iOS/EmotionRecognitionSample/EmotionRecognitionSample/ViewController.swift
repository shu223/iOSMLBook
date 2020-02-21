//
//  ViewController.swift
//  EmotionRecognitionSample
//
//  Created by Shuichi Tsutsumi on 2020/02/20.
//  Copyright © 2020 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    private let faceDetector = FaceDetector()
    private let emotionDetectorFull = FaceEmotionDetector(mlModel: CNNEmotions().model)
    private let emotionDetector16 = FaceEmotionDetector(mlModel: CNNEmotions_quantized_16().model)
    private let emotionDetector8 = FaceEmotionDetector(mlModel: CNNEmotions_quantized_8().model)

    private var images: [UIImage]!
    private var currentIndex: Int = 0

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var faceImageView: UIImageView!
    @IBOutlet weak var emotionLabel1: UILabel!
    @IBOutlet weak var emotionLabel2: UILabel!
    @IBOutlet weak var emotionLabel3: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImages(from: "images")
        
        imageView.image = images.first
        performRecognition()
    }

    private func loadImages(from folderName: String) {
        let directoryPath = Bundle.main.path(forResource: folderName, ofType: nil)!
        let contents = try! FileManager.default.contentsOfDirectory(atPath: directoryPath)
        images = contents.map({ filename -> UIImage in
            let imagePath = directoryPath + "/" + filename
            return UIImage(contentsOfFile: imagePath)!
        })
    }
    
    private func performRecognition() {
        guard let orgImage = imageView.image else { fatalError() }
        guard let cgImage = orgImage.cgImage else { fatalError() }
        
        faceDetector.prepare { [weak self] faces in
            guard let self = self else { return }
            guard let faceObservation = faces.first else { return }
            let rect = faceObservation.boundingBoxInImage(with: orgImage.size)
            guard let faceImage = cgImage.cropping(to: rect) else { fatalError() }
            self.emotionDetectorFull.perform(cgImage: faceImage)
            self.emotionDetector16.perform(cgImage: faceImage)
            self.emotionDetector8.perform(cgImage: faceImage)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.faceImageView.image = UIImage(cgImage: faceImage)
            }
        }
        
        emotionDetectorFull.prepare { emotions in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.emotionLabel1.text = "Result (Full): " + emotions.first!.identifier
            }
        }
        emotionDetector16.prepare { emotions in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.emotionLabel2.text = "Result (16-bit): " + emotions.first!.identifier
            }
        }
        emotionDetector8.prepare { emotions in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.emotionLabel3.text = "Result (8-bit): " + emotions.first!.identifier
            }
        }
        
        faceDetector.perform(cgImage: cgImage)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        currentIndex += 1
        currentIndex = currentIndex >= images.count ? 0 : currentIndex
        imageView.image = images[currentIndex]
        performRecognition()
    }
}

