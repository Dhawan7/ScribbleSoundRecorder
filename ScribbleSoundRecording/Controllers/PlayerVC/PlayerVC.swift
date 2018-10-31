//
//  PlayerVC.swift
//  ScribbleSoundRecording
//
//  Created by Chanpreet Singh on 21/09/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerVC: BaseVC, AVAudioPlayerDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var collectionViewPlaylist: UICollectionView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblTotalTrackTime: UILabel!
    @IBOutlet weak var lblCurrentAudioTime: UILabel!
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var btnAddBookmark: UIButton!
    @IBOutlet weak var imgMusicPlayer: UIImageView!
    @IBOutlet weak var lblAudioTitle: UILabel!
    @IBOutlet weak var btnBookmarkO: UIButtonX!
    
    
    
    //Mark: let, var
    var audioPlayer: AVAudioPlayer!
    var currentTrackIndex = 0
    var track:[String] = ["test2.mp3", "test1.mp3", "test2.mp3", "test1.mp3"]
    var progressDisplayLink : CADisplayLink! = nil
    var audioLength:Float = 0.0
    var messagePlaybackTimer: CADisplayLink?
    var isBookmark:Bool = false
    var isFromSearch:Bool = false
    var recordingData:[RecodingData] = [RecodingData]()
    var recordingAudioURlString:[String] = [String]()
    var isPlaying:Bool = false
    var audioIndex:Int = 0
    var currentRecordingData:RecodingData!
    var recordingIndex:[Int]!
    var currentAudioIndex:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //audioIndex = Int(currentRecordingData.audioIndex)
      
     
        collectionViewPlaylist.delegate = self
        collectionViewPlaylist.dataSource = self
        
        //audioPlayer.delegate = self
        lblAudioTitle.text = currentRecordingData.name ?? "Recording"
        lblNotes.text = currentRecordingData.note ?? "Notes"
      //  audioPlayerRecord()
    }
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        progressBar.progress = 0.0
        
        if  isFromSearch{
            self.btnBookmarkO.isHidden = true
       
        } else{
            recordingData = RecodingData.share.getData()
            self.btnBookmarkO.isHidden = false
        }
        track = recordingData.map{$0.name!}
        player(songIndex: track[currentAudioIndex ?? 1])
        
        messagePlaybackTimer?.isPaused = true
        if currentRecordingData.bookmarkAudio == true{
            btnAddBookmark.setImage(#imageLiteral(resourceName: "Bookmark Green"), for: .normal)
        } else{
            btnAddBookmark.setImage(#imageLiteral(resourceName: "Bookmark Grey"), for: .normal)
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        messagePlaybackTimer?.isPaused = true
        if audioPlayer != nil{
            audioPlayer.stop()
        }
        self.messagePlaybackTimer?.isPaused = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCellsLayout()
    }
    
   
    
    
    func audioPlayerRecord(){

        let paths = getDirectory().appendingPathComponent("\(currentRecordingData.audioIndex).m4a")
        do{
            
            audioPlayer = try AVAudioPlayer(contentsOf: paths)
            audioPlayer.prepareToPlay()
            showTotalAudioTime()
            showTimeProgress()
            marqueLabel()
            showProgress()
            
            
        } catch{
            print(error)
        }

    }
    
    func player(songIndex: String){
        self.messagePlaybackTimer?.isPaused = true
         let paths = getDirectory().appendingPathComponent("\(songIndex).m4a")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: paths)
            audioLength = Float(audioPlayer.duration)
            self.lblTotalTrackTime.text = String(audioLength.rounded())
            messagePlaybackTimer = CADisplayLink(target: self, selector: #selector(PlayerVC.messagePlaybackTimerFired))
            messagePlaybackTimer?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
            audioPlayer.enableRate = true
            showTotalAudioTime()
            showProgress()
        } catch{
            
        }
        
    }
    
    
    @objc func messagePlaybackTimerFired(){
        print(audioPlayer.currentTime)
        hmsFrom(seconds: Int(audioPlayer.currentTime.rounded())) { (hours, mins, secs) in
          //  let hour = self.getStringFrom(seconds: hours)
            let min = self.getStringFrom(seconds: mins)
            let sec = self.getStringFrom(seconds: secs)
            self.lblCurrentAudioTime.text = "\(min):\(sec)/"
        }
        
        
    }
    
  
    
    @IBAction func btnSpeedMinus(_ sender: UIButton) {
        if audioPlayer.rate < 2.0{
            audioPlayer.rate += 0.5
        }
    }
    
    @IBAction func btnSpeedPlus(_ sender: UIButton) {
        if audioPlayer.rate > 0.5{
            audioPlayer.rate -= 0.5
        }
    }
    
    func showTimeProgress(){
        messagePlaybackTimer = CADisplayLink(target: self, selector: #selector(PlayerVC.messagePlaybackTimerFired))
        messagePlaybackTimer?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        audioPlayer.enableRate = true
    }
    
    func showTotalAudioTime(){
        hmsFrom(seconds: Int(audioPlayer.duration.rounded())) { (hour, min, sec) in
            //let hours = self.getStringFrom(seconds: hour)
            let mins = self.getStringFrom(seconds: min)
            let secs = self.getStringFrom(seconds: sec)
            self.lblTotalTrackTime.text = "\(mins):\(secs)"
        }
    }
    
    func showProgress(){
        progressDisplayLink = CADisplayLink(target: self, selector: #selector(PlayerVC.trackAudio))
        progressDisplayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func marqueLabel(){
        UIView.animate(withDuration: 12.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {() -> Void in
            self.lblNotes.center = CGPoint(x: 0 - self.lblNotes.bounds.size.width / 2, y: self.lblNotes.center.y)
        }, completion:  { _ in })
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Did finish play")
         messagePlaybackTimer = nil
        btnPlay.setImage(#imageLiteral(resourceName: "pause-icon-color"), for: .normal)
        audioPlayer.stop()
        
    }
    
    @IBAction func btnPreviousAudio(_ sender: UIButton) {
        if currentAudioIndex > 0 {
            currentAudioIndex = (currentAudioIndex - 1)
            player(songIndex: track[currentAudioIndex])
            
            scrollToNextCell(isNext: false)
            self.btnPlay.setImage(#imageLiteral(resourceName: "pause-icon-color"), for: .normal)
            audioPlayer.play()
        } else{
            
        }
    }
    
    @IBAction func btnPlayAudio(_ sender: UIButton) {
        if audioPlayer.isPlaying{
            messagePlaybackTimer?.isPaused = true
            audioPlayer.pause()
            btnPlay.setImage(#imageLiteral(resourceName: "paly-right-color"), for: .normal)
            
        } else{
            messagePlaybackTimer?.isPaused = false
            audioPlayer.play()
            btnPlay.setImage(#imageLiteral(resourceName: "pause-icon-color"), for: .normal)
        }
        
        
    }
    
    @IBAction func btnNextAudio(_ sender: UIButton) {
        if (currentAudioIndex < track.count - 1) {
            currentAudioIndex = (currentAudioIndex + 1)
            player(songIndex: track[currentAudioIndex])
            scrollToNextCell(isNext: true)
            self.btnPlay.setImage(#imageLiteral(resourceName: "pause-icon-color"), for: .normal)
            audioPlayer.enableRate = true
            audioPlayer.play()
            
        }
     
    }
    
   
    
    func scrollToNextCell(isNext:Bool){
        
        //get cell size
        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        //get current content Offset of the Collection view
        let contentOffset = collectionViewPlaylist.contentOffset
        
        //scroll to next cell
        if isNext{
        collectionViewPlaylist.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        } else{
            collectionViewPlaylist.scrollRectToVisible(CGRect(x: contentOffset.x - cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
        }
        
    }
    
    
    func updateCellsLayout()  {
        
        let centerX = collectionViewPlaylist.contentOffset.x + (collectionViewPlaylist.frame.size.width)/2
        
        for cell in collectionViewPlaylist.visibleCells {
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX *= -1
            }
            cell.transform = CGAffineTransform.identity
            let offsetPercentage = offsetX / (view.bounds.width * 2.7)
            let scaleX = 1-offsetPercentage
            cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellsLayout()
    }
    

    
    @IBAction func btnShare(_ sender: UIButton) {
        let shareText = ["This is the test popup string"]
        let popup = UIActivityViewController(activityItems: shareText, applicationActivities: nil)
        present(popup, animated: true, completion: nil)
    }
    
    @IBAction func btnBookmarks(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            let vc =  UINavigationController.init(rootViewController: self.storyboard?.instantiateViewController(withIdentifier: "BookmarkVC") as! BookmarkVC)
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnAddBookmark(_ sender: UIButton) {
        if isBookmark{
            btnAddBookmark.setImage(#imageLiteral(resourceName: "Bookmark Grey"), for: .normal)
            currentRecordingData.bookmarkAudio = false
            isBookmark = false
        } else{
            btnAddBookmark.setImage(#imageLiteral(resourceName: "Bookmark Green"), for: .normal)
            isBookmark = true
            currentRecordingData.bookmarkAudio = true
        }
    }
    
    
    
    @objc func trackAudio() {
        let normalizedTime = Float(audioPlayer.currentTime / audioPlayer.duration)
        progressBar.progress = normalizedTime
    }

}

extension PlayerVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return track.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewPlaylist.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as! PlayerCVC
        cell.imgPlay.image = UIImage(data: currentRecordingData.image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        collectionView.center = collectionViewPlaylist.center
        cellSize.width = UIScreen.main.bounds.width
        cellSize.height =  collectionViewPlaylist.bounds.height
//        cellSize.width -= collectionViewPlaylist.contentInset.left * 1.8
//        cellSize.width -= collectionViewPlaylist.contentInset.right * 1.8
       // cellSize.width = UIScreen.main.bounds.width
   //     cellSize.height = cellSize.width
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if collectionViewPlaylist.panGestureRecognizer.translation(in: collectionViewPlaylist.superview).x > 0{
            print("Left")
            btnPreviousAudio(.init())
        } else{
            print("Right")
            btnNextAudio(.init())
        }
        
    }
    

       
    
}
