//
//  ViewController.swift
//  ScratchImageExample
//
//  Created by cashwalk on 2018. 5. 17..
//  Copyright © 2018년 cashwalk. All rights reserved.
//

import UIKit
import ScratchImage

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var scratchImageView: ScratchImageView! {
        didSet {
            scratchImageView.backgroundImageColor = UIColor.brown
            scratchImageView.delegate = self
        }
    }
    @IBOutlet weak var percentLabel: UILabel! {
        didSet {
            percentLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    // MARK: - Overridden: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - ScratchImageViewDelegate

extension ViewController: ScratchImageViewDelegate {
    
    func scratchImageViewScratchBegan(_ imageView: ScratchImageView) {
    }
    
    func scratchImageViewScratchMoved(_ imageView: ScratchImageView) {
        percentLabel.text = "\( NSString(format: "%.2f", imageView.getScratchPercent() * 100))%"
    }
    
}

