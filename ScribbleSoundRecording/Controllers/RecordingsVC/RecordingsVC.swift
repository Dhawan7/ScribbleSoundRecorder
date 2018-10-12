//
//  RecordingsVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 17/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class RecordingsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var btnListView: UIButton!
    @IBOutlet weak var btnGridView: UIButton!
    @IBOutlet weak var recordingCollectionView: UICollectionView!
    @IBOutlet weak var recordingTableView: UITableView!
    @IBOutlet weak var sortingStackView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterOuterView: UIView!
    
    
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    
    //MARK:- Vars,Lets
    var isGridView:Bool!
    var numArr:[Int] = [Int]()
    var filterBtn:Bool = false
    var nameArr:[String] = ["Recording1", "Recording2", "Recording3", "Recording4", "Recording5", "Recording6", "Recording7", "Recording8", "Recording9", "Recording10", "Recording11", "Recording12"]
    var dateArr:[String] = ["25 Jun, 2016", "30 Jun, 2016", "28 Jun, 2016", "2 Jul, 2016", "22 Jan, 2015", "2 Apr, 2017", "21 Jun, 2016", "30 Aug, 2016", "8 Sep, 2016", "24 Jul, 2016", "17 Jan, 2015", "9 Apr, 2017"]
    var convertDateArray:[Date] = []
    var isAssending:Bool = false
    
    
    
    //MARK:- Defualt Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        isGridView = false
        recordingCollectionView.delegate = self
        recordingCollectionView.dataSource = self
        recordingTableView.delegate = self
        recordingTableView.dataSource = self
        recordingTableView.estimatedRowHeight = 70
        recordingTableView.rowHeight = UITableViewAutomaticDimension
        recordingCollectionView.isHidden = true
        dateFormat()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        filterOuterView.alpha = 0.0
        filterView.alpha = 0.0
        filterBtn = false
        
    }
    
    func dateFormat(){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MM, yyyy"
        
        for dateToSort in dateArr{
            let date = dateFormater.date(from: dateToSort)
            if let date = date {
                convertDateArray.append(date)
            }
        }
    }
    
    func dateToString(newDateArr:[Date]){
        dateArr.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM, yyyy"
        for dateToStore in newDateArr{
            let dateStr = dateFormatter.string(from: dateToStore)
            dateArr.append(dateStr)
        }
        
        
    }
    
    //MARK:- Button Actions
    @IBAction func btnGridListToggleAction(_ sender: UIButton) {
        
        toggleListGridView()
    }
    
    @IBAction func btnSortAction(_ sender: UIButton) {
      //  toggleSortingView()
        if filterBtn {
            filterOuterView.alpha = 0.0
            filterView.alpha = 0.0
            filterBtn = false
        } else{
            UIView.animate(withDuration: 0.2) {
                self.filterOuterView.alpha = 1.0
                self.filterView.alpha = 1.0
                self.filterBtn = true
            }
           
            
        }
        
    }
    @IBAction func btnSortBySmallToBigActn(_ sender: UIButton) {
        toggleSortingView()
    }
    @IBAction func btnSortByBigToSmallActn(_ sender: UIButton) {
        toggleSortingView()
        
    }
    @IBAction func btnSortNewToOldActn(_ sender: UIButton) {
        toggleSortingView()
    }
    @IBAction func btnSortOldToNewActn(_ sender: UIButton) {
        toggleSortingView()
    }
    
    @IBAction func btnListAction(_ sender: UIButton) {
        UIView.transition(with: recordingCollectionView, duration: 0.7, options: .transitionCrossDissolve, animations: {
            self.recordingCollectionView.isHidden = true
            //self.recordingTableView.isHidden = false
        }, completion: nil)
        UIView.transition(with: recordingTableView, duration: 0.7, options: .transitionCrossDissolve, animations: {
            //self.recordingCollectionView.isHidden = true
            self.recordingTableView.isHidden = false
            
        }, completion: nil)
    }
    @IBAction func btnGridAction(_ sender: UIButton) {
        UIView.transition(with: recordingCollectionView, duration: 0.7, options: .transitionCrossDissolve, animations: {
            self.recordingCollectionView.isHidden = false
            //self.recordingTableView.isHidden = true
        }, completion: nil)
        UIView.transition(with: recordingTableView, duration: 0.7, options: .transitionCrossDissolve, animations: {
            //self.recordingCollectionView.isHidden = false
            self.recordingTableView.isHidden = true
        }, completion: nil)
    }
    @IBAction func swipeGestureAction(_ sender: UISwipeGestureRecognizer) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnSortByDate(_ sender: UIButton) {
        if isAssending{
            let valueDesending = convertDateArray.sorted(by: { $0.compare($1) == .orderedAscending })
            dateToString(newDateArr: valueDesending)
            isAssending = false
        } else{
            let valueAssending = convertDateArray.sorted(by: { $0.compare($1) == .orderedDescending})
            dateToString(newDateArr: valueAssending)
            isAssending = true
        }
       
            self.recordingTableView.reloadData()
            self.recordingCollectionView.reloadData()
            self.filterOuterView.alpha = 0.0
       
    }

    @IBAction func btnSortByName(_ sender: UIButton) {
        
        if isAssending{
            let sortDecending = nameArr.sorted{ $0.localizedCaseInsensitiveCompare($1) == .orderedDescending }
            self.nameArr = sortDecending
            isAssending = false
            
        } else{
            let sortAssending = nameArr.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
            self.nameArr = sortAssending
            isAssending = true
        }
        
        self.recordingTableView.reloadData()
        self.recordingCollectionView.reloadData()
        self.filterOuterView.alpha = 0.0
    }
    
    @IBAction func btnSortBySize(_ sender: UIButton) {
        
    }
    
    
    
    //MARK:- Custom User-Defined functions
    func toggleListGridView(){
        if isGridView{
            UIView.transition(with: recordingCollectionView, duration: 0.7, options: .transitionCrossDissolve, animations: {
                self.recordingCollectionView.isHidden = true
                //self.recordingTableView.isHidden = false
            }, completion: nil)
            UIView.transition(with: recordingTableView, duration: 0.7, options: .transitionCrossDissolve, animations: {
                //self.recordingCollectionView.isHidden = true
                self.recordingTableView.isHidden = false
                
            }, completion: nil)
        }
        else{
            UIView.transition(with: recordingCollectionView, duration: 0.7, options: .transitionCrossDissolve, animations: {
                self.recordingCollectionView.isHidden = false
                //self.recordingTableView.isHidden = true
            }, completion: nil)
            UIView.transition(with: recordingTableView, duration: 0.7, options: .transitionCrossDissolve, animations: {
                //self.recordingCollectionView.isHidden = false
                self.recordingTableView.isHidden = true
            }, completion: nil)
        }
        //isGridView = !isGridView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.transition(with: recordingTableView, duration: 0.7, options: .transitionCrossDissolve, animations: {
            self.filterOuterView.alpha = 0.0
            self.filterView.alpha = 0.0
            self.filterBtn = false
        }, completion: nil)
       
        
    }
    
    func toggleSortingView(){
        if sortingStackView.isHidden{
            UIView.animate(withDuration: 1.0) {
              self.sortingStackView.isHidden = false
            }
            UIView.transition(with: sortingStackView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 1.0) {
                self.sortingStackView.isHidden = true
            }
            UIView.transition(with: sortingStackView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                //self.sortingStackView.isHidden = true
            }, completion: nil)
        }
    }
}

//MARK:- TableView Delegate methods
extension RecordingsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! RecordingTVC
        cell.imageViewAlbumArt.image = #imageLiteral(resourceName: "1")
      //  cell.lblTrackTitle.text = "Recording \(indexPath.row + 1)"
        //self.nameArr.append("Recording \(indexPath.row + 1)")
        cell.lblTrackTitle.text = nameArr[indexPath.row]
        cell.lblTime.text = dateArr[indexPath.row]
        cell.lblTrackLength.text = "00:00"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       UIView.transition(with: cell, duration: 0.7, options: .transitionCrossDissolve, animations: {
            
        }, completion: nil)
       /* cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height/1.1)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
        }, completion: nil) */
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
//            print("edit")
//        }
//        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
//            print("delete")
//        }
//        return [edit, delete]
//    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            print("Edit clicked")
        }
        edit.backgroundColor = UIColor(red: 0/255, green: 116/255, blue: 28/255, alpha: 1.0)
        
        let config = UISwipeActionsConfiguration(actions: [edit])
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            print("Delete clicked")
        }
        delete.backgroundColor = UIColor(red: 155/255, green: 31/255, blue: 64/255, alpha: 1.0)
        let config = UISwipeActionsConfiguration(actions: [delete])
        return config
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

//MARK:- CollectionView Delegate methods
extension RecordingsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! RecordingCVC
        cell.imageViewAlbumArt.image = #imageLiteral(resourceName: "2")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        UIView.transition(with: cell, duration: 0.7, options: .transitionCrossDissolve, animations: {
            
        }, completion: nil)
        
   /*     cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height/1.1)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
        }, completion: nil) */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2.2
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
