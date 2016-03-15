//
//  ViewController.swift
//  10-Names to Faces with UICollectionView
//
//  Created by shiyuwudi on 16/3/15.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var people = [Person]()
    
    // MARK: - life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTapped")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tap methods
    
    func addTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: - image picker controller delegate
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        
//    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//   step1.     Extract the image from the dictionary that is passed as a parameter. (if/let, as?)
//   step2.     Generate a unique filename for it. (NSUUID)
//   step3.     Convert it to a JPEG, then write that JPEG to disk. (UIImageJPEGRepresentation, writeToFile, Documents)
//   step4.     Dismiss the view controller. (...)
        
        //step1.
        var newImage : UIImage
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = image
        } else if let image = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = image
        } else {
            return
        }
        
        //step2.
        let imageName = NSUUID().UUIDString
        let imagePath = NSHomeDirectory() + "/Documents/" + imageName
        
        //step3.
        guard let imageData = UIImageJPEGRepresentation(newImage, 0.8) else {
            return
        }
        imageData.writeToFile(imagePath, atomically: true)
        
        //step4.
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        print("user cancelled image picking!")
    }
    
    // MARK: - collection view data source

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Person", forIndexPath: indexPath) as! PersonCell
        let person = people[indexPath.row]
        cell.imageView.image = UIImage(named: person.image)
        cell.name.text = person.name
        return cell
    }
    
}

