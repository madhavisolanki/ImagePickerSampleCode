//
//  Constants.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 13/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let photoItemCollectionViewCell = "itemCell"
    static let  subHeaderFont: UIFont =  UIFont.boldSystemFont(ofSize: 13.0)
    static let  headerFont: UIFont = UIFont(name: "SFUIText-Light", size:17)!
    static let createProfileAddressViewHeight = 114
    static let iconAdd = "icon-add"
    static let identifierHomeNavigationController = "PhotoGalleryNavigationController"
    static let identifierFlickrNavigationController = "FlickrGalleryNavigationControlller"
    static let identifierPhotoGalleryDetailViewController = "PhotoGalleryDetailViewController"
    static let borderColorSkill: UIColor  = UIColor.black
    static let bnbPinkTint: UIColor  = hexStringToUIColor(hex: "#D21B58")
    static let bnbGrayColor: UIColor  = UIColor.lightGray
    static let numberOfStepsForCreateProfile: Int  = 4
    static let bnbRedColor: UIColor  = UIColor.red
    static let bnbGreenColor: UIColor  = UIColor.green
    static let bnbBlackColor: UIColor  = UIColor.black
}
