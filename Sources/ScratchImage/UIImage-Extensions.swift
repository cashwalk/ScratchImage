//
//  UIImage-Extensions.swift
//  ScratchImage
//
//  Created by Cashwalk on 2018. 5. 17..
//  Copyright © 2018년 Cashwalk. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
