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

/**
 * Fill Object from Dictionary [Key as proparty name or getter :and: Value as value of this proparty]
 *
 * @return Object filled from Dictionary
 */
-(id)FillThisObject:(id)object;
@end


#pragma mark - Type Encodings
// source = https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
#define  propertyTypeEncodingchar                   @"c"
#define  propertyTypeEncodingint                    @"i"
#define  propertyTypeEncodingshort                  @"s"
#define  propertyTypeEncodinglong                   @"l"
#define  propertyTypeEncodinglongLong               @"q"
#define  propertyTypeEncodingunsignedChar           @"C"
#define  propertyTypeEncodingunsignedInt            @"I"
#define  propertyTypeEncodingunsignedShort          @"S"
#define  propertyTypeEncodingunsignedLong           @"L"
#define  propertyTypeEncodingunsignedLongLong       @"Q"
#define  propertyTypeEncodingfloat                  @"f"
#define  propertyTypeEncodingdouble                 @"d"
#define  propertyTypeEncodingBool                   @"B"
#define  propertyTypeEncodingvoid                   @"v"
