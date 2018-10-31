//
//  CustomPopUp.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 04/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

protocol showConfirmPopupDelegate {
    func conformPopUpDelegate(isFromDelete:Bool)
}

class CustomPopUp: UIViewController {
    
    
    @IBOutlet weak var btnNoDismiss: UIButtonX!
    @IBOutlet weak var lblTitlePopup: UILabel!
    @IBOutlet weak var btnDeletetOutlet: UIButtonX!
    
    var isFromHome:Bool = false
    var isBtnDelete:Bool = false
    var audioURLFromHome:URL!
    var showPopUpDelegate:showConfirmPopupDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 148/255, green: 23/255, blue: 81/255, alpha: 1.0)
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
       // showPopUpDelegate.conformPopUpDelegate(isFromDelete: true)
      
    
             self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnYes(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
      
    }
    
    
    
 
   
    

}
