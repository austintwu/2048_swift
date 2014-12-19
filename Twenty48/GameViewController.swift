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
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure the view
        let skView = view as SKView
        skView.multipleTouchEnabled = false
        
        //create and configure scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
    
        //set up swipe recognizers
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //start game
        twenty48 = Twenty48()
        twenty48.delegate = self
        twenty48.beginGame()
    
        //loads scene in view
        skView.presentScene(scene)
    }
    
    //beginning of game
    func gameDidBegin(twenty48: Twenty48) {
        scene.blockLayer.removeAllChildren()
    }
    
    //end of game
    func gameDidEnd(twenty48: Twenty48, win: Bool){
        if win {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gwvc = storyboard.instantiateViewControllerWithIdentifier("gwvcID") as GameWonViewController
            gwvc.passController(self)
            self.presentViewController(gwvc, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let govc = storyboard.instantiateViewControllerWithIdentifier("govcID") as GameOverViewController
            govc.passController(self)
            self.presentViewController(govc, animated: true, completion: nil)
        }
    }
    
    func blockWasAdded(twenty48: Twenty48, block: Block){
        scene.renderNewBlock(block)
    }
    
    //a block slid in one direction
    func blockDidSlide(twenty48: Twenty48, block: Block){
        scene.updateBlockSpriteMove(block) 
    }
    
    //a block moved and movedBlock moved, got deleted, and doubledBlock was doubled
    func blockDidCombine(twenty48: Twenty48, movedBlock: Block, doubledBlock: Block){
        scene.updateBlockCombining(movedBlock, doubledBlock: doubledBlock)
        scoreLabel.text = "SCORE \(twenty48.score)"
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Up:
                twenty48.swipeUp()
            case UISwipeGestureRecognizerDirection.Down:
                twenty48.swipeDown()
            case UISwipeGestureRecognizerDirection.Left:
                twenty48.swipeLeft()
            case UISwipeGestureRecognizerDirection.Right:
                twenty48.swipeRight()
            default:
                break
            }
        }
    }
    
    @IBAction func didTapRestart(sender: UIButton) {
        viewDidLoad()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
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
