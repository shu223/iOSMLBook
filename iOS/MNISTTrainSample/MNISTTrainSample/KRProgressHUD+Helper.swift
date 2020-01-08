//
//  KRProgressHUD+Helper.swift
//  MNISTTrainSample
//
//  Created by Shuichi Tsutsumi on 2020/01/03.
//  Copyright © 2020 Shuichi Tsutsumi. All rights reserved.
//

import Foundation
import KRProgressHUD

extension KRProgressHUD {
    public static func showOnMainThread(withMessage message: String? = nil, completion: CompletionHandler? = nil) {
        DispatchQueue.main.async {
            KRProgressHUD.show(withMessage: message, completion: completion)
        }
    }
    
    public static func updateOnMainThread(message: String) {
        DispatchQueue.main.async {
            KRProgressHUD.update(message: message)
        }
    }
}
