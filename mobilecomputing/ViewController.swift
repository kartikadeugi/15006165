//
//  ViewController.swift
//  FlightKartika
//
//  Created by kd15abf on 03/12/2018.
//  Copyright © 2018 kd15abf. All rights reserved.
//

import UIKit
protocol avatar {
    func getAvatar()
}

class ViewController: UIViewController{

    

    @IBOutlet weak var gameBackground: UIImageView!
    
    
    @IBOutlet weak var treeScenery: UIImageView!
    var dynamicAnimator: UIDynamicAnimator!
    var timer: Timer!
    
    var birdImages = Array<UIImage>()
    let collisionBehaviour = UICollisionBehavior()


    @IBOutlet weak var player: PlayerTouch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        
        // Initialising the dynamic animator
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)

        UIDevice.current.setValue(value, forKey: "orientation")
        buildBackground()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (T) in self.createObstacles() } )

        
        
    }
    
    @objc func createObstacles() {
        
        
        let randomPosition = Double.random(in: -150...150)
        
        
        let crowObstacle = UIImageView(image:nil)
        crowObstacle.image = UIImage.animatedImage(with: birdImages, duration: 0.5)
        crowObstacle.frame = CGRect(x:0, y:randomPosition, width: 100, height: 100)
        crowObstacle.center.x = UIScreen.main.bounds.maxX - 150
        
        // creating dynamic behaviour to crow obstances
        let dynamics = UIDynamicItemBehavior(items: [crowObstacle
            ])
    
        let randomSpeed = Double.random(in: -500 ... -200)
        dynamics.addLinearVelocity(CGPoint(x: randomSpeed, y: 0), for: crowObstacle)
        gameBackground.addSubview(crowObstacle)
        collisionBehaviour.addItem(crowObstacle)
        collisionBehaviour.addItem(player)
        dynamicAnimator.addBehavior(dynamics)
        dynamicAnimator.addBehavior(collisionBehaviour)

   
        
    }
    
    
    
    func buildBackground() {
        
        var roadImages = Array<UIImage>()
        var treeImages = Array<UIImage>()
        
        for i in 1...19 {
            roadImages.append(UIImage(named: "road\(i).png")!)
            
            if(i<10) {
                birdImages.append(UIImage(named:"bird\(i).png")!)
            }
            
            if(i<18) {
              treeImages.append(UIImage(named:"tree\(i).png")!)
            }
        }
                
        gameBackground.image = UIImage.animatedImage(with: roadImages, duration: 0.5)
        treeScenery.image = UIImage.animatedImage(with: treeImages, duration: 0.5)

    }
    

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

