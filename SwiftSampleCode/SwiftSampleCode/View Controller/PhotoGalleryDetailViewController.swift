//
//  PhotoGalleryDetailViewController.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 14/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import UIKit

class PhotoGalleryDetailViewController: UIViewController {
    
    //MARK: var
    @IBOutlet weak var displayScrollView: UIScrollView?
    @IBOutlet weak var thumbnailScrollView: UIScrollView?
    @IBOutlet weak var addMoreButton: UIButton?
    var photoViewModel: PhotoViewModel? = nil

    //MARK: view life cycle
    override func viewDidLoad() {
        self.displayScrollView?.bounces = false
        self.displayScrollView?.delegate = self
        self.displayScrollView?.isPagingEnabled = true
        self.displayScrollView?.showsVerticalScrollIndicator = false
        self.displayScrollView?.showsHorizontalScrollIndicator = false
       
        self.photoViewModel?.getlargeImage(completion: { isComplete in
            if isComplete {
                self.setupMainScrollView()
            }
        })
        self.setupMainScrollView()
        super.viewDidLoad()
    }
    
    //MARK: custom methods
    func setupMainScrollView(){
        var xAxis:CGFloat = 0
        for photo in (self.photoViewModel?.selectedPhotos.value)! {
            let photoView: PhotoDetailView = PhotoDetailView.instanceFromNib() as! PhotoDetailView
            photoView.frame = CGRect(x:xAxis, y: 0, width: (self.displayScrollView?.frame.size.width)!, height: ((self.displayScrollView?.frame.size.height)! - 40))
            photoView.setUpImage(photo: photo)
            xAxis = xAxis + (self.displayScrollView?.frame.size.width)!
            self.displayScrollView?.contentSize = CGSize(width: xAxis, height: (self.displayScrollView?.frame.size.height)!)
            self.displayScrollView?.addSubview(photoView)
        }
    }
    
    //MARK: IBAction
    @IBAction func cancelClicked(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(sender: UIButton) {
        self.photoViewModel?.araryPhotoStack.value.append(contentsOf:  (self.photoViewModel?.selectedPhotos.value)!)
        self.photoViewModel?.selectedPhotos.value.removeAll()
        self.dismiss(animated: true, completion: nil)
    }

}

extension PhotoGalleryDetailViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
}
