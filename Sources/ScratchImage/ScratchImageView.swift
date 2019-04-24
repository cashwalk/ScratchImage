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
    private var scratched: Double = 0.0
    
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
            scratch(from: point, to: currentLocation)
            lastPoint = currentLocation
        }
    }
    
    // MARK: - Public methods
    
    public func getScratchPercent() -> Double {
        return scratched / Double(frame.width * frame.height)
    }
    
    public func reset() {
        guard let backgroundImageColor = backgroundImageColor else {return}
        image = UIImage.fromColor(color: backgroundImageColor)
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
    
}
