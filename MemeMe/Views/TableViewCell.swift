//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Philip on 11/17/19.
//  Copyright © 2019 Philip Khegay. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
        
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var memedImage: UIImageView!
    
    func setMeme(meme: Meme) {
        memedImage.clipsToBounds = true
        memedImage.contentMode = .center
        memedImage.contentMode = .scaleAspectFill
        memedImage.image = meme.memedImage
        label.text! = "\(meme.topText!) \(meme.botText!)"
    }
    
}
