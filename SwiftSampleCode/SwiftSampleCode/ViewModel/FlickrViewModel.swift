//
//  FlickrViewModel.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 14/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional


class FlickrViewModel {
    
    let arrayFlickrPhoto: Variable<[FlickrPhoto]> = Variable([])
    let arrayPhoto: Variable<[Photo]> = Variable([])
    let selectedPhotos: Variable<[Photo]> = Variable([])
    fileprivate let disposeBag = DisposeBag()
    let provider = BNBServiceProvider.ShareExtensionProvider()

    func getExpertslist(completion: @escaping (Bool) -> Void){
        self.provider.request(FlickrAPI.getFlickrPhoto()).observeOn(MainScheduler.instance).map { response -> Response in
            let responseDict = try? response.mapJSON() as! NSDictionary
            if let mainKey:Any = responseDict?.value(forKey: "photos"){
                if let photosKey: Any =  (mainKey as AnyObject).value(forKey: "photo"){
                    let  newData = try? JSONSerialization.data(withJSONObject: photosKey, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let newResponse = Response(statusCode: response.statusCode, data: newData!, response: response.response)
                    return newResponse
                }else{
                    return response
                }
            }
            return response
        }
            .mapArray(type: FlickrPhoto.self)
            .subscribe(onNext: ({ photos  -> Void in
                self.arrayFlickrPhoto.value = photos
                self.setUpImage(completion: { isComplete in
                    completion(isComplete)
                })
            }), onError: ({ error -> Void  in
                if let errorResponse = error as? Moya.MoyaError {
                    if errorResponse.response?.statusCode != 200{
                        let string = errorResponse.readErrorDescription()
                        print(string)
                        completion(false)
                    }
                }
            })).addDisposableTo(disposeBag)
        
    }
    
    func setUpImage(completion: @escaping (Bool) -> Void) {
        for var flickphoto in self.arrayFlickrPhoto.value {
            if let url = URL(string: "https://farm\(flickphoto.farm ?? 5).staticflickr.com/\(flickphoto.server ?? "4217")/\(flickphoto.id ?? "34947676140")_\(flickphoto.secret ?? "08ee67cdd4")_m.jpg" ){
                if let data = try? Data(contentsOf: url){
                    let photo: Photo = Photo()
                    photo.thumbnailImage = UIImage(data: data)
                    photo.url = url as NSURL
                    photo.largeImage = photo.thumbnailImage
                    self.arrayPhoto.value.append(photo)
                }
            }
        }
        completion(true)
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

}
