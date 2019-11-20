//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Philip on 11/15/19.
//  Copyright © 2019 Philip Khegay. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    var sendImage: UIImageView!
    
    var sendTopText: String!
    var sendBotText: String!
    var image: UIImage!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table?.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table?.delegate = self
        table?.dataSource = self
    }
}


extension SentMemesTableViewController: UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let displayVC: MemeEditorViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MemeEditor") as! MemeEditorViewController
        
        displayVC.topTextString = memes[indexPath.row].topText
        displayVC.botTextString = memes[indexPath.row].botText
        displayVC.image = memes[indexPath.row].originalImage
        displayVC.editOrCreate = true
        
        show(displayVC, sender: self)
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.setMeme(meme: meme)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}
