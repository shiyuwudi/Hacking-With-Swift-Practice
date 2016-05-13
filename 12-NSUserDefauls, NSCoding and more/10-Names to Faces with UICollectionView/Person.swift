//
//  Person.swift
//  10-Names to Faces with UICollectionView
//
//  Created by shiyuwudi on 16/3/15.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit

class Person: NSObject {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(image, forKey: "image")
    }
    
    // NS_DESIGNATED_INITIALIZER
    required init(coder aDecoder: NSCoder){
        name = aDecoder.decodeObjectForKey("name") as! String
        image = aDecoder.decodeObjectForKey("image") as! String
    }
}
