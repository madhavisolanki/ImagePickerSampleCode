//
//  HomeCollectionViewCell.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 13/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import  UIKit
import RxSwift

class PhotoItemCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    var photo: Photo? = nil
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var selectionOverlay: UIView?
    @IBOutlet weak var checkImageView: UIImageView?
    @IBOutlet weak var heightConstraint: NSLayoutConstraint?
    @IBOutlet weak var messageTextView: UITextView?
    @IBOutlet weak var sharebutton: UIButton?

    func configurePhoto(photo: Photo) {
        self.imageView?.contentMode = .scaleAspectFill
        self.imageView?.image = photo.thumbnailImage
        self.photo = photo
    }
    
    func configureLargePhoto(photo: Photo) {
        self.photo = photo
        self.imageView?.image = photo.largeImage
        self.messageTextView?.text = photo.text
        if photo.text != nil {
            self.heightConstraint?.constant = 17 * round((self.messageTextView?.numberOfLines())!)
        }
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func setUpSelectionMode(){
        self.setSelection(isSelected: false)
    }
    func setupDeSelectionMode(){
        self.setSelection(isSelected: true)
    }
    
    internal func setSelection(isSelected:Bool){
        self.selectionOverlay?.isHidden = isSelected
        self.checkImageView?.isHidden = isSelected
    }
   
}
