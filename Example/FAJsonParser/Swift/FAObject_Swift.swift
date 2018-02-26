//
//  FAObject_Swift.swift
//  FAJsonParser_Example
//
//  Created by Fadi Abuzant on 2/26/18.
//  Copyright © 2018 fadizant. All rights reserved.
//

import UIKit

@objc class FAObject_Swift: NSObject {

    @objc (created_at)
    var createdAt = ""
    
    @objc (id)
    var ID = 0
    
    @objc var id_str = ""
    @objc var text = ""
    @objc var truncated = false
    @objc var entities = Entity()
    @objc var source = ""
    @objc var user = User()
    
}

@objc class Entity:NSObject {
    
    @objc (hashtags$Hashtag)
    var hashtags = Array<Hashtag>()
    
    @objc (urls$Url)
    var urls = Array<Url>()
    
}

@objc class IndicySuper:NSObject {
    @objc (indices$NSNumber)
    var indices = Array<Int>()
}

@objc class Hashtag:IndicySuper {
    @objc var text = ""
}

@objc class Url:IndicySuper {
    @objc var url = ""
    @objc var expanded_url = ""
    @objc var display_url = ""
}

@objc class User:NSObject {
    @objc (id)
    var ID = 0
    
    @objc var id_str = ""
    @objc var name = ""
    @objc var screen_name = ""
    @objc var location = ""
    
    @objc (description$Description)
    var Description = ""
    
    @objc var url = ""
    @objc var entities = UserEntity()
    @objc var protected = false
    @objc var followers_count = 0
    @objc var friends_count = 0
    @objc var listed_count = 0
    @objc var created_at = ""
    @objc var favourites_count = 0
    @objc var utc_offset = 0
    @objc var time_zone = ""
}

@objc class UserEntity:NSObject {
    @objc var url = UserUrl()
    @objc (description$Description)
    var Description = UserUrl()
}

@objc class UserUrl:NSObject {
    @objc (urls$Url)
    var urls = Array<Url>()
}


