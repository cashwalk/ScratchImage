//
//  ScratchImageView.swift
//  ScratchImageView
//
//  Created by HanSangbeom on 2017. 4. 14..
//  Copyright © 2017년 Cashwalk, Inc. All rights reserved.
//

import UIKit

public protocol ScratchImageViewDelegate: NSObjectProtocol {
    func scratchImageViewScratchBegan(_ imageView: ScratchImageView)
    func scratchImageViewScratchMoved(_ imageView: ScratchImageView)
}

public class ScratchImageView: UIImageView {
    
    // MARK: - Properties
    
    public var lineType: CGLineCap = .square
    public var lineWidth: CGFloat = 20.0
    public var scratchedPercent: Double {
        return getTransparentPixelsPercent()
    }
    public weak var delegate: ScratchImageViewDelegate?
    
    private(set) var backgroundImage: UIImage?
    private(set) var backgroundImageColor: UIColor?

    private var lastPoint: CGPoint?
    private var scratched: Double = 0.0
    
    // MARK: - Con(De)structor
    
    public convenience init(imageColor: UIColor) {
        self.init(image: nil)
        
        backgroundImageColor = imageColor
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        
        backgroundImage = image
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    // MARK: - Overridden: UIImageView
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let backgroundImageColor = backgroundImageColor {
            image = UIImage.fromColor(color: backgroundImageColor)
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        defer {
            delegate?.scratchImageViewScratchBegan(self)
        }
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        defer {
            delegate?.scratchImageViewScratchMoved(self)
        }
        
        if let touch = touches.first, let point = lastPoint {
            let currentLocation = touch.location(in: self)
            scratch(from: point, to: currentLocation)
            lastPoint = currentLocation
        }
    }
    
    // MARK: - Public methods
    
    public func reset() {
        if let backgroundImageColor = backgroundImageColor {
            image = UIImage.fromColor(color: backgroundImageColor)
        } else if let backgroundImage = backgroundImage {
            image = backgroundImage
        }
        scratched = 0.0
    }
    
    // MARK: - Internal methods
    
    func scratch(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        image?.draw(in: self.bounds)
        
        defer {
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineType)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear)
        context.addPath(path)
        context.strokePath()
        
        var area = (toPoint.x - fromPoint.x) * (toPoint.x - fromPoint.x)
        area += (toPoint.y - fromPoint.y) * (toPoint.y - fromPoint.y)
        area = pow(area, 0.5) * lineWidth
        scratched += Double(area)
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        isUserInteractionEnabled = true
    }
    
}
