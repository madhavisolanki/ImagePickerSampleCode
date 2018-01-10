//
//  FlickrPhotoGalleryViewController.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 16/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional
import MBProgressHUD

class FlickrPhotoGalleryViewController: UIViewController {
    
    //MARK: var
    @IBOutlet weak var collectionView: UICollectionView?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var flickrViewModel: FlickrViewModel = FlickrViewModel()
    var photoViewModel: PhotoViewModel? = nil

    //MARK: view life cycle
    override func viewDidLoad() {
        self.collectionView?.allowsMultipleSelection = true
        self.collectionView?.selectItem(at: nil, animated: true, scrollPosition: UICollectionViewScrollPosition())
        
        //This process is time consuming so added progress view.
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.flickrViewModel.getExpertslist { completion  in
            if completion {
                self.collectionView?.reloadData()
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
                layout.itemSize = CGSize(width: (self.collectionView?.bounds.size.width)!/4, height: (self.collectionView?.bounds.size.width)!/4)
                layout.headerReferenceSize  = CGSize.zero
                layout.sectionInset = self.sectionInsets
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                self.collectionView!.collectionViewLayout = layout
            } else{
                print("Something went wrong")
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        super.viewWillAppear(true)
    }
    
    //MARK: cutom method
    func setUpNavigationBar() {
        let nav = self.navigationController?.navigationBar
        nav?.topItem?.title = "Select 2 Flickr Photos"
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
    }
    
    //MARK: IBAction
    @IBAction func cancelClicked(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneClicked(sender: UIButton) {
        self.photoViewModel?.araryPhotoStack.value.append(contentsOf: self.flickrViewModel.selectedPhotos.value)
        self.photoViewModel?.selectedPhotos.value.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
}

extension FlickrPhotoGalleryViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photoItemCollectionViewCell, for: indexPath) as! PhotoItemCollectionViewCell
        
        let photo = self.flickrViewModel.arrayPhoto.value[(indexPath as NSIndexPath).row]
        
        cell.configurePhoto(photo: photo)
        
        if (self.flickrViewModel.isPhotoSelected(photo: photo)){
            cell.setUpSelectionMode()
        }else{
            cell.setupDeSelectionMode()
        }
        if self.flickrViewModel.selectedPhotos.value.count == 2{
            cell.isUserInteractionEnabled = false
        }else{
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.flickrViewModel.arrayPhoto.value.count
    }
}

extension FlickrPhotoGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (collectionView.cellForItem(at: indexPath)
            as? PhotoItemCollectionViewCell) != nil else { return }
        let cell = self.collectionView?.cellForItem(at: indexPath) as? PhotoItemCollectionViewCell
        if self.flickrViewModel.selectedPhotos.value.count == 2{
        }else{
            let photo = self.flickrViewModel.arrayPhoto.value[(indexPath as NSIndexPath).row]
            self.flickrViewModel.selectedPhotos.value.append(photo)
            cell?.setUpSelectionMode()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.collectionView?.cellForItem(at: indexPath) as? PhotoItemCollectionViewCell
        cell?.setupDeSelectionMode()
        let photo = self.flickrViewModel.arrayPhoto.value[(indexPath as NSIndexPath).row]
        self.flickrViewModel.removePhotoSelection(photo: photo)
    }
    
}
