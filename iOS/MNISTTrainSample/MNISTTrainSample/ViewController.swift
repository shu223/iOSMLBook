//
//  ViewController.swift
//  KerasMNISTSample
//
//  Created by Shuichi Tsutsumi on 2019/12/04.
//  Copyright © 2019 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import CoreML
import KRProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var modelStateLabel: UILabel!
    @IBOutlet weak var logTextView: UITextView!
    private var logMessage = "" {
        didSet {
            DispatchQueue.main.async {
                self.logTextView.text = self.logMessage
            }
        }
    }


    @IBOutlet private weak var drawView: DrawView!
    @IBOutlet private weak var predictionLabel: UILabel!
    @IBOutlet private weak var clearBtn: UIButton!

    private let classifier = DigitClassifier()
    private let dataProvider = TrainingDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        predictionLabel.text = nil
        
        updateModelStateLabel(isTrained: false)
        logTextView.text = nil
        logTextView.backgroundColor = UIColor.white
    }

    private func updateModelStateLabel(isTrained: Bool) {
        if isTrained {
            modelStateLabel.text = "Model: Trained"
            modelStateLabel.textColor = UIColor.green
        } else {
            modelStateLabel.text = "Model: Not trained"
            modelStateLabel.textColor = UIColor.red
        }
    }
    
    func performTraining()
    {
        KRProgressHUD.show(withMessage: "Start training", completion: nil)
        guard let trainingData = dataProvider.trainingData else {
            // 学習データの準備
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.dataProvider.prepare(countPerClass: 400, progressHandler: { label in
                    KRProgressHUD.updateOnMainThread(message: "Preparing training data for \(label)")
                }, completionHandler: {
                    self?.performTraining()
                })
            }
            return
        }

        // 学習開始
        DispatchQueue.global(qos: .default).async {
            
            var log = ""
            ModelUpdater.updateWith(trainingData: trainingData, epochHandler: { (epochIndex, lossValue) in
                let message = "[Epoch \(epochIndex+1)] loss: \(lossValue)"
                KRProgressHUD.updateOnMainThread(message: message)
                log.append(message + "\n")
                self.logMessage = log
            }) { success in
                print("Update succeeded? \(success)")
                DispatchQueue.main.async {
                    if success {
                        self.updateModelStateLabel(isTrained: true)
                        KRProgressHUD.showSuccess()
                    } else {
                        KRProgressHUD.showError()
                    }
                }
            }
        }
    }
    
    @IBAction func clearBtnTapped(sender: UIButton) {
        // clear the drawView
        drawView.lines = []
        drawView.setNeedsDisplay()
        predictionLabel.text = nil
    }

    @IBAction func detectButtonTapped(sender: UIButton) {
//        guard let cgImage = drawView.getViewContext()?.makeImage() else { return }
//
//        classifier.run(inputImage: cgImage) { [weak self] observations in
//            guard let self = self else { return }
//            // show the prediction
//            guard let firstResult = observations.first?.identifier else { return }
//            self.predictionLabel.text = "\(firstResult)"
//        }

        guard let featureValue = drawView.featureValue else { return }
        let output = classifier.runWithoutVision(featureValue: featureValue)
        predictionLabel.text = output?.digit
        print("probabilities:\(String(describing: output?.digitProbabilities))")
    }

    @IBAction func trainButtonTapped(sender: UIButton) {
        print("User tapped \"Done\"; kicking off model update...")
        performTraining()
    }
}

