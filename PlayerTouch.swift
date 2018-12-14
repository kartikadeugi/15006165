//
//  PlayerTouch.swift
//  FlightKartika
//
//  Created by kd15abf on 03/12/2018.
//  Copyright © 2018 kd15abf. All rights reserved.
//

import UIKit

protocol obstacleProtocol {
    var x: Double {get}
}

class PlayerTouch: UIImageView {
    let topBorder = UIScreen.main.bounds.minY + CGFloat(150)

    let bottomBorder = UIScreen.main.bounds.maxY - CGFloat(150)
    
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let startLocation = touch.location(in: self.superview)
            
            
            if(startLocation.y < bottomBorder && startLocation.y > topBorder) {
                self.center.x = startLocation.x
                self.center.y = startLocation.y
            }
        }
    }


    
        
}
