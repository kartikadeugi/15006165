//
//  ViewController.swift
//  FlightKartika
//
//  Created by kd15abf on 03/12/2018.
//  Copyright © 2018 kd15abf. All rights reserved.
//

import UIKit
protocol avatarDelegate {
    func getAvatar()
}

var playerScore = 0

class ViewController: UIViewController, UICollisionBehaviorDelegate, avatarDelegate {
 
    
    @IBOutlet weak var scoreDisplay: UITextView!
    @IBOutlet weak var gameBackground: UIImageView!
    @IBOutlet weak var treeScenery: UIImageView!
    var dynamicAnimator: UIDynamicAnimator!
    
    var birdImages = Array<UIImage>()
    var coinImages = Array<UIImage>()
    
    
    var obstacleTimer: Timer!
    var coinTimer: Timer!
    
    var countTimer: Timer!
    var countDownTotal = 10
    
    @IBOutlet weak var player: PlayerTouch!
    
    var collisionBehaviour: UICollisionBehavior!
    
   
    func startTimer() {
        obstacleTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (T) in
            playerScore = playerScore + 2
            self.createObstacles()
            
        } )
        
        coinTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true, block: { (T) in
            self.createCoins()
        } )
        
        countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    // Called when a collision, between a dynamic item and a collision boundary, has begun.
    // In order for this method to work, it must conform with the UICollisionDelegate protocol.
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        playerScore = playerScore - 2
        print("Collision")
    }
    
    @objc func updateTimer() {
        

        scoreDisplay.text = "🏆\(playerScore)"
        print(countDownTotal)
        
        if(countDownTotal != 0) {
            countDownTotal = countDownTotal - 1
        } else {
            countTimer.invalidate()
            obstacleTimer.invalidate()
            coinTimer.invalidate()
            gameOverScreen()
        }
    }
    
    
    func gameOverScreen() {
        let gameScene = UIStoryboard(name: "GameOver", bundle:nil).instantiateViewController(withIdentifier: "GameOverScreen") as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = gameScene
    }
    func getAvatar() {
        collisionBehaviour.removeAllBoundaries()

        collisionBehaviour.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: player.frame))
    }
    
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        
        // Initialising the dynamic animator
        player.myDelegate = self

        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        collisionBehaviour = UICollisionBehavior()
        collisionBehaviour.collisionDelegate = self

        UIDevice.current.setValue(value, forKey: "orientation")
        buildBackground()
        
        startTimer()
        
        
    }
    

   
    func createCoins() {
        
        let randomPosition = Double.random(in: 0...150)
        let createCoins = UIImageView(image:nil)
        createCoins.image = UIImage.animatedImage(with: coinImages, duration: 0.5)
        createCoins.frame = CGRect(x:0, y:randomPosition, width: 40, height: 40)
        createCoins.center.x = UIScreen.main.bounds.maxX - 150
        createCoins.tag = 1
        let coinDynamics = UIDynamicItemBehavior(items: [createCoins])
        let randomSpeed = Double.random(in: -300 ... -100)
        coinDynamics.addLinearVelocity(CGPoint(x: randomSpeed, y:0 ),for: createCoins)
        self.view.addSubview(createCoins)
        dynamicAnimator.addBehavior(coinDynamics)
        
        let coinCollision = UICollisionBehavior(items: [createCoins])
        dynamicAnimator.addBehavior(coinCollision)
        
        coinCollision.action = {


            if(self.player.frame.contains(createCoins.frame)) {
                createCoins.removeFromSuperview()
                self.dynamicAnimator.removeBehavior(coinCollision)
                playerScore = playerScore + 1
            }

        }
        
    }
    

    
    
    func createObstacles() {
        
        let randomPosition = Double.random(in: 0...150)
        
        
        let crowObstacle = UIImageView(image:nil)
        crowObstacle.tag = 0
        crowObstacle.image = UIImage.animatedImage(with: birdImages, duration: 0.5)
        crowObstacle.frame = CGRect(x:0, y:randomPosition, width: 100, height: 100)
        crowObstacle.center.x = UIScreen.main.bounds.maxX - 150
        
        // creating dynamic behaviour to crow obstances
        let crowDynamics = UIDynamicItemBehavior(items: [crowObstacle
            ])
    
        let randomSpeed = Double.random(in: -500 ... -200)
        crowDynamics.addLinearVelocity(CGPoint(x: randomSpeed, y: 0), for: crowObstacle)
        crowDynamics.elasticity = 0.5


        self.view.addSubview(crowObstacle)
        collisionBehaviour.addItem(crowObstacle)

        getAvatar()

        dynamicAnimator.addBehavior(crowDynamics)
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
            
            if(i<7) {
                coinImages.append(UIImage(named:"coin\(i).png")!)
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

