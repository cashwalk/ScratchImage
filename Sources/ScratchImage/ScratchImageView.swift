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
    
    public var backgroundImageColor: UIColor? {
        didSet {
            reset()
        }
    }
    public var lineType: CGLineCap = .square
    public var lineWidth: CGFloat = 20.0
    public weak var delegate: ScratchImageViewDelegate?

    private var lastPoint: CGPoint?
    private var erased: Double = 0.0
    
    // MARK: - Con(De)structor
    
    override public init(image: UIImage?) {
        super.init(image: image)
        
        isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
    }
    
    // MARK: - Overridden: UIImageView
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            delegate?.scratchImageViewScratchBegan(self)
        }
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            delegate?.scratchImageViewScratchMoved(self)
        }
        
        if let touch = touches.first, let point = lastPoint {
            let currentLocation = touch.location(in: self)
            eraseBetween(from: point, current: currentLocation)
            lastPoint = currentLocation
        }
    }
    
    // MARK: - Public methods
    
    public func getScratchPercent() -> Double {
        return erased / Double(frame.width * frame.height)
    }
    
    public func reset() {
        guard let backgroundImageColor = backgroundImageColor else {return}
        image = UIImage.fromColor(color: backgroundImageColor)
        erased = 0.0
    }
    
    // MARK: - Private methods
    
    private func eraseBetween(from fromPoint: CGPoint, current currentPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        image?.draw(in: self.bounds)
        
        defer {
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        let path = CGMutablePath()
        path.move(to: fromPoint)
        path.addLine(to: currentPoint)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineType)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear)
        context.addPath(path)
        context.strokePath()
        
        var area = (currentPoint.x - fromPoint.x) * (currentPoint.x - fromPoint.x)
        area += (currentPoint.y - fromPoint.y) * (currentPoint.y - fromPoint.y)
        area = pow(area, 0.5) * lineWidth
        erased += Double(area)
    }
    
}
