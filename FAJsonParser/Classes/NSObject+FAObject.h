//
//  NSObject+FAObject.h
//  FARequest
//
//  Created by Fadi Abuzant on 2/25/18.
//

#import <Foundation/Foundation.h>

@interface NSObject (FAObject)

/**
 * Generate NSMutableDictionary from Object [Proparty name or Getter as Key :and: Proparty Value as value for this key]
 *
 * @param error return NSError if there is a problem
 *
 * @return NSMutableDictionary filled from Object
 */
-(NSMutableDictionary*)Dictionary:(NSError**)error;

/**
 * Generate NSMutableDictionary from Object [Proparty name or Getter as Key :and: Proparty Value as value for this key]
 *
 * @return NSMutableDictionary filled from Object
 */
-(NSMutableDictionary*)Dictionary;

@end
