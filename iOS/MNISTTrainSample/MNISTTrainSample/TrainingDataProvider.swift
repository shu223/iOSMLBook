//
//  TrainingDataProvider.swift
//  MNISTTrainSample
//
//  Created by Shuichi Tsutsumi on 2020/01/03.
//  Copyright © 2020 Shuichi Tsutsumi. All rights reserved.
//

import CoreML
import UIKit    // for UIImage

class TrainingDataProvider {
    
    var trainingData: MLBatchProvider?
    
    static func makeFeatureProvider(label: String, images: [UIImage]) -> [MLFeatureProvider] {
        // 画像の制約情報（MLImageConstraint）を取得
        let imageConstraint = ModelUpdater.liveModel.imageConstraint
        let imageInputName = "image"
        let digitInputName = "digit"
        
        var featureProviders = [MLFeatureProvider]()
        images.forEach { image in
            guard let cgImage = image.cgImage else { return }

            // 1. 画像データと画像の制約情報からMLFeatureValueオブジェクトを作成
            let imageFeatureValue = try! MLFeatureValue(cgImage: cgImage,
                                                        constraint: imageConstraint)

            // 2. 正解ラベルからMLFeatureValueオブジェクトを作成
            let digitFeatureValue = MLFeatureValue(string: label)
            
            // 3. 入力データ名をキー、1,2のMLFeatureValueオブジェクトを値とするDictionaryから
            // MLDictionaryFeatureProviderオブジェクトを作成
            let inputFeatures = [imageInputName: imageFeatureValue,
                                 digitInputName: digitFeatureValue]
            if let provider = try? MLDictionaryFeatureProvider(dictionary: inputFeatures) {
                featureProviders.append(provider)
            }
        }
        
        return featureProviders
    }
    
    func prepare(countPerClass: Int, progressHandler: (String) -> Void, completionHandler: () -> Void) {
        let folders = Bundle.main.paths(forResourcesOfType: nil,
                                        inDirectory: "data/training")
        print("folders:\(folders.count)")
        //        let label = "\(labelSegmentedCtl.selectedSegmentIndex)"
        var totalFeatureProviders: [MLFeatureProvider] = []
        folders.forEach { folderPath in
            let label = URL(fileURLWithPath: folderPath).lastPathComponent
            progressHandler(label)
            let contents = try! FileManager.default.contentsOfDirectory(atPath: folderPath)
            let imageUrls = contents.prefix(countPerClass).map { folderPath + "/" + $0 }
            let images = imageUrls.map { UIImage(contentsOfFile: $0)! }
            let featureProviders = TrainingDataProvider.makeFeatureProvider(label: label, images: images)
            
            totalFeatureProviders.append(contentsOf: featureProviders)
            print("num train data for \(label): \(featureProviders.count)")
        }
        trainingData = MLArrayBatchProvider(array: totalFeatureProviders)
        completionHandler()
    }
}
