//
//  UpdatableMNISTDigitClassifier+Updating.swift
//  UpdatableSampleMNISTSample
//
//  Created by Shuichi Tsutsumi on 2019/12/22.
//  Copyright © 2019 Shuichi Tsutsumi. All rights reserved.
//

import CoreML

extension UpdatableMNISTDigitClassifier {
    var imageConstraint: MLImageConstraint {
        let description = model.modelDescription
        
        let inputName = "image"
        let imageInputDescription = description.inputDescriptionsByName[inputName]!
        
        return imageInputDescription.imageConstraint!
    }

    static func updateModel(at url: URL,
                            with trainingData: MLBatchProvider,
                            epochEndHandler: @escaping (Int64, Float) -> Void,
                            completionHandler: @escaping (MLUpdateContext) -> Void) {

        let modelConfig = MLModelConfiguration()
        modelConfig.computeUnits = .all

        let progressHandler = MLUpdateProgressHandlers(forEvents: [.trainingBegin,.epochEnd], progressHandler: { updateContext in
            if updateContext.event == .trainingBegin {
                print("trainingBegin with params: \(updateContext.parameters)")
            } else if updateContext.event == .epochEnd {
                print("epochEnd metrics:\(updateContext.metrics)")
                epochEndHandler(updateContext.metrics[.epochIndex] as! Int64,
                                updateContext.metrics[.lossValue] as! Float)
            }
        }) { updateContext in
            print(updateContext.event)
            completionHandler(updateContext)
        }
        guard let updateTask = try? MLUpdateTask(forModelAt: url, trainingData: trainingData, configuration: modelConfig, progressHandlers: progressHandler)
            else {
                print("Could't create an MLUpdateTask.")
                return
        }
        
        updateTask.resume()
    }
}
