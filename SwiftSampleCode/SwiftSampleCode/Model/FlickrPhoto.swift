//
//  Flickr.swift
//  SwiftSampleCode
//
//  Created by Madhavi Solanki on 14/06/17.
//  Copyright © 2017 Madhavi Solanki. All rights reserved.
//

import Foundation
import Mapper
import Moya_ModelMapper

class FlickrPhoto : Mappable {
    //optional
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?

    required init(map: Mapper) throws {
        id = map.optionalFrom("id")
        owner = map.optionalFrom("owner")
        secret = map.optionalFrom("secret")
        server = map.optionalFrom("server")
        farm = map.optionalFrom("farm")
        title = map.optionalFrom("title")
        ispublic = map.optionalFrom("ispublic")
        isfriend = map.optionalFrom("isfriend")
        isfamily = map.optionalFrom("isfamily")
    }

}
