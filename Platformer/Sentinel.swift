//
//  Sentinel.swift
//  Platformer
//
//  Created by Mirko Justiniano on 9/27/19.
//  Copyright © 2019 idevcode. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Sentinel {
    
    let speed:Double = 0.2
    var isFacingRight = true
    var node: SKNode?
    var scene: SKScene?
    var stateMachine: GKStateMachine!
    var previousXPosition: Double = 0
    
    func setup(scene: SKScene) {
        node = scene.childNode(withName: "sentinel")
        self.scene = scene
        
        stateMachine = GKStateMachine(states: [
            WalkingLeftState(node: node!),
            WalkingRightState(node: node!),
            IdleSentinelState(node: node!),
            LandingSentinelState(node: node!)
        ])
        stateMachine.enter(LandingSentinelState.self)
    }
    
    func update(deltaTime: Double) {
        guard let node = node else { return }
        
        //debugPrint("currentState: \(String(describing: stateMachine.currentState?.classForCoder))")
        
        if stateMachine.currentState?.classForCoder == IdleSentinelState.self {
            
            if isFacingRight {
                isFacingRight = false
                self.stateMachine.enter(WalkingLeftState.self)
            } else {
                isFacingRight = true
                self.stateMachine.enter(WalkingRightState.self)
            }
        }
        else if stateMachine.currentState?.classForCoder == WalkingLeftState.self {
            
            let newPosition = Double(1000)
            let displacement = CGVector(dx: -deltaTime * newPosition * speed, dy: 0)
            let move = SKAction.move(by: displacement, duration: 0)
            node.run(move)
            
            if previousXPosition == Double(node.position.x) {
                previousXPosition = 0
                stateMachine.enter(IdleSentinelState.self)
            } else {
                previousXPosition = Double(node.position.x)
            }
        }
        else if stateMachine.currentState?.classForCoder == WalkingRightState.self {
            
            let newPosition = Double(1000)
            let displacement = CGVector(dx: deltaTime * newPosition * speed, dy: 0)
            let move = SKAction.move(by: displacement, duration: 0)
            node.run(move)

            if previousXPosition == Double(node.position.x) {
                previousXPosition = 0
                stateMachine.enter(IdleSentinelState.self)
            } else {
                previousXPosition = Double(node.position.x)
            }
        }
    }
}
