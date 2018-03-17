//
//  NSArray+FAArray.h
//
//  Created by Fadi on 30/12/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FAArray)

/**
 * Generate Dictionary Array from Objects element [Proparty name or Getter as Key :and: Proparty Value as value for this key]
 *
 * @param error return NSError if there is a problem
 *
 * @return NSMutableArray of dictionaries
 */
-(NSMutableArray*)dictionaryArray:(NSError**)error;

/**
 * Generate Dictionary Array from Objects element [Proparty name or Getter as Key :and: Proparty Value as value for this key]
 *
 * @return NSMutableArray of dictionaries
 */
-(NSMutableArray*)dictionaryArray;

/**
 * Fill Object Array from Dictionary Array With element Class [Key as proparty name or getter :and: Value as value of this proparty]
 *
 * @param class element Class
 * @param error return NSError if there is a problem
 *
 * @return Object Array filled from Dictionary Array
 */
-(NSMutableArray*)fillWithClass:(Class)class Error:(NSError**)error;

/**
 * Fill Object Array from Dictionary Array With element Class [Key as proparty name or getter :and: Value as value of this proparty]
 *
 * @param class element Class
 *
 * @return Object Array filled from Dictionary Array
 */
-(NSMutableArray*)fillWithClass:(Class)class;

/**
 * Matching element of array with unique key to stop duplicate objects in array
 *
 * @param propartyName unique key to match elements
 * @param array new array to import them to current array
 * @param update replace old element with new element if matched
 *
 * @return current array with new elements
 */
-(NSMutableArray*)addArrayWithoutDuplicateByProparty:(NSString*)propartyName Array:(NSMutableArray*)array Update:(BOOL)update;
@end
