//
//  TabBarDesignVc.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 28/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class TabBarDesignVc: UITabBarController, UITabBarControllerDelegate {
    
    var isFromSearch:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        if isFromSearch{
          //  openPlayer()
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedItem = tabBar.subviews[item.tag + 1]
        let subImageView = selectedItem.subviews.first as? UIImageView
        playBounceAnimation(subImageView!)
    }
    
    func openPlayer(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func playBounceAnimation(_ icon: UIImageView) {
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.7)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        icon.layer.add(bounceAnimation, forKey: nil)
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            //icon.tintColor = .
            
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else{
            return false
        }
        if fromView != toView{
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
    
   
    
    

 

}
