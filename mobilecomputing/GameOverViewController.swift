//
//  GameOverViewController.swift
//  mobilecomputing
//
//  Created by temp on 29/12/2018.
//  Copyright © 2018 Kartika. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var gameOverBackground: UIImageView!
    @IBOutlet weak var scoreText: UILabel!
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverBackground.image = UIImage(named: "gameOverBackground.png")
        
        
        // Do any additional setup after loading the view.
        let storedScore = defaults.integer(forKey: "score")
        
        if(playerScore > storedScore) {
            defaults.set(playerScore, forKey: "score")
            scoreText.text = "🎖️ New High Score: \(playerScore)"
        } else {
            scoreText.text = "🏁 Score: \(playerScore)"
        }
        
        playerScore = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
