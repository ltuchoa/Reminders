//
//  TimerViewController.swift
//  Reminders
//
//  Created by Larissa Uchoa on 11/05/20.
//  Copyright © 2020 Larissa Uchoa. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        // Color of the circular path
        shapeLayer.fillColor = UIColor.clear.cgColor
        // Color of the border path
        shapeLayer.strokeColor = UIColor.magenta.cgColor
        // Configuration about the border/progress line
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = .round
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAnimation)))
    }
    
    @objc private func handleTapAnimation () {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic")
    }
    
}
