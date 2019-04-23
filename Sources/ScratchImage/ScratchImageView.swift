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
            guard let backgroundImageColor = backgroundImageColor else {return}
            image = UIImage.fromColor(color: backgroundImageColor)
        }
    }
    public var lineType: CGLineCap = .square
    public var lineWidth: CGFloat = 20.0
    public weak var delegate: ScratchImageViewDelegate?

    private var lastPoint: CGPoint?
    private var erased: Double = 0.0
    
    // MARK: - Con(De)structor
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        guard let touch = touches.first else {return}
        lastPoint = touch.location(in: self)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        defer {
            delegate?.scratchImageViewScratchMoved(self)
        }
        
        guard let touch = touches.first, let point = lastPoint else {return}
        let currentLocation = touch.location(in: self)
        eraseBetween(fromPoint: point, currentPoint: currentLocation)
        lastPoint = currentLocation
    }
    
    // MARK: - Public methods
    
    public func getScratchPercent() -> Double {
        return erased / Double(frame.width * frame.height)
    }
    
    // MARK: - Private methods
    
    private func eraseBetween(fromPoint: CGPoint, currentPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.frame.size)
        
        image?.draw(in: self.bounds)
        
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
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        var area = (currentPoint.x - fromPoint.x) * (currentPoint.x - fromPoint.x)
        area += (currentPoint.y - fromPoint.y) * (currentPoint.y - fromPoint.y)
        area = pow(area, 0.5) * lineWidth
        erased += Double(area)
        
        UIGraphicsEndImageContext()
    }
    
}
