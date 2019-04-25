//
//  UIView-Extensions.swift
//  ScratchImage
//
//  Created by cashwalk on 25/04/2019.
//  Copyright © 2019 cashwalk. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIView {
    func getSnapshot() -> CGImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.cgImage
    }
    
    func getTransparentPixelsPercent() -> Double {
        guard let image = getSnapshot(), let imageData = image.dataProvider?.data else { return 0.0 }
        
        let width = image.width
        let height = image.height
        let imageDataPointer: UnsafePointer<UInt8> = CFDataGetBytePtr(imageData)
        var transparentPixelCount = 0
        
        for x in 0...width {
            for y in 0...height {
                let pixelDataPosition = ((width * y) + x) * 4
                // The alpha value is the last 8 bits of the data
                let alphaValue = imageDataPointer[pixelDataPosition + 3]
                if alphaValue == 0 {
                    transparentPixelCount += 1
                }
            }
        }
        
        var transparentPercent = Double(transparentPixelCount) / Double((width * height))
        transparentPercent = max(transparentPercent, 0)
        transparentPercent = min(transparentPercent, 1)
        return transparentPercent
    }
}
