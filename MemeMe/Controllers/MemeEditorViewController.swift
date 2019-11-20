//
//  ViewController.swift
//  MemeMe
//
//  Created by Philip on 11/8/19.
//  Copyright © 2019 Philip Khegay. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var topTextString: String!
    var botTextString: String!
    var image: UIImage!
    
    var editOrCreate: Bool! = false
    
    var imagePickerCamera = UIImagePickerController()
    var imagePickerAlbum = UIImagePickerController()
    var back = SentMemesTableViewController()
    
    var activeTextField: UITextField!
        
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 6.0,
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editOrCreate == true {
            configureTextField(topTextField, text: topTextString)
            configureTextField(bottomTextField, text: botTextString)
            imageView.image = image
            shareButton.isEnabled = true

        } else {
            setupUI()
            shareButton.isEnabled = false
        }

}
    
    
    func setupUI() {
        imagePickerCamera.delegate = self
        imagePickerAlbum.delegate = self
        configureTextField(topTextField, text: "TOP")
        configureTextField(bottomTextField, text: "BOTTOM")
    }
    
    func configureTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.delegate = self
        textField.borderStyle = .none
        textField.defaultTextAttributes = [
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: 6
        ]
        textField.textAlignment = .center
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if activeTextField == bottomTextField {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if activeTextField == bottomTextField {
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    @IBAction func onPhotoClick(_ sender: Any) {
        imagePickerCamera.sourceType = .camera
        present(imagePickerCamera, animated: true, completion: nil)
    }
    
    @IBAction func onAlbumClick(_ sender: Any) {
        imagePickerAlbum.sourceType = .photoLibrary
        present(imagePickerAlbum, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        } else {
            print("error")
        }
        dismiss(animated: true, completion: nil)
    }

    var currentTextTop: String = ""
    var currentTextBottom: String = ""
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        if activeTextField == topTextField {
            textField.text = currentTextTop
        } else {
            textField.text = currentTextBottom
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text != nil {
            if activeTextField == topTextField {
                self.currentTextTop = textField.text!
            } else {
                self.currentTextBottom = textField.text!
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, botText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())

        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        shareButton.isHidden = true
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        shareButton.isHidden = false
        toolBar.isHidden = false

        return memedImage
    }
    
    @IBAction func onShareClick(_ sender: Any) {
        let memedImage = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        vc.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
        }
        present(vc, animated: true)
    }
}
