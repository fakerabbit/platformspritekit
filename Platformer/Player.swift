//
//  Player.swift
//  Platformer
//
//  Created by Mirko Justiniano on 9/25/19.
//  Copyright © 2019 idevcode. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Player {
    
    let playerSpeed = 4.0
    var playerIsFacingRight = true
    var player: SKNode?
    var joystick: Joystick?
    var playerStateMachine: GKStateMachine!
    var scene: SKScene?
    
    func setup(scene: SKScene, control: Joystick) {
        player = scene.childNode(withName: "player")
        joystick = control
        self.scene = scene
        
        playerStateMachine = GKStateMachine(states: [
            JumpingState(playerNode: player!),
            WalkingState(playerNode: player!),
            IdleState(playerNode: player!),
            LandingState(playerNode: player!),
            StunnedState(playerNode: player!)
        ])
        playerStateMachine.enter(IdleState.self)
    }
    
    func update(deltaTime: Double) {
        guard let joystickKnob = joystick!.joystickKnob else { return }
        guard let player = player else { return }
        
        let xPosition = Double(joystickKnob.position.x)
        let positivePosition = xPosition < 0 ? -xPosition : xPosition
        
        if floor(positivePosition) != 0 {
            playerStateMachine.enter(WalkingState.self)
        } else {
            playerStateMachine.enter(IdleState.self)
        }
        
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
    
    func touchesBegan(touch: UITouch) {
        
        let location = touch.location(in: scene!)
        if !(joystick!.joystick?.contains(location))! {
            playerStateMachine.enter(JumpingState.self)
        }
    }
}
