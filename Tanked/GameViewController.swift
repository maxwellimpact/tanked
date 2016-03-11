//
//  GameViewController.swift
//  Tanked
//
//  Created by Jonathan Cox on 6/26/15.
//  Copyright (c) 2015 Jonathan Cox. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {

    
    var skView = SKView()
    var gameScene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            gameScene = scene
            
            skView.presentScene(scene)
        }
    }
    
    
    // --- tank controls ---
    @IBAction func leftTouchDown(sender: UIButton) {gameScene.tankLeft = true}
    @IBAction func leftTouchUp(sender: UIButton) {gameScene.tankLeft = false}
    
    @IBAction func rightTouchDown(sender: UIButton) {gameScene.tankRight = true}
    @IBAction func rightTouchUp(sender: UIButton) {gameScene.tankRight = false}
    
    @IBAction func upTouchDown(sender: UIButton) {gameScene.tankUp = true}
    @IBAction func upTouchUp(sender: UIButton) {gameScene.tankUp = false}
    
    @IBAction func downTouchDown(sender: UIButton) {gameScene.tankDown = true}
    @IBAction func downTouchUp(sender: UIButton) {gameScene.tankDown = false}
    
    @IBAction func barrelLeftDown(sender: UIButton) {gameScene.barrelLeft = true}
    @IBAction func barrelLeftUp(sender: UIButton) {gameScene.barrelLeft = false}
    
    @IBAction func barrelRightDown(sender: UIButton) {gameScene.barrelRight = true}
    @IBAction func barrelRightUp(sender: UIButton) {gameScene.barrelRight = false}
    
    @IBAction func fireDown(sender: UIButton) {gameScene.fireWeapon = true}
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
