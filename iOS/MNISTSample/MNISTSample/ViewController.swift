//
//  ViewController.swift
//  KerasMNISTSample
//
//  Created by Shuichi Tsutsumi on 2019/12/04.
//  Copyright © 2019 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var drawView: DrawView!
    @IBOutlet private weak var predictionLabel: UILabel!
    @IBOutlet private weak var clearBtn: UIButton!

    private let classifier = DigitClassifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clearBtn.isHidden = true
        predictionLabel.text = nil
    }

    @IBAction func clearBtnTapped(sender: UIButton) {
        // clear the drawView
        drawView.lines = []
        drawView.setNeedsDisplay()
        predictionLabel.text = nil
        clearBtn.isHidden = true
    }

    @IBAction func detectBtnTapped(sender: UIButton) {
        // get the drawView context so we can get the pixel values from it to intput to network
        guard let cgImage = drawView.getViewContext()?.makeImage() else {return}

        classifier.run(inputImage: cgImage) { [weak self] observations in
            guard let self = self else { return }
            // show the prediction
            guard let firstResult = observations.first?.identifier else { return }
            self.predictionLabel.text = "\(firstResult)"
            self.clearBtn.isHidden = false
        }
    }
}

