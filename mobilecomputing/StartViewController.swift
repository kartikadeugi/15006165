//
//  StartViewController.swift
//  Helicopter Adventures
//
//  Created by temp on 31/12/2018.
//  Copyright © 2018 Kartika. All rights reserved.
//

import UIKit
import AVFoundation

var backgroundAudio = AVAudioPlayer()

class StartViewController: UIViewController {

    @IBOutlet var background: UIImageView!
    let defaults = UserDefaults.standard


    @IBOutlet weak var scoreCard: UIImageView!
    @IBOutlet weak var highScoreText: UILabel!
    
    @IBOutlet weak var crow: UIImageView!
    
    var crowImages = Array<UIImage>()
    let backgroundMusic = URL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: "mp3")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // stop the playing the background music when game is replayed

        background.image = UIImage(named:"startBackground.png")

        // Do any additional setup after loading the view.
        for i in 1...10 {
            crowImages.append(UIImage(named: "bird\(i).png")!)
        }
        
        do {
            backgroundAudio = try AVAudioPlayer(contentsOf: backgroundMusic)
            backgroundAudio.play()
        } catch {}
        
        crow.image = UIImage.animatedImage(with: crowImages, duration: 0.5)
        animateTheCrow(crow: crow)

        
        if UserDefaults.standard.integer(forKey: "score") == 0 {
            defaults.set(0, forKey: "score")
            scoreCard.removeFromSuperview()
            highScoreText.text = ""
        } else {
            let recordedScore = defaults.integer(forKey: "score")
            highScoreText.text = "High Score: \(recordedScore)"
        }
        
       

    }
    

    func animateTheCrow(crow : UIImageView) {
        let crowMovingSpeed = 2/view.frame.size.width
        let duration = (crow.frame.origin.x + crow.frame.size.width) * crowMovingSpeed
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear, animations: {
            // Animate the origin to be off the left side of the screen.
            crow.frame.origin.x = -crow.frame.size.width
        }, completion: {_ in
            // Reset back to the right edge of the screen
            crow.frame.origin.x = self.view.frame.size.width
            self.animateTheCrow(crow: crow)
        })
    }
    
}
