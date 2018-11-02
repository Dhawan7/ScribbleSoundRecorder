//
//  RecordingsVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 17/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingsVC: BaseVC, UISearchBarDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var btnListView: UIButton!
    @IBOutlet weak var btnGridView: UIButton!
    @IBOutlet weak var recordingCollectionView: UICollectionView!
    @IBOutlet weak var recordingTableView: UITableView!
    @IBOutlet weak var sortingStackView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterOuterView: UIView!
    @IBOutlet weak var searchRecording: UISearchBar!
    
    
    @IBOutlet var swipeGesture: UISwipeGestureRecognizer!
    
    //MARK:- Vars,Lets
    var isGridView:Bool!
    var numArr:[Int] = [Int]()
    var filterBtn:Bool = false
    var isAssending:Bool = false
    var recordingData:[RecodingData] = [RecodingData]()
    var recordingDataStore:[RecodingData] = [RecodingData]()
    var dateStringArr:[String] = [String]()
    var nameArr:[String] = [String]()
    var isFromSerch:Bool = false
    var objectData = ""
    var audioURLPath: URL!
    var audioPlayer:AVAudioPlayer!
    var isSizeSort:Bool = false
    var trackTotalTime:Float = 5.0

    
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
        searchRecording.delegate = self
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        filterOuterView.alpha = 0.0
        filterView.alpha = 0.0
        filterBtn = false
        getRecorderData()
      
        }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    func dateFormat(){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MM, yyyy"
    }
    
    func dateToString(newDateArr:[Date]){
      //  dateArr.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM, yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        for dateToStore in newDateArr{
            let dateStr = dateFormatter.string(from: dateToStore)
            dateStringArr.append(dateStr)
        }
    }
    
    func getRecorderData(){
        dateFormat()
        recordingData = RecodingData.share.getData()
        if isFromSerch{
            recordingData = recordingData.filter{$0.objectName! == objectData}
        } else{
            recordingDataStore = recordingData
        }
        dateToString(newDateArr: recordingData.map{($0.date! as Date)})
        recordingTableView.reloadData()
        recordingCollectionView.reloadData()
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterUsers(searchString: searchText)
        self.reloadTableCollectionView()
    }
    
    func filterUsers(searchString:String){
        if searchString.isEmpty{
            recordingData = recordingDataStore
        }
        else{
            self.recordingData = recordingData.filter({ (user) -> Bool in
                if (user.name?.lowercased().contains(searchString.lowercased()))!{
                    
                    return true
                }
                else{
                    return false
                }
            })
        }
    }
    
    func reloadTableCollectionView(){
        self.recordingTableView.reloadData()
        self.recordingCollectionView.reloadData()
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
        }, completion: nil)
        UIView.transition(with: recordingTableView, duration: 0.7, options: .transitionCrossDissolve, animations: {
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
        dateStringArr.removeAll()
        if isAssending{
            let valueAscending = recordingData.sorted(by: { $0.date?.compare($1.date!) == .orderedAscending})
            dateToString(newDateArr: valueAscending.map{$0.date!})
            isAssending = false
        } else{
         let valueDesending = recordingData.sorted(by: { $0.date?.compare($1.date!) == .orderedDescending})
            dateToString(newDateArr: valueDesending.map{$0.date!})
            isAssending = true
        }
       
            self.reloadTableCollectionView()
            self.filterOuterView.alpha = 0.0
       
    }

    @IBAction func btnSortByName(_ sender: UIButton) {
            nameArr.removeAll()
            nameArr = recordingData.map{$0.name!}
        if isAssending{
            recordingData.sort{ $0.name ?? "record" <  $1.name ?? "record1" }
            isAssending = false
            
        } else{
            recordingData.sort{$0.name ?? "record1" > $1.name ?? "record"}
            isAssending = true
        }
        self.filterOuterView.alpha = 0.0
        self.reloadTableCollectionView()
    }
    
    @IBAction func btnSortBySize(_ sender: UIButton) {
        if isSizeSort{
            recordingData.sort{$0.audioSize < $1.audioSize}
            isSizeSort = false
        } else{
            recordingData.sort{$0.audioSize > $1.audioSize}
            isSizeSort = true
        }
        
        self.filterOuterView.alpha = 0.0
        self.reloadTableCollectionView()
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
        return recordingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! RecordingTVC
        if !(recordingData[indexPath.row].url == nil){
            cell.setRecordingData(modelObj: recordingData[indexPath.row])
            cell.lblTrackTitle.text = recordingData[indexPath.row].name
            cell.lblTime.text = dateStringArr[indexPath.row]
            cell.imageViewAlbumArt.image = UIImage(data: recordingData[indexPath.row].image! as Data)
            let path = getDirectory().appendingPathComponent("\(recordingData[indexPath.row].name!).m4a")
            do{
                let stringUrl = "\(path)"
                getSize(fileSize: Int64(path.fileSize))
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                hmsFrom(seconds: Int(audioPlayer.duration.rounded())) { (hours, min, sec) in
                    // let hours = self.getStringFrom(seconds: hours)
                    let min = self.getStringFrom(seconds: min)
                    let sec = self.getStringFrom(seconds: sec)
                    cell.lblTrackLength.text = "\(min): \(sec)"
                    self.trackTotalTime = Float(sec) ?? 5.0
                    
                }
            } catch{
                
            }
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       UIView.transition(with: cell, duration: 0.7, options: .transitionCrossDissolve, animations: {
            
        }, completion: nil)
      
    }
    

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NoImageTrimVC") as! NoImageTrimVC
            vc.isFromBrowse = false
            vc.audioLength = self.trackTotalTime
            vc.browseData = self.recordingData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        edit.backgroundColor = UIColor(red: 0/255, green: 116/255, blue: 28/255, alpha: 1.0)
        
        let config = UISwipeActionsConfiguration(actions: [edit])
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let audioName = self.recordingData[indexPath.row].name!
            let context = CoreDataStack.sharedInstance.getContext()
            context.delete(self.recordingData[indexPath.row])
            self.deleteRecordingFile(audioName: "\(audioName).m4a")
            do {
                try context.save()
                self.recordingData = RecodingData.share.getData()
                self.reloadTableCollectionView()
            } catch {
                print("error : \(error)")
            }
        }
        delete.backgroundColor = UIColor(red: 155/255, green: 31/255, blue: 64/255, alpha: 1.0)
        let config = UISwipeActionsConfiguration(actions: [delete])
        
        return config
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        vc.currentRecordingData = recordingData[indexPath.row]
        vc.currentAudioIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

//MARK:- CollectionView Delegate methods
extension RecordingsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recordingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! RecordingCVC
        if (recordingData[indexPath.row].name != nil) {
            cell.imageViewAlbumArt.image = UIImage(data: recordingData[indexPath.row].image!)
            cell.lblDate.text = dateStringArr[indexPath.row]
            cell.lblAlbumTrackTitle.text = recordingData[indexPath.row].name
            let path = getDirectory().appendingPathComponent("\(recordingData[indexPath.row].name!).m4a")
            do{
                let stringUrl = "\(path)"
                getSize(fileSize: Int64(path.fileSize))
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                hmsFrom(seconds: Int(audioPlayer.duration.rounded())) { (hours, min, sec) in
                    // let hours = self.getStringFrom(seconds: hours)
                    let min = self.getStringFrom(seconds: min)
                    let sec = self.getStringFrom(seconds: sec)
                    cell.lblTrackLength.text = "\(min): \(sec)"
                    self.trackTotalTime = Float(sec) ?? 5.0
                    
                }
            } catch{
                
            }
        }
       
      //  cell.lblTrackLength.text = "00:00"
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
        vc.currentRecordingData = recordingData[indexPath.row]
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

extension Data {
    var uiImage: UIImage? {
        return UIImage(data: self)
    }
}


