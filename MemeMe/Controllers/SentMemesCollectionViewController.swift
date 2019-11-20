//
//  SentMemesCollectionViewControllerr.swift
//  MemeMe
//
//  Created by Philip on 11/19/19.
//  Copyright © 2019 Philip Khegay. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

private let sectionInsets = UIEdgeInsets(top: 60.0,
                                        left: 10.0,
                                        bottom: 60.0,
                                        right: 10.0)

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memeCollectionView!.reloadData()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! CollectionViewCell
        let meme = memes[indexPath.row]
        cellCollection.setMemeCollectionView(meme: meme)
    
        return cellCollection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (2 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let displayVC: MemeEditorViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MemeEditor") as! MemeEditorViewController
        
        displayVC.topTextString = memes[indexPath.row].topText
        displayVC.botTextString = memes[indexPath.row].botText
        displayVC.image = memes[indexPath.row].originalImage
        displayVC.editOrCreate = true
        
        show(displayVC, sender: self)
    }
    
    
}

