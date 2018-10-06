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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
