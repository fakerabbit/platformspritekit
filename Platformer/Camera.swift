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
    var scene: SKScene?
    var world: SKNode?
    var playerNode: SKNode?
    
    func setup(scene: SKScene) {
        self.scene = scene
        cameraNode = scene.childNode(withName: "cameraNode") as? SKCameraNode
        //world = scene.childNode(withName: "worldLayer")
    }
    
    func setPlayer(scene: SKScene, playerNode: SKNode) {
        // Don't try to set up camera constraints if we don't yet have a camera.
        guard let camera = cameraNode else { return }
        self.playerNode = playerNode
        
        // Constrain the camera to stay a constant distance of 0 points from the player node.
        //let zeroRange = SKRange(constantValue: 100.0)
        //let playerNode = playerBot.renderComponent.node
        //let playerBotLocationConstraint = SKConstraint.distance(zeroRange, to: playerNode)
        
        /*
            Also constrain the camera to avoid it moving to the very edges of the scene.
            First, work out the scaled size of the scene. Its scaled height will always be
            the original height of the scene, but its scaled width will vary based on
            the window's current aspect ratio.
        */
        let scaledSize = CGSize(width: scene.size.width * camera.xScale, height: scene.size.height * camera.yScale)

        /*
            Find the root "board" node in the scene (the container node for
            the level's background tiles).
        */
        //let boardNode = childNode(withName: WorldLayer.board.nodePath)!
        
        /*
            Calculate the accumulated frame of this node.
            The accumulated frame of a node is the outer bounds of all of the node's
            child nodes, i.e. the total size of the entire contents of the node.
            This gives us the bounding rectangle for the level's environment.
        */
        //let boardContentRect = boardNode.calculateAccumulatedFrame()
        let boardContentRect = world!.calculateAccumulatedFrame()

        /*
            Work out how far within this rectangle to constrain the camera.
            We want to stop the camera when we get within 100pts of the edge of the screen,
            unless the level is so small that this inset would be outside of the level.
        */
        let xInset = min((scaledSize.width / 2) - 100.0, boardContentRect.width / 2)
        let yInset = min((scaledSize.height / 2) - 100.0, boardContentRect.height / 2)
        
        // Use these insets to create a smaller inset rectangle within which the camera must stay.
        let insetContentRect = boardContentRect.insetBy(dx: xInset, dy: yInset)
        
        // Define an `SKRange` for each of the x and y axes to stay within the inset rectangle.
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)
        
        // Constrain the camera within the inset rectangle.
        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        levelEdgeConstraint.referenceNode = world
        
        /*
            Add both constraints to the camera. The scene edge constraint is added
            second, so that it takes precedence over following the `PlayerBot`.
            The result is that the camera will follow the player, unless this would mean
            moving too close to the edge of the level.
        */
        //camera.constraints = [playerBotLocationConstraint]
        /*
        let horizontalConstraint = SKConstraint.distance(SKRange(upperLimit: 100), to: playerNode)
        let verticalConstraint = SKConstraint.distance(SKRange(upperLimit: 50), to: playerNode)
        let leftConstraint = SKConstraint.positionX(SKRange(lowerLimit: camera.position.x))
        let bottomConstraint = SKConstraint.positionY(SKRange(lowerLimit: camera.position.y))
        let rightConstraint = SKConstraint.positionX(SKRange(upperLimit: (world?.frame.size.width)! - camera.position.x))
        let topConstraint = SKConstraint.positionY(SKRange(upperLimit: (world?.frame.size.height)! - camera.position.y))
        */
        
        //camera.constraints = [horizontalConstraint, verticalConstraint, leftConstraint, bottomConstraint, rightConstraint, topConstraint]
        //camera.constraints = [horizontalConstraint, verticalConstraint, leftConstraint, bottomConstraint]
        //camera.constraints = [horizontalConstraint, verticalConstraint]
        
       // let leftConstraint = SKConstraint.distance(SKRange(lowerLimit: 100, upperLimit: 50), to: playerNode)
        //let bottomConstraint = SKConstraint.positionY(SKRange(upperLimit: playerNode.position.y))
        //camera.constraints = [bottomConstraint, leftConstraint]
    }
    
    func update(deltaTime: Double, position: CGPoint) {
        cameraNode?.position.x = position.x
        //cameraNode?.position.y = position.y
        //debugPrint("height: \(String(describing: scene?.size.height))")
        //debugPrint("cameraNode?.position.y: \(String(describing: cameraNode?.position.y))")
        //debugPrint("position.y: \(position.y)")
    }
    
    /// Scales the scene's camera.
    func updateCameraScale(size: CGSize) {
        /*
            Because the game is normally playing in landscape, use the scene's current and
            original heights to calculate the camera scale.
        */
        if let camera = cameraNode {
            debugPrint("screen: \(UIScreen.main.bounds.size)")
            debugPrint("size: \(size)")
            camera.setScale(0.45)
        }
    }
}
