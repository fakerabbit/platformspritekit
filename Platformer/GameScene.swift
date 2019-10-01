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
    
    let cameraNode = Camera()
    let joystick = Joystick()
    let player = Player()
    let sentinel = Sentinel()
    var landed = false
    
    // Sprite Engine
    var previousTimeInterval: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        cameraNode.setup(scene: self)
        joystick.setup(scene: self)
        player.setup(scene: self, control: joystick)
        sentinel.setup(scene: self)
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
        cameraNode.update(deltaTime: deltaTime, position: player.player!.position)
        sentinel.update(deltaTime: deltaTime)
    }
}

// MARK:- Collision
extension GameScene: SKPhysicsContactDelegate {
    
    struct Collision {
        enum Masks: Int {
            case killing, player, reward, ground, sentinel, invisibleBlocks
            var bitmask: UInt32 { return 1 << self.rawValue }
        }
        
        let masks: (first: UInt32, second: UInt32)
        
        func matches(_ first: Masks, _ second: Masks) -> Bool {
            return (first.bitmask == masks.first && second.bitmask == masks.second) ||
            (first.bitmask == masks.second && second.bitmask == masks.first)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //debugPrint("contact.bodyA.categoryBitMask: \(contact.bodyA.categoryBitMask)")
        //debugPrint("contact.bodyB.categoryBitMask: \(contact.bodyB.categoryBitMask)")
        //debugPrint("bitmask: \(Collision.Masks.sentinel.bitmask)")
        let collision = Collision(masks: (first: contact.bodyA.categoryBitMask, second: contact.bodyB.categoryBitMask))
        
        if collision.matches(.player, .ground) {
            player.playerStateMachine.enter(LandingState.self)
        }
        
        if collision.matches(.sentinel, .ground) {
            if !landed {
                landed = true
                sentinel.stateMachine.enter(IdleSentinelState.self)
            }
        }
    }
}
