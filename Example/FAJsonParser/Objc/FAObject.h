//
//  FAObject.h
//  FAJsonParser_Example
//
//  Created by Fadi Abuzant on 2/25/18.
//  Copyright © 2018 fadizant. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Entity,IndicySuper,Hashtag,Url,User,UserEntity,UserUrl;

@interface FAObject : NSObject
@property (nonatomic,retain,getter=created_at) NSString *createdAt;

@property (nonatomic,getter=id) long ID;
@property (nonatomic,retain) NSString *id_str;
@property (nonatomic,retain) NSString *text;
@property (nonatomic) BOOL truncated;
@property (nonatomic,retain) Entity *entities;
@property (nonatomic,retain) NSString *source;
@property (nonatomic,retain) User *user;
@end

@interface Entity : NSObject
@property (nonatomic,retain,setter=Hashtag:) NSArray *hashtags;
@property (nonatomic,retain,setter=Url:) NSArray *urls;
@end

@interface IndicySuper : NSObject
@property (nonatomic,retain,setter=NSNumber:) NSArray *indices;
@end

@interface Hashtag : IndicySuper
@property (nonatomic,retain) NSString *text;
@end

@interface Url : IndicySuper
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *expanded_url;
@property (nonatomic,retain) NSString *display_url;
@end

@interface User : NSObject
@property (nonatomic,getter=id) long ID;
@property (nonatomic,retain) NSString *id_str;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *screen_name;
@property (nonatomic,retain) NSString *location;
@property (nonatomic,retain,getter=description) NSString *Description;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) UserEntity *entities;
@property (nonatomic,getter=protected) BOOL protecte;
@property (nonatomic) int followers_count;
@property (nonatomic) int friends_count;
@property (nonatomic) int listed_count;
@property (nonatomic,retain) NSString *created_at;
@property (nonatomic) int favourites_count;
@property (nonatomic) int utc_offset;
@property (nonatomic,retain) NSString *time_zone;
@end

@interface UserEntity : NSObject
@property (nonatomic,retain) UserUrl *url;
@property (nonatomic,retain,getter=description) UserUrl *Description;
@end

@interface UserUrl : NSObject
@property (nonatomic,retain,setter=Url:) NSArray *urls;
@end
