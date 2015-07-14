//
//  Gameplay.swift
//  GameArchitecture
//
//  Created by Otavio Monteagudo on 7/13/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation;

class Gameplay:CCNode, CCPhysicsCollisionDelegate {
    /* linked objects */
    
    // will contain current level scene.
    weak var levelNode:CCNode!;
    
    // will apply physics on its child nodes
    weak var gamePhysicsNode:CCPhysicsNode!;
    
    // character sprite
    weak var character:CCSprite!;
    
    // flag that marks the end of the level
    weak var flag:CCSprite!;
    
    /* custom variables */
    
    // keeps track about whether or not character is currently performing a jump.
    var jumped:Bool = false
    
    // keeps track of current level; 1 by default.
    var currentLevel:Int = 1;
    
    
    /* cocos2d methods */
    
    // executed as soon as Gameplay is loaded
    func didLoadFromCCB() {
        self.gamePhysicsNode.collisionDelegate = self
    }
    
    // executed just after self.didLoadFromCCB()
    override func onEnter() {
        super.onEnter();
        
        let follow = CCActionFollow(target: self.character, worldBoundary: self.gamePhysicsNode.boundingBox());
        self.gamePhysicsNode.position = follow.currentOffset();
        self.gamePhysicsNode.runAction(follow);
    }
    
    // executed after the transisition from the past scene has finished
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish();
        
        self.userInteractionEnabled = true;
    }
    
    // executed at every new frame
    override func update(delta: CCTime) {
        if CGRectGetMaxX(self.character.boundingBox()) < CGRectGetMinY(self.gamePhysicsNode.boundingBox()) {
            self.gameOver();
        }
    }
    
    override func fixedUpdate(delta: CCTime) {
        self.character.physicsBody.velocity = CGPoint(x: 40, y: character.physicsBody.velocity.y)
    }
    
    /* iOS methods */
    
    // executed once player touches screen
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        // only runs if character is colliding with another physics object (eg. ground)
        self.character.physicsBody.eachCollisionPair { (pair) -> Void in
            if !self.jumped {
                self.character.physicsBody.applyImpulse(CGPoint(x: 0, y: 2000))
                self.jumped = true
                
                NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("resetJump"), userInfo: nil, repeats: false)
            }
        }
    }
    
    /* collision methods */
    
    // executed once a collision between the character and the flag is detected
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, flag: CCNode!) -> Bool {
        paused = true
        
        let popup = CCBReader.load("WinPopup") as! WinPopup;
        popup.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        popup.position = CGPoint(x: 0.5, y: 0.5)
        popup.nextLevelName = "Level3"
        parent.addChild(popup)
        
        return true
    }
    
    /*
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, character: CCNode!, flag: CCNode!) -> Bool {
        paused = true
        
        let popup = CCBReader.load("WinPopup") as! WinPopup
        popup.positionType = CCPositionType(xUnit: .Normalized, yUnit: .Normalized, corner: .BottomLeft)
        popup.position = CGPoint(x: 0.5, y: 0.5)
        popup.nextLevelName = "Level3"
        parent.addChild(popup)
        
        return true
    }
    */
    
    /* custom methods */
    
    // sets jump to 'false' once character touches ground.
    func resetJump() {
        self.jumped = false;
    }
    
    func gameOver() {
        let restartScene = CCBReader.loadAsScene("Level2")
        let transition = CCTransition(fadeWithDuration: 0.8)
        CCDirector.sharedDirector().presentScene(restartScene, withTransition: transition)
    }
}