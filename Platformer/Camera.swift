//
//  Camera.swift
//  Platformer
//
//  Created by Mirko Justiniano on 9/25/19.
//  Copyright © 2019 idevcode. All rights reserved.
//

import Foundation
import SpriteKit

class Camera {
    
    var cameraNode: SKCameraNode?
    
    func setup(scene: SKScene) {
        cameraNode = scene.childNode(withName: "cameraNode") as? SKCameraNode
    }
    
    func update(deltaTime: Double, position: CGPoint) {
        cameraNode?.position.x = position.x
    }
}
