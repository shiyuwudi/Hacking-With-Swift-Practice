//
//  GameScene.swift
//  11-Pachinko with SpriteKit
//
//  Created by shiyuwudi on 16/5/12.
//  Copyright (c) 2016年 shiyuwudi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        //view did load
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.zPosition = -1
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            let box = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 64, height: 64))
            box.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 64, height: 64))
            box.position = location
            addChild(box)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
