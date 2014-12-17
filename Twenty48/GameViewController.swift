//
//  GameViewController.swift
//  Twenty48
//
//  Created by Austin Wu on 12/15/14.
//  Copyright (c) 2014 Austin Wu. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, Twenty48Delegate {

    var scene : GameScene!
    var twenty48: Twenty48!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure the view
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        //create and configure scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        twenty48 = Twenty48()
        twenty48.delegate = self
        twenty48.beginGame()
        
        //loads scene in view
        skView.presentScene(scene)
    }
    
    //end of game
    func gameDidEnd(twenty48: Twenty48){
        
    }
    
    //beginning of game
    func gameDidBegin(twenty48: Twenty48){
        
    }
    
    //blocks were swiped in one direction
    func blockDidSlide(twenty48: Twenty48, block: Block){
        
    }
    
    //blocks
    func blockDidCombine(twenty48: Twenty48, block: Block){
        
    }

    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
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
