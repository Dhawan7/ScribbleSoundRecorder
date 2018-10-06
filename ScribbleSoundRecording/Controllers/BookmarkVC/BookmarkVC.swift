//
//  BookmarkVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 05/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class BookmarkVC: UIViewController {
    
    //Mark: outlet's
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    //Mark: let, var
    var arrNameSong = ["Record 5", "Record 1", "Record 3", "Record 7", "Record 3"]
    var arrImageSong = [#imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "2"),]
    
    
    //Mark: Control flow
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        swipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissView()
    }
    
    func swipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
    }
    
    func dismissView(){
        UIView.animate(withDuration: 0.3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func swipeAction(sender: UISwipeGestureRecognizer){
        dismissView()
    }
    

}


extension BookmarkVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImageSong.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookmarkTableView.dequeueReusableCell(withIdentifier: "bookmarkCells") as! BookmarkTVC
        cell.imgSong.image = arrImageSong[indexPath.row]
        return cell
    }
}
