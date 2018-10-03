//
//  NoImageTrimVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 03/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class NoImageTrimVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(false, animated: true)
    }

    @IBAction func btnSave(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SaveEditSoundVC") as! SaveEditSoundVC
        navigationController?.pushViewController(vc, animated: true)
    }
}
