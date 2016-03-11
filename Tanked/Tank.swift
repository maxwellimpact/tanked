//
//  TankNode.swift
//  Tanked
//
//  Created by Jonathan Cox on 6/28/15.
//  Copyright (c) 2015 Jonathan Cox. All rights reserved.
//

import SpriteKit

class Tank {

    var body = SKNode()
    var barrel = SKNode()
    
    var minVelocity: Double = 100.0
    var maxVelocity: Double = 250.0
    var turnVelocity: Double = 0.12
    var velocity: Double = 250.0
    
    var bulletVelocity: CGFloat = 10.0
    
    var barrelRotation: Double = 0.00
    
    func update(){
        // keep the barrel in sync with the body
        barrel.position = body.position
        barrel.zRotation = body.zRotation + CGFloat( barrelRotation )
    }
    
    
    func fireMainWeapon(){
        
        // make a copy of the bullet
        var bullet = SKSpriteNode(imageNamed: "bulletBlue")
        
        bullet.name = "bullet"
        
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture, size: bullet.size)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.mass = 0.01
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        bullet.physicsBody?.categoryBitMask = 2
        bullet.physicsBody?.collisionBitMask = 4294967295
        bullet.physicsBody?.contactTestBitMask = 4294967295
        
        
        body.scene?.addChild(bullet)
        
        var position = body.position
        
        let distance: CGFloat = 70
        
        position.x += cos(barrel.zRotation - CGFloat(M_PI/2) ) * distance
        position.y += sin(barrel.zRotation - CGFloat(M_PI/2) ) * distance
        
        
        print( barrel.frame.size )
        
        // set the placement of the bullet
        bullet.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bullet.position = position
        bullet.zRotation = barrel.zRotation + CGFloat(M_PI)
        
        // prepare the trajectory and fire
        let dx = cos(barrel.zRotation - CGFloat(M_PI/2) ) * bulletVelocity
        let dy = sin(barrel.zRotation - CGFloat(M_PI/2) ) * bulletVelocity
        
        bullet.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
    }
    
    func slowDownTank(){
        var velocity = body.physicsBody?.velocity
        
        velocity?.dy = velocity!.dy / CGFloat(1.01)
        velocity?.dx = velocity!.dx / CGFloat(1.01)
        
        body.physicsBody?.velocity = velocity!
    }
    
    func rotateBarrelLeft(){
        barrelRotation += 0.01
    }
    
    func rotateBarrelRight(){
        barrelRotation -= 0.01
    }
    
    func moveLeft(){
        slowDownTank()
        body.physicsBody?.applyTorque(CGFloat(turnVelocity))
    }
    
    func moveRight(){
        slowDownTank()
        body.physicsBody?.applyTorque(CGFloat(-turnVelocity))
    }
    
    func moveForward(){
        
        // moves tank forward based on front of tank
        let dx = cos( body.zRotation - CGFloat(M_PI/2) ) * CGFloat(velocity)
        let dy = sin( body.zRotation - CGFloat(M_PI/2) ) * CGFloat(velocity)
        
        body.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
    }
    
    func moveBackward(){
        
        // moves tank forward based on back of tank
        let dx = cos( body.zRotation + CGFloat(M_PI/2) ) * CGFloat(velocity)
        let dy = sin( body.zRotation + CGFloat(M_PI/2) ) * CGFloat(velocity)
        
        body.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
    }
    
    func dampenRotation(){
        if let angularVelocity = body.physicsBody?.angularVelocity {
            // multiply it because its harder to stop once it starts
            body.physicsBody?.applyTorque(-angularVelocity * 3)
        }
    }
        
}
