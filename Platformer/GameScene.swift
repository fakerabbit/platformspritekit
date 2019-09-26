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
    
    let player = Player()
    
    // Sprite Engine
    var previousTimeInterval: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        joystick.setup(scene: self)
        player.setup(scene: self, control: joystick)
    }
}

// MARK:- Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            joystick.touchesBegan(touch: touch)
            player.touchesBegan(touch: touch)
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
        player.update(deltaTime: deltaTime)
    }
}
