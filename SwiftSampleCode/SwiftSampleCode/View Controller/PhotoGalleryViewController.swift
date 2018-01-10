//
//  PhotoGalleryViewController.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 14/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxOptional
import Photos

class PhotoGalleryViewController: UIViewController {
    
    //MARK: var
    @IBOutlet weak var collectionView: UICollectionView?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
     var photoViewModel: PhotoViewModel?
    
    //MARK view life cycle
    override func viewDidLoad() {
        self.collectionView?.allowsMultipleSelection = true
        self.collectionView?.selectItem(at: nil, animated: true, scrollPosition: UICollectionViewScrollPosition())
        self.photoViewModel?.setUpArrayFromLibrary { completion  in
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
            }
        }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        super.viewWillAppear(true)
    }
    
    func setUpNavigationBar() {
        let nav = self.navigationController?.navigationBar
        nav?.topItem?.title = "Select 2 picture"
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
    }
    
    //MARK: IBAction
    @IBAction func cancelClicked(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func doneClicked(sender: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.identifierPhotoGalleryDetailViewController) as! PhotoGalleryDetailViewController
        viewController.photoViewModel = self.photoViewModel
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension PhotoGalleryViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photoItemCollectionViewCell, for: indexPath) as! PhotoItemCollectionViewCell
        
        let photo = self.photoViewModel?.arrayPhotos.value[(indexPath as NSIndexPath).row]
        
        cell.configurePhoto(photo: photo!)

        if (self.photoViewModel?.isPhotoSelected(photo: photo!))!{
            cell.setUpSelectionMode()
        }else{
            cell.setupDeSelectionMode()
        }
        if self.photoViewModel?.selectedPhotos.value.count == 2{
            cell.isUserInteractionEnabled = false
        }else{
            cell.isUserInteractionEnabled = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoViewModel!.arrayPhotos.value.count
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegate {
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (collectionView.cellForItem(at: indexPath)
            as? PhotoItemCollectionViewCell) != nil else { return }
        let cell = self.collectionView?.cellForItem(at: indexPath) as? PhotoItemCollectionViewCell
        
        if self.photoViewModel?.selectedPhotos.value.count == 2{

        }else{
            let photo = self.photoViewModel?.arrayPhotos.value[(indexPath as NSIndexPath).row]
            self.photoViewModel?.selectedPhotos.value.append(photo!)
            cell?.setUpSelectionMode()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true

    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.collectionView?.cellForItem(at: indexPath) as? PhotoItemCollectionViewCell
        cell?.setupDeSelectionMode()
        let photo = self.photoViewModel?.arrayPhotos.value[(indexPath as NSIndexPath).row]
        self.photoViewModel?.removePhotoSelection(photo: photo!)
    }
   
}
