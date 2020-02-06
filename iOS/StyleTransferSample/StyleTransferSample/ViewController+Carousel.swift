//
//  ViewController+carousel.swift
//  StyleTransferSample
//
//  Created by Shuichi Tsutsumi on 2020/02/06.
//  Copyright © 2020 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import CircularCarousel

fileprivate struct Constants {
    static let scaleMultiplier:CGFloat = 0.25
    static let minScale:CGFloat = 0.55
    static let maxScale:CGFloat = 1.08
    static let minFade:CGFloat = -2.0
    static let maxFade:CGFloat = 2.0
    static let itemWidth: CGFloat = 100.0
}

extension ViewController: CircularCarouselDataSource {
    //
    func numberOfItems(inCarousel carousel: CircularCarousel) -> Int {
        return numStyles
    }
    
    func carousel(_: CircularCarousel, viewForItemAt indexPath: IndexPath, reuseView view: UIView?) -> UIView {
        var imageView = view as? UIImageView
        
        if imageView == nil {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.itemWidth, height: Constants.itemWidth))
            imageView?.layer.cornerRadius = 4
            imageView?.layer.masksToBounds = true
        }
        imageView?.image = UIImage(named: "style\(indexPath.item)")!
        
        return imageView!
    }
    
    func carousel<CGFloat>(_ carousel: CircularCarousel, valueForOption option: CircularCarouselOption, withDefaultValue defaultValue: CGFloat) -> CGFloat {
        switch option {
        case .itemWidth:
            return Constants.itemWidth as! CGFloat
            
        case .scaleMultiplier:
            return Constants.scaleMultiplier as! CGFloat
            
        case .minScale:
            return Constants.minScale as! CGFloat
            
        case .maxScale:
            return Constants.maxScale as! CGFloat
            
        case .fadeMin:
            return Constants.minFade as! CGFloat
            
        case .fadeMax:
            return Constants.maxFade as! CGFloat
            
        default:
            return defaultValue
        }
    }
    
    func startingItemIndex(inCarousel carousel: CircularCarousel) -> Int {
        return 0
    }
}

extension ViewController: CircularCarouselDelegate {
    
    func carousel(_ carousel: CircularCarousel, spacingForOffset offset: CGFloat) -> CGFloat {
        // Tweaked values to support even spacing on scaled items
        return 1.20 - abs(offset * 0.12)
    }
    
    func carousel(_ carousel: CircularCarousel, didSelectItemAtIndex index: Int) {
        selectStyle(with: index)
    }
}
