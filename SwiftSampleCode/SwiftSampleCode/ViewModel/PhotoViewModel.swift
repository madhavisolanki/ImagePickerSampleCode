//
//  PhotoViewModel.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 14/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxOptional
import ImagePicker
import Photos

class PhotoViewModel {
    let selectedPhotos: Variable<[Photo]> = Variable([])
    let arrayPhotos: Variable<[Photo]> = Variable([])
    let araryPhotoStack: Variable<[Photo]> = Variable([])

    init() {
        
    }
    
    //Currently fetching only 100 images, User might have more than 1000 images which can add lot of load on app. We can add pagination as well.
    func setUpArrayFromLibrary(completion: @escaping (Bool) -> Void) {
        self.selectedPhotos.value.removeAll()
        if arrayPhotos.value.count == 0 {
            AssetManager.fetch { assets in
                var i = 0
                for asset in assets {
                    let photo:Photo = Photo()
                    photo.thumbnailImage = self.getAssetThumbnail(asset: asset, size: CGSize(width: 100, height: 100))
                    photo.assest = asset
                    photo.identifier = i
                    self.arrayPhotos.value.append(photo)
                    i += 1
                    if i == 100{
                        break
                    }
                }
                completion(true)
            }
        }
        completion(true)
    }
    
    //Sometimes there is error fetching large size image, Added default flower image
    func getAssetThumbnail(asset: PHAsset, size:CGSize) -> UIImage? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            if result == nil{
                thumbnail =  UIImage(named:"flower-27")!
            }else{
                thumbnail = result!
            }
        })
        return thumbnail
    }
    
    func isPhotoSelected(photo:Photo) -> Bool {
        if self.selectedPhotos.value.index(where: { $0.identifier == photo.identifier }) != nil {
            return true
        }else{
            return false
        }
    }
    
    func removePhotoSelection(photo: Photo) {
        if let i = self.selectedPhotos.value.index(where: { $0.identifier ==  photo.identifier }) {
            self.selectedPhotos.value.remove(at: i)
        }
    }
    
    func getlargeImage(completion: @escaping (Bool) -> Void) {
        for photo in self.selectedPhotos.value {
            photo.largeImage =  self.getAssetThumbnail(asset: photo.assest!, size: CGSize(width: 300, height: 500))
        }
        completion(true)
    }
    
    func getHeightForText(photo:Photo, width: CGFloat) -> CGFloat{
        if photo.text == nil {
            return width/1.5
        }else{
            return width/1.5 + (photo.text?.height(withConstrainedWidth: width, font: Constants.subHeaderFont))!
        }
    }
    
    func addNewPhoto(images: [UIImage], completion: @escaping (Bool) -> Void) {
        for image in images{
            let photo: Photo = Photo()
            photo.thumbnailImage = image
            photo.largeImage = image
            self.araryPhotoStack.value.append(photo)
        }
        completion(true)
    }
}

