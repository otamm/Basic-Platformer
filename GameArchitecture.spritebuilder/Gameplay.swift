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
}