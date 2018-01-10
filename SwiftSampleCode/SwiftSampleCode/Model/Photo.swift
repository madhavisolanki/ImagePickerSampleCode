//
//  Photo.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 14/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import UIKit
import Photos

class Photo {
    var thumbnailImage: UIImage?
    var largeImage: UIImage?
    var text:String?
    var isSelected: Bool = false
    var identifier = 0
    var assest:PHAsset?
    var url: NSURL?
    init() {
        
    }
}
