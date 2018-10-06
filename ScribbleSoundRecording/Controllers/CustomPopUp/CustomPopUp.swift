//
//  CustomPopUp.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 04/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class CustomPopUp: UIViewController {
    
    
    @IBOutlet weak var btnNoDismiss: UIButtonX!
    @IBOutlet weak var lblTitlePopup: UILabel!
    @IBOutlet weak var btnDeletetOutlet: UIButtonX!
    
    var isFromHome:Bool = false
    var isBtnDelete:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNoDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnYes(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NoImageTrimVC") as! NoImageTrimVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
 
    @IBAction func btnDelete(_ sender: UIButton) {
        lblTitlePopup.text = "ARE YOU SURE?"
        btnDeletetOutlet.isHidden = true
        isBtnDelete = true
    }
    
    

}
