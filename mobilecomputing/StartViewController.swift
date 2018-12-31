//
//  StartViewController.swift
//  Helicopter Adventures
//
//  Created by temp on 31/12/2018.
//  Copyright © 2018 Kartika. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.image = UIImage(named:"gameBackground.png")
        // Do any additional setup after loading the view.
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
