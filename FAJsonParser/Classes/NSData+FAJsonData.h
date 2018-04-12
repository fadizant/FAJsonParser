//
//  NSData+FAJsonData.h
//  FAJsonParser
//
//  Created by Fadi Abuzant on 4/13/18.
//

#import <Foundation/Foundation.h>

@interface NSData (FAJsonData)

/**
 * try to generate JSON
 *
 * @param error return NSError if there is a problem
 *
 * @return JSON
 */
- (id)JSONWithError:(NSError**)error;

/**
 * try to generate JSON
 *
 * @return JSON
 */
- (id)JSON;

/**
 * Get JSON and Try to Fill Object from Dictionary [Key as proparty name or getter :and: Value as value of this proparty]
 *
 * @param error return NSError if there is a problem
 *
 * @return Object filled from Dictionary
 */
-(id)FillThisObject:(id)object Error:(NSError**)error;

/**
 * Get JSON and Try to Fill Object from Dictionary [Key as proparty name or getter :and: Value as value of this proparty]
 *
 * @return Object filled from Dictionary
 */
-(id)FillThisObject:(id)object;

/**
 * Get JSON and Try to Fill Object Array from Dictionary Array With element Class [Key as proparty name or getter :and: Value as value of this proparty]
 *
 * @param class element Class
 * @param error return NSError if there is a problem
 *
 * @return Object Array filled from Dictionary Array
 */
-(NSMutableArray*)fillWithClass:(Class)class Error:(NSError**)error;

/**
 * Get JSON and Try to Fill Object Array from Dictionary Array With element Class [Key as proparty name or getter :and: Value as value of this proparty]
 *
 * @param class element Class
 *
 * @return Object Array filled from Dictionary Array
 */
-(NSMutableArray*)fillWithClass:(Class)class;
@end
