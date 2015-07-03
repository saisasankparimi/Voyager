//
//  CollectionViewTableCell.swift
//  Voyager
//
//  Created by Sai Sasank Parimi on 6/14/15.
//  Copyright (c) 2015 Sasank. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewTableCell :UICollectionViewCell {
    
    @IBOutlet weak var locationDistanceLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var cssView: UIView!
    @IBOutlet weak var animationView: UIImageView!
    
    var latitude : String?
    var longitude : String?
    
}