//
//  HomeViewController.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 13/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import ImagePicker

let btnHeight:CGFloat = 40.0

class HomeViewController: UIViewController,UICollectionViewDelegateFlowLayout {
   
    //MARK var
    let disposeBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView?
    var photoAlert: UIAlertController?
    var imagePickerController:ImagePickerController? = nil
    var photoViewModel: PhotoViewModel = PhotoViewModel()
    
    //MARK view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.photoViewModel.araryPhotoStack.asObservable().bind(to: (collectionView?.rx.items)!) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photoItemCollectionViewCell, for: indexPath) as! PhotoItemCollectionViewCell
            let photo = self.photoViewModel.araryPhotoStack.value[(indexPath as NSIndexPath).row]
            cell.sharebutton?.tag = indexPath.row
            cell.sharebutton?.addTarget(self, action: #selector(self.doneClicked(sender:)), for: UIControlEvents.touchUpInside)
            cell.configureLargePhoto(photo: photo)
            return cell
            }.addDisposableTo(self.disposeBag)
       
            self.collectionView?.rx.setDelegate(self).addDisposableTo(self.disposeBag)
        
        //Adding observers to check state.
            self.photoViewModel.araryPhotoStack.asObservable().subscribe(onNext: { photos in
                if self.photoViewModel.araryPhotoStack.value.count == 0 {
                    self.addEmptyState()
                }else{
                    self.collectionView?.backgroundView = nil
                }
            }).addDisposableTo(self.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        self.collectionView?.reloadData()
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: custom methods
    func addEmptyState(){
        self.collectionView?.backgroundView = UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as? UIView
    }
    
    //MARK: navigation bar setting
    func setUpNavigationBar() {
        let nav = self.navigationController?.navigationBar
        nav?.topItem?.title = "Photo Gallery"
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: Constants.iconAdd), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: btnHeight, height: btnHeight)
        btn1.addTarget(self, action: #selector(optionClicked(sender:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.rightBarButtonItem = item1
    }
    
    func presentFlickerGallery() {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Constants.identifierFlickrNavigationController) as! FlickrGalleryNavigationControlller
        let flickViewController:FlickrPhotoGalleryViewController = navigationController.topViewController as! FlickrPhotoGalleryViewController
        flickViewController.photoViewModel = self.photoViewModel
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func presentPhotoGallery() {
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Constants.identifierHomeNavigationController) as! PhotoGalleryNavigationController
        let photoViewController:PhotoGalleryViewController = navigationController.topViewController as! PhotoGalleryViewController
        photoViewController.photoViewModel = self.photoViewModel
        self.present(navigationController, animated: true, completion: nil)
    }


    //MARK: collectionView flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = self.photoViewModel.araryPhotoStack.value[(indexPath as NSIndexPath).row]
        let height:CGFloat = self.photoViewModel.getHeightForText(photo: photo, width: (self.collectionView?.frame.size.width)!)
        let width = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
    
    //MARK: IBAction
    @IBAction func optionClicked(sender: UIButton) {
        self.setUpActionSheet()
    }
    
    @IBAction func doneClicked(sender: UIButton) {
        let photo: Photo = self.photoViewModel.araryPhotoStack.value[sender.tag]
        let url = photo.url
        if url == nil {
            let alert =    UIAlertController.init(title: "Sorry", message: "This picture dont have public url to share. Try flickr images.", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out this cool picture.", url ?? "https://farm5.staticflickr.com/4217/34947676140_08ee67cdd4_m.jpg"],
            applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
  
    //MARK: Action sheet
    func setUpActionSheet() {
        self.imagePickerController = nil
        self.photoAlert = nil
        self.photoAlert  = UIAlertController()
        self.imagePickerController = ImagePickerController()
        self.imagePickerController?.delegate = self
        self.imagePickerController?.imageLimit = 10
        
        self.photoAlert?.addAction(UIAlertAction(title: "Camera", style: .destructive, handler: { (action: UIAlertAction!) in
            self.present(self.imagePickerController!, animated: true, completion: nil)
        }))
        
        self.photoAlert?.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action: UIAlertAction!) in            
                self.presentPhotoGallery()
        }))
        
        self.photoAlert?.addAction(UIAlertAction(title: "Import from Flickr", style: .default, handler: { (action: UIAlertAction!) in
                self.presentFlickerGallery()
        }))
        
        self.photoAlert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(self.photoAlert!, animated: true, completion: nil)
    }
    
}
extension HomeViewController: ImagePickerDelegate, UINavigationControllerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) {
            self.photoViewModel.addNewPhoto(images: images, completion: { isCompleted in
                if isCompleted {
                    self.collectionView?.reloadData()
                }
            })
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true) {
        }
    }
    
}
