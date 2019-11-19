//
//  SentMemesCollectionViewControllerr.swift
//  MemeMe
//
//  Created by Philip on 11/19/19.
//  Copyright © 2019 Philip Khegay. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memeCollectionView!.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(memes.count)
        return memes.count

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! CollectionViewCell
        let meme = memes[indexPath.row]
        
        cellCollection.setMemeCollectionView(meme: meme)
    
        return cellCollection
    }

}
