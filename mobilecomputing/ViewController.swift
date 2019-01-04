//
//  ViewController.swift
//  FlightKartika
//
//  Created by kd15abf on 03/12/2018.
//  Copyright © 2018 kd15abf. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

protocol avatarDelegate {
    func getAvatar()
}

var playerScore = 0




class ViewController: UIViewController, UICollisionBehaviorDelegate, avatarDelegate {
 

    @IBOutlet weak var timeDisplay: UITextView!
    @IBOutlet weak var scoreDisplay: UITextView!
    @IBOutlet weak var gameBackground: UIImageView!
    @IBOutlet weak var treeScenery: UIImageView!
    var dynamicAnimator: UIDynamicAnimator!
    
    var birdImages = Array<UIImage>()
    var coinImages = Array<UIImage>()
    var hitEffect = Array<UIImage>()
    var audioPlayer = AVAudioPlayer()

    var planeImages = Array<UIImage>()

    var obstacleTimer: Timer!
    var coinTimer: Timer!
    var countTimer: Timer!
    
    var countDownTotal = 20
    
    var playerHitEffect = UIImageView()
    
    @IBOutlet weak var player: PlayerTouch!
    
    var collisionBehaviour: UICollisionBehavior!
    let soundEffect = URL(fileURLWithPath: Bundle.main.path(forResource: "crow_caw", ofType: "wav")!)

   
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
        behavior.removeItem(item)
        playerScore = playerScore - 4
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        wobble()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundEffect)
            audioPlayer.play()
        } catch {}
        
    }
    
    func wobble() {
        getAvatar()
        playerHitEffect.image = UIImage.animatedImage(with: hitEffect, duration: 0.5)
        playerHitEffect.frame = CGRect(x: player.center.x-50, y: player.center.y-50, width: player.bounds.width+50, height: player.bounds.height+50)
        view.addSubview(playerHitEffect)
        
        let midX = self.view.center.x
        let midY = self.view.center.y
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: midX - 10, y: midY)
        animation.toValue = CGPoint(x: midX + 10, y: midY)
        view.layer.add(animation, forKey: "position")
        
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: { (_) in
            self.playerHitEffect.removeFromSuperview()
        } )

    }
    
    @objc func updateTimer() {
        
        timeDisplay.text = "⌛\(countDownTotal)"
        scoreDisplay.text = "🏆\(playerScore)"
        
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

        player.image = UIImage.animatedImage(with: planeImages, duration: 0.5)
        
        startTimer()
        
        
    }
    

   
    func createCoins() {
        
        let randomPosition = Double.random(in: 0...150)
        let createCoins = UIImageView(image:nil)
        createCoins.image = UIImage.animatedImage(with: coinImages, duration: 0.5)
        createCoins.frame = CGRect(x:0, y:randomPosition, width: 40, height: 40)
        createCoins.center.x = UIScreen.main.bounds.maxX 
        createCoins.tag = 1
        let coinDynamics = UIDynamicItemBehavior(items: [createCoins])
        let randomSpeed = Double.random(in: -300 ... -100)
        coinDynamics.addLinearVelocity(CGPoint(x: randomSpeed, y:0 ),for: createCoins)
        self.view.addSubview(createCoins)
        dynamicAnimator.addBehavior(coinDynamics)
        
        let coinCollision = UICollisionBehavior(items: [createCoins])
        getAvatar()

        dynamicAnimator.addBehavior(coinCollision)
        
        coinCollision.action = {

            if(self.player.frame.intersects(createCoins.frame)) {
                self.dynamicAnimator.removeBehavior(coinCollision)
                createCoins.removeFromSuperview()
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
            
            if(i<16) {
                hitEffect.append(UIImage(named:"tile\(i).png")!)
                planeImages.append(UIImage(named:"plane\(i).png")!)
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

