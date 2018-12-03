//
//  ViewController.swift
//  FlightKartika
//
//  Created by kd15abf on 03/12/2018.
//  Copyright © 2018 kd15abf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var gameBackground: UIImageView!
    
    @IBOutlet weak var treeScenery: UIImageView!
    var dynamicAnimator: UIDynamicAnimator!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        buildBackground()
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)

        createObstacles()
        
        
    }
    
    func createObstacles() {
        
        let randomInt = arc4random_uniform(10) + 1
        
        
        let crowObstacle = UIImageView(image:nil)
        crowObstacle.image = UIImage(named:"bird\(randomInt).png")
        crowObstacle.frame = CGRect(x:0, y:0, width: 100, height: 100)
        crowObstacle.center.x = UIScreen.main.bounds.maxX - 150
        crowObstacle.center.y = 100
        
        let dynamics = UIDynamicItemBehavior(items: [crowObstacle
            ])
        
        dynamics.addLinearVelocity(CGPoint(x: -200, y: 0), for: crowObstacle)
        
        
        self.view.addSubview(crowObstacle)
        dynamicAnimator.addBehavior(dynamics)

        
        
        
        
        
        
        
    }
    
    
    
    func buildBackground() {
        
        var roadImages = Array<UIImage>()
        var treeImages = Array<UIImage>()
        
        for i in 1...19 {
            roadImages.append(UIImage(named: "road\(i).png")!)
        }
        
        for i in 1...17 {
            treeImages.append(UIImage(named:"tree\(i).png")!)
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

