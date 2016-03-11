//
//  GameScene.swift
//  Tanked
//
//  Created by Jonathan Cox on 6/26/15.
//  Copyright (c) 2015 Jonathan Cox. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var lastTouch = UITouch()
    var didTouch = false
    var velocity : Double = 250.0
    var turnVelocity : Double = 0.12
    let hotSpotRadius = 5
    
    var blueTank = Tank()
    var tankBarrelJoint = SKPhysicsJoint()
    
    var tankLeft = false
    var tankRight = false
    var tankUp = false
    var tankDown = false
    var tankLeftOn = false
    var tankRightOn = false
    
    var barrelLeft = false
    var barrelRight = false
    
    var fireWeapon = false
    

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        physicsWorld.contactDelegate = self
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        // assume the tank is always available
        blueTank.body = childNodeWithName("blueTank")!
        blueTank.barrel = childNodeWithName("blueTankBarrel")!
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        print( "contact was made" )
        
        if contact.bodyA.node?.name == "bullet" {
            explodeBullet(contact.bodyA.node!)
        }
        
        if contact.bodyB.node?.name == "bullet" {
            explodeBullet(contact.bodyB.node!)
        }
        
    }
    
    func explodeBullet(bullet: SKNode){
        let smoke = SKSpriteNode(imageNamed: "smokeGrey3")
        
        smoke.position = bullet.position
        
        self.addChild(smoke)
        
        let fadeAction = SKAction.fadeAlphaTo(0.0, duration: 0.5)
        let shrinkAction = SKAction.scaleTo(0.3, duration: 0.5)
        
        smoke.runAction(shrinkAction)
        
        smoke.runAction(fadeAction, completion: {
            self.removeFromParent()
        })
        
        bullet.removeFromParent()
    }
    
    func checkTankShouldMove(){
        if tankLeft {
            blueTank.moveLeft()
            tankLeftOn = true
        }
        
        if tankRight {
            blueTank.moveRight()
            tankRightOn = true
        }
        
        if tankUp {
            blueTank.moveForward()
        }
        
        if tankDown {
            blueTank.moveBackward()
        }
        
        if !tankLeft && tankLeftOn {
            blueTank.dampenRotation()
            tankLeftOn = false
        }
        
        if !tankRight && tankRightOn {
            blueTank.dampenRotation()
            tankRightOn = false
        }
    }
    
    func checkBarrelShouldMove(){
        if barrelLeft {
            blueTank.rotateBarrelLeft()
        }
        
        if barrelRight {
            blueTank.rotateBarrelRight()
        }
    }
    
    func checkShouldFireWeapon(){
        if fireWeapon {
            blueTank.fireMainWeapon()
            fireWeapon = false
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        checkTankShouldMove()
        checkBarrelShouldMove()
        checkShouldFireWeapon()
        blueTank.update()
    }
}
