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
    
    // MARK: - UI Components
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("reset", for: .normal)
        return button
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image.jpg"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let scratchImageView: ScratchImageView = {
        let scratchImageView = ScratchImageView(imageColor: UIColor.brown)
        scratchImageView.translatesAutoresizingMaskIntoConstraints = false
        return scratchImageView
    }()
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    // MARK: - Overridden: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProperties()
        setSelector()
        view.addSubview(resetButton)
        view.addSubview(imageView)
        view.addSubview(scratchImageView)
        view.addSubview(percentLabel)
        layout()
    }
    
    // MARK: - Private methods
    
    private func layout() {
        resetButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 32).isActive = true
        resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        imageView.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 32).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        scratchImageView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        scratchImageView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        scratchImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        scratchImageView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        percentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        percentLabel.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -32).isActive = true
    }
    
    private func setProperties() {
        view.backgroundColor = .white
        scratchImageView.delegate = self
    }
    
    private func setSelector() {
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
    }
    
    // MARK: - Private selector
    
    @objc private func resetButtonClicked() {
        scratchImageView.reset()
        percentLabel.text = nil
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

