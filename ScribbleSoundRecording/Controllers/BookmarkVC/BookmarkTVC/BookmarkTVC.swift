//
//  BookmarkTVC.swift
//  ScribbleSoundRecording
//
//  Created by Dheeraj Chauhan on 05/10/18.
//  Copyright © 2018 Chanpreet Singh. All rights reserved.
//

import UIKit

class BookmarkTVC: UITableViewCell {
    
    @IBOutlet weak var imgSong: UIImageViewX!
    @IBOutlet weak var lblNameSong: UILabel!
    @IBOutlet weak var lblDescSong: UILabel!
    @IBOutlet weak var btnBookmark: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(modelObj:RecodingData){
        imgSong.image = UIImage(data: modelObj.image!)
        lblNameSong.text = modelObj.name
        lblDescSong.text = modelObj.note
    }

}
