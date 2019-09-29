//
//  SentinelStateMachine.swift
//  Platformer
//
//  Created by Mirko Justiniano on 9/27/19.
//  Copyright © 2019 idevcode. All rights reserved.
//

import Foundation
import GameplayKit

fileprivate let characterAnimationKey = "Sprite Animation"

class SentinelState: GKState {
    unowned var node: SKNode
    
    init(node: SKNode) {
        self.node = node
        
        super.init()
    }
}

class LandingSentinelState: SentinelState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        debugPrint("stateClass: \(stateClass)")
        switch stateClass {
        case is LandingSentinelState.Type: return false
        default: return true
        }
    }
        
    override func didEnter(from previousState: GKState?) {
        //stateMachine?.enter(IdleSentinelState.self)
    }
}

class IdleSentinelState: SentinelState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        debugPrint("stateClass: \(stateClass)")
        switch stateClass {
        case is LandingSentinelState.Type, is IdleSentinelState.Type: return false
        default: return true
        }
    }
    
    let textures = SKTexture(imageNamed: "sentinel/0")
    lazy var action = { SKAction.animate(with: [textures], timePerFrame: 0.1) } ()
    
    override func didEnter(from previousState: GKState?) {
        node.removeAction(forKey: characterAnimationKey)
        node.run(action, withKey: characterAnimationKey)
    }
}

class WalkingLeftState: SentinelState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        debugPrint("stateClass: \(stateClass)")
        switch stateClass {
        case is LandingSentinelState.Type, is WalkingLeftState.Type: return false
        default: return true
        }
    }
    
    let textures = SKTexture(imageNamed: "sentinel/2")
    lazy var action = { SKAction.repeatForever(.animate(with: [textures], timePerFrame: 0.1)) } ()
    
    override func didEnter(from previousState: GKState?) {
        node.removeAction(forKey: characterAnimationKey)
        node.run(action, withKey: characterAnimationKey)
    }
}

class WalkingRightState: SentinelState {
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        debugPrint("stateClass: \(stateClass)")
        switch stateClass {
        case is LandingSentinelState.Type, is WalkingRightState.Type: return false
        default: return true
        }
    }
    
    let textures = SKTexture(imageNamed: "sentinel/1")
    lazy var action = { SKAction.repeatForever(.animate(with: [textures], timePerFrame: 0.1)) } ()
    
    override func didEnter(from previousState: GKState?) {
        node.removeAction(forKey: characterAnimationKey)
        node.run(action, withKey: characterAnimationKey)
    }
}
