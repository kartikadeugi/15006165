//
//  PlayerTouch.swift
//  FlightKartika
//
//  Created by kd15abf on 03/12/2018.
//  Copyright © 2018 kd15abf. All rights reserved.
//

import UIKit

class PlayerTouch: UIImageView {
    let topBorder = UIScreen.main.bounds.minY + CGFloat(30)

    let bottomBorder = UIScreen.main.bounds.maxY - CGFloat(120)
    var myDelegate: avatarDelegate?

    var startLocation: CGPoint?
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        startLocation = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let currentLocation = touches.first?.location(in: self)
        let dx = (currentLocation!.x - startLocation!.x) + self.center.x
        let dy = (currentLocation!.y - startLocation!.y) + self.center.y
        
        if(dy < bottomBorder && dy > topBorder) {
            self.center = CGPoint(x: dx, y: dy)
            self.myDelegate?.getAvatar()
        }

    }
    

    
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let startLocation = touch.location(in: self.superview)
//
//
//            if(startLocation.y > bottomBorder && startLocation.y < topBorder) {
//                self.center.x = startLocation.x
//                self.center.y = startLocation.y
//                self.getAvatar?.getAvatar()
//
//            }
//
//        }
//    }


    
        
}
