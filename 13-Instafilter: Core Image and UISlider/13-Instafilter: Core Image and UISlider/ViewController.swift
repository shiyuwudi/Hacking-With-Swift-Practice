//
//  ViewController.swift
//  13-Instafilter: Core Image and UISlider
//
//  Created by shiyuwudi on 16/5/13.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    //state
    var currentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "又一个图片滤镜app"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(importPicture))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //导入图片
    func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        currentImage = newImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        
    }
    
    @IBAction func changeFilter(sender: AnyObject) {
        
    }

    @IBAction func intensityChanged(sender: AnyObject) {
        
    }

}

