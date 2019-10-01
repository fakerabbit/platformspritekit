//
//  Joystick.swift
//  Platformer
//
//  Created by Mirko Justiniano on 9/24/19.
//  Copyright © 2019 idevcode. All rights reserved.
//

import Foundation
import SpriteKit

class Joystick {
    
    var joystick: SKNode?,
        joystickKnob: SKNode?,
        joystickAction = false,
        knobRadius: CGFloat = 50.0
    
    func setup(scene: SKScene) {
        let camera = scene.childNode(withName: "cameraNode")
        joystick = camera!.childNode(withName: "joystick")
        joystickKnob = joystick?.childNode(withName: "knob")
        joystick?.zPosition = 1
        let initialVerticalOffset: CGFloat = -UIScreen.main.bounds.size.height
        let initialHorizontalOffset = UIScreen.main.bounds.size.width + 200
        joystick?.position.y = initialVerticalOffset
        joystick?.position.x = -initialHorizontalOffset
    }
    
    func touchesBegan(touch: UITouch) {
        if let joystickKnob = joystickKnob {
            let location = touch.location(in: joystick!)
            joystickAction = joystickKnob.frame.contains(location)
        }
    }
    
    func touchesMoved(touch: UITouch) {
        if !joystickAction { return }
        guard let joystick = joystick else { return }
        guard let joystickKnob = joystickKnob else { return }
        let position = touch.location(in: joystick)
        let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
        let angle = atan2(position.y, position.x)
        
        if knobRadius > length {
            joystickKnob.position = position
        } else {
            joystickKnob.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
        }
    }
    
    func touchesEnded(touch: UITouch) {
        let xJoystickCoordinate = touch.location(in: joystick!).x
        let xLimit: CGFloat = 200.0
        if xJoystickCoordinate > -xLimit && xJoystickCoordinate < xLimit {
            resetKnobPosition()
        }
    }
    
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 0.1)
        moveBack.timingMode = .linear
        joystickKnob?.run(moveBack)
        joystickAction = false
    }
}
