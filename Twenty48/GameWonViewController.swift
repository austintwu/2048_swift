//
//  GameWonViewController.swift
//  Twenty48
//
//  Created by Austin Wu on 12/12/14.
//  Copyright (c) 2014 Austin Wu. All rights reserved.
//

import Foundation
import SpriteKit

class GameWonViewController : UIViewController, UIGestureRecognizerDelegate {
    var gameViewController: GameViewController!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func passController(gameViewController: GameViewController){
        self.gameViewController = gameViewController
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "\(gameViewController.twenty48.score)"
    }
    
    @IBAction func didTapPlayAgain(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: {
            self.gameViewController.twenty48.beginGame()
        })
    }    
}
