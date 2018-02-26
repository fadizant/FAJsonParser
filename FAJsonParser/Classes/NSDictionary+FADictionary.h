//
//  NSDictionary+FADictionary.h
//
//  Created by Fadi on 19/11/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FADictionary)

/**
 * Fill Object from Dictionary [Key as proparty name or getter :and: Value as value of this proparty]
 *
 * @param error return NSError if there is a problem
 *
 * @return Object filled from Dictionary
 */
-(id)FillThisObject:(id)object Error:(NSError**)error;

@end
