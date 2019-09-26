//
//  Player.swift
//  Platformer
//
//  Created by Mirko Justiniano on 9/25/19.
//  Copyright © 2019 idevcode. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    
    let playerSpeed = 4.0
    var playerIsFacingRight = true
    var player: SKNode?
    var joystick: Joystick?
    
    func setup(scene: SKScene, control: Joystick) {
        player = scene.childNode(withName: "player")
        joystick = control
    }
    
    func update(deltaTime: Double) {
        guard let joystickKnob = joystick!.joystickKnob else { return }
        guard let player = player else { return }
        let xPosition = Double(joystickKnob.position.x)
        let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        
        let faceAction: SKAction!
        let movingRight = xPosition > 0
        let movingLeft = xPosition < 0
        if movingLeft && playerIsFacingRight {
            playerIsFacingRight = false
            let faceMovement = SKAction.scaleX(to: -1, duration: 0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else if movingRight && !playerIsFacingRight {
            playerIsFacingRight = true
            let faceMovement = SKAction.scaleX(to: 1, duration: 0)
            faceAction = SKAction.sequence([move, faceMovement])
        } else {
            faceAction = move
        }
        player.run(faceAction)
    }
}
