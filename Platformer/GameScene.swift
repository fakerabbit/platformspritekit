//
//  GameScene.swift
//  Platformer
//
//  Created by Mirko Justiniano on 9/24/19.
//  Copyright © 2019 idevcode. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let joystick = Joystick()
    
    // Sprite Engine
    var previousTimeInterval: TimeInterval = 0,
        playerIsFacingRight = true
    let playerSpeed = 4.0
    var player: SKNode?
    
    override func didMove(to view: SKView) {
        joystick.setup(scene: self)
        player = childNode(withName: "player")
    }
}

// MARK:- Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            joystick.touchesBegan(touch: touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            joystick.touchesMoved(touch: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            joystick.touchesEnded(touch: touch)
        }
    }
}

// MARK:- Game Loop
extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - previousTimeInterval
        previousTimeInterval = currentTime
        
        guard let joystickKnob = joystick.joystickKnob else { return }
        guard let player = player else { return }
        let xPosition = Double(joystickKnob.position.x)
        let displacement = CGVector(dx: deltaTime * xPosition * playerSpeed, dy: 0)
        let move = SKAction.move(by: displacement, duration: 0)
        player.run(move)
    }
}
