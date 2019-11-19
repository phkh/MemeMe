//
//  CollectionViewCell.swift
//  MemeMe
//
//  Created by Philip on 11/18/19.
//  Copyright © 2019 Philip Khegay. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {    
     @IBOutlet weak var memedImage: UIImageView!
    
    func setMemeCollectionView(meme: Meme) {
        memedImage.image = meme.memedImage
    }
    
}
