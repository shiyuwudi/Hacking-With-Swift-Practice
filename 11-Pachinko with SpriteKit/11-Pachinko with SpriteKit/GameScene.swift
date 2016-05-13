//
//  GameScene.swift
//  11-Pachinko with SpriteKit
//
//  Created by shiyuwudi on 16/5/12.
//  Copyright (c) 2016年 shiyuwudi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editingLabel: SKLabelNode!
    
    lazy var balls = [String]()
    
    var score: Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editing: Bool = false {
        didSet{
            editingLabel.text = editing ? "Done" : "Edit"
        }
    }
    
    //取得所有球的名字
    func getBallNames(){
        let fm = NSFileManager.defaultManager()
        let path = NSBundle.mainBundle().resourcePath!
        let contents = try! fm.contentsOfDirectoryAtPath(path)
        for content in contents {
            if content.hasPrefix("ball") {
                balls += [content]
            }
        }
    }
    
    //随机的球名
    func getRandomBall() -> String {
        let randomBalls = GKRandomSource().arrayByShufflingObjectsInArray(balls) as! [String]
        return randomBalls.first!
    }
    
    override func didMoveToView(view: SKView) {
        //view did load
        getBallNames()
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.zPosition = -1
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        addChild(background)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        
        physicsWorld.contactDelegate = self
        
        makeBounceAt(CGPoint(x: 0, y: 0))
        makeBounceAt(CGPoint(x: 256, y: 0))
        makeBounceAt(CGPoint(x: 512, y: 0))
        makeBounceAt(CGPoint(x: 768, y: 0))
        makeBounceAt(CGPoint(x: 1024, y: 0))
        
        makeSlotAt(CGPoint(x: 128, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 384, y: 0), isGood: false)
        makeSlotAt(CGPoint(x: 640, y: 0), isGood: true)
        makeSlotAt(CGPoint(x: 896, y:0), isGood: false)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.text = "Score: 0"
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editingLabel = SKLabelNode(fontNamed: "Chalkduster")
        editingLabel.horizontalAlignmentMode = .Left
        editingLabel.text = "Edit"
        editingLabel.position = CGPoint(x: 80, y: 700)
        addChild(editingLabel)
    }
    
    //识别点击
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            let object = self.nodesAtPoint(location) as [SKNode]
            let names = object.map({ (node) -> String in
                return node.name ?? ""
            })
            if object.contains(editingLabel) {
                editing = !editing
            } else if names.contains("obstruct"){
                //消除障碍
                if editing {
                    for obj in object {
                        if obj.name == "obstruct" { obj.removeFromParent() }
                    }
                }
            }
            else {
                if editing {
                    //放置障碍
                    let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
                    let obstruct = SKSpriteNode(color: RandomColor(), size: size)
                    obstruct.zRotation = RandomCGFloat(min: 0, max: 3)
                    obstruct.position = location
                    obstruct.name = "obstruct"
                    
                    obstruct.physicsBody = SKPhysicsBody(rectangleOfSize: size)
                    obstruct.physicsBody!.dynamic = false
                    
                    addChild(obstruct)
                } else {
                    let ball = SKSpriteNode(imageNamed: getRandomBall())
                    ball.name = "ball"
                    let pb = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
                    pb.restitution = 0.4
                    ball.physicsBody = pb
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    let top = CGPoint(x: location.x, y: 768)
                    ball.position = top
                    addChild(ball)
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func makeBounceAt(p: CGPoint) {
        //a bouncer that will not move but attend collision
        let bouncer = SKSpriteNode(imageNamed: "bouncer.png")
        bouncer.position = p
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.height / 2)
        bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
        bouncer.physicsBody!.dynamic = false
        addChild(bouncer)
    }
    
    func makeSlotAt(p:CGPoint, isGood:Bool) {
        var slotBase: SKSpriteNode
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase.name = "bad"
        }
        slotBase.position = p
        addChild(slotBase)
        slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
        slotBase.physicsBody?.dynamic = false
        
        let slotGlow = SKSpriteNode(imageNamed: (isGood ? "slotGlowGood" : "slotGlowBad"))
        slotGlow.position = p
        addChild(slotGlow)
        
        //spinning effect
        let spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 10)
        let spinForever = SKAction.repeatActionForever(spin)
        slotGlow.runAction(spinForever)
    }
    
    //碰撞检测
    func collisionBetweenBall(ball:SKNode, object:SKNode) {
        if object.name == "good" {
            destroyBall(ball)
            score += 1
        } else if object.name == "bad" {
            destroyBall(ball)
            score -= 1
        }
    }
    
    //移除球
    func destroyBall(ball:SKNode) {
        //特效(SE)
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    //碰撞检测代理
    func didBeginContact(contact: SKPhysicsContact) {
        //找出哪一个是球
        if contact.bodyA.node!.name == "ball" {
            collisionBetweenBall(contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node!.name == "ball" {
            collisionBetweenBall(contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
}
