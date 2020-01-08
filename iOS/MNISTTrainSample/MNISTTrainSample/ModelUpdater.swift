//
//  ModelUpdater.swift
//  MNISTTrainSample
//
//  Created by Shuichi Tsutsumi on 2020/01/03.
//  Copyright © 2020 Shuichi Tsutsumi. All rights reserved.
//

import CoreML
import UIKit

struct ModelUpdater {
    private static var updatedClassifier: UpdatableMNISTDigitClassifier?
    private static let defaultClassifier = UpdatableMNISTDigitClassifier()
    
    static var liveModel: UpdatableMNISTDigitClassifier {
        print(updatedClassifier != nil ? "updated model" : "default model")
        return updatedClassifier ?? defaultClassifier
    }
    
    private static let appDirectory = FileManager.default.urls(for: .applicationSupportDirectory,
                                                               in: .userDomainMask).first!
    private static let defaultModelURL = UpdatableMNISTDigitClassifier.urlOfModelInThisBundle
    private static var updatedModelURL = appDirectory.appendingPathComponent("personalized.mlmodelc")
    private static var tempUpdatedModelURL = appDirectory.appendingPathComponent("personalized_tmp.mlmodelc")

    static func updateWith(trainingData: MLBatchProvider,
                           epochHandler: @escaping (Int64, Float) -> Void,
                           completionHandler: @escaping (Bool) -> Void) {
        
        let currentModelURL = updatedClassifier != nil ? updatedModelURL : defaultModelURL
        
        UpdatableMNISTDigitClassifier.updateModel(at: currentModelURL, with: trainingData, epochEndHandler: epochHandler) { updateContext in
            print("update context:\(updateContext.event)")
            if saveUpdatedModel(updateContext) {
                
                loadUpdatedModel()
                
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    private static func saveUpdatedModel(_ updateContext: MLUpdateContext) -> Bool {
        let updatedModel = updateContext.model
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(at: tempUpdatedModelURL,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            
            try updatedModel.write(to: tempUpdatedModelURL)
            
            _ = try fileManager.replaceItemAt(updatedModelURL,
                                              withItemAt: tempUpdatedModelURL)
            
            print("Updated model saved to:\n\t\(updatedModelURL)")
            return true
        } catch let error {
            print("Could not save updated model to the file system: \(error)")
            return false
        }
    }
    
    /// Loads the updated Drawing Classifier, if available.
    /// - Tag: LoadUpdatedModel
    private static func loadUpdatedModel() {
        guard FileManager.default.fileExists(atPath: updatedModelURL.path) else {
            // The updated model is not present at its designated path.
            return
        }
        
        // Create an instance of the updated model.
        let modelConfig = MLModelConfiguration()
        modelConfig.computeUnits = .all
        guard let model = try? UpdatableMNISTDigitClassifier(contentsOf: updatedModelURL, configuration: modelConfig) else {
            return
        }
        
        // Use this updated model to make predictions in the future.
        updatedClassifier = model
    }
}
