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
        player.run(move)
    }
}
