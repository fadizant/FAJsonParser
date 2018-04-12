//
//  FAObject_Swift.swift
//  FAJsonParser_Example
//
//  Created by Fadi Abuzant on 2/26/18.
//  Copyright © 2018 fadizant. All rights reserved.
//

import UIKit

@objc (FAObject_Swift) class FAObject_Swift: NSObject {

    @objc (created_at)
    var createdAt = ""
    
    @objc (id)
    var ID = 0
    
    @objc var id_str = ""
    @objc var text = ""
    @objc var truncated = false
    @objc var entities = Entity_Swift()
    @objc var source = ""
    @objc var user = User_Swift()
    
}

@objc (Entity_Swift) class Entity_Swift:NSObject {
    
    @objc (hashtags$Hashtag_Swift)
    var hashtags = Array<Hashtag_Swift>()
    
    @objc (urls$Url_Swift)
    var urls = Array<Url_Swift>()
    
}

@objc (IndicySuper_Swift) class IndicySuper_Swift:NSObject {
    @objc (indices$NSNumber)
    var indices = Array<Int>()
}

@objc (Hashtag_Swift) class Hashtag_Swift:IndicySuper_Swift {
    @objc var text = ""
}

@objc (Url_Swift) class Url_Swift:IndicySuper_Swift {
    @objc var url = ""
    @objc var expanded_url = ""
    @objc var display_url = ""
}

@objc (User_Swift) class User_Swift:NSObject {
    @objc (id)
    var ID = 0
    
    @objc var id_str = ""
    @objc var name = ""
    @objc var screen_name = ""
    @objc var location = ""
    
    @objc (description$Description)
    var Description = ""
    
    @objc var url = ""
    @objc var entities = UserEntity_Swift()
    @objc var protected = false
    @objc var followers_count = 0
    @objc var friends_count = 0
    @objc var listed_count = 0
    @objc var created_at = ""
    @objc var favourites_count = 0
    @objc var utc_offset = 0
    @objc var time_zone = ""
}

@objc (UserEntity_Swift) class UserEntity_Swift:NSObject {
    @objc var url = UserUrl_Swift()
    @objc (description$Description)
    var Description = UserUrl_Swift()
}

@objc (UserUrl_Swift) class UserUrl_Swift:NSObject {
    @objc (urls$Url_Swift)
    var urls = Array<Url_Swift>()
}


