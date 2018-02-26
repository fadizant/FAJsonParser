//
//  NSDictionary+FADictionary.m
//  MyKolumn
//
//  Created by Fadi on 19/11/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import "NSDictionary+FADictionary.h"
#import "NSArray+FAArray.h"
//#import "NSDate+FADate.h"
#import <objc/runtime.h>

@implementation NSDictionary (FADictionary)

-(id)FillThisObject:(id)object Error:(NSError**)error
{
    @try {
        // check if class is nil
        if (!object)
        return object;
        //fix keys in dictionary
        NSMutableDictionary *fixedDictionary = [self fixKeyNames];
        
        //get properties and values from object
        unsigned int propertyCount = 0;
        objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
        
        NSDictionary * info = [NSDictionary getObjectInfoWithProperties:properties propertyCount:propertyCount];
        
        NSMutableArray * propertyNames = [info objectForKey:@"propertyNames"];
        NSMutableArray * propertyTypes = [info objectForKey:@"propertyTypes"];
        NSMutableArray * propertyGetters = [info objectForKey:@"propertyGetters"];
        NSMutableArray * propertySetters = [info objectForKey:@"propertySetters"];
        
        free(properties);
        
        //get properties and values from super class of object
        Class superClass = [object superclass];
        while (superClass != [NSObject class]) {
            
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList(superClass, &propertyCount);
            
            NSDictionary * info = [NSDictionary getObjectInfoWithProperties:properties propertyCount:propertyCount];
            
            [propertyNames addObjectsFromArray:[info objectForKey:@"propertyNames"]];
            [propertyTypes addObjectsFromArray:[info objectForKey:@"propertyTypes"]];
            [propertyGetters addObjectsFromArray:[info objectForKey:@"propertyGetters"]];
            [propertySetters addObjectsFromArray:[info objectForKey:@"propertySetters"]];
            
            free(properties);
            
            
            superClass = [superClass superclass];
        }
        
        NSString *errorName = @"";
        for (int i = 0; i < propertyNames.count; i++) {
            @try {
                NSString *propertyName = [propertyNames objectAtIndex:i];
                NSString *propertyType = [propertyTypes objectAtIndex:i];
                NSString *propertyGetter = [propertyGetters objectAtIndex:i];
                NSString *propertySetter = [propertySetters objectAtIndex:i];
                
                errorName = propertyName ? propertyName : propertySetter;
                
                id value;
                if ([self objectForKey:propertyGetter])
                    value = [self objectForKey:propertyGetter];
                else if([self objectForKey:propertyName])
                    value = [self objectForKey:propertyName];
                else if([fixedDictionary objectForKey:propertyGetter])
                    value = [fixedDictionary objectForKey:propertyGetter];
                else if([fixedDictionary objectForKey:propertyName])
                    value = [fixedDictionary objectForKey:propertyName];
                //for Swift 
                else if ([propertyName componentsSeparatedByString:@"$"].count == 2 &&
                         ![[[propertyName componentsSeparatedByString:@"$"][0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] isEqualToString:@""] &&
                         ![[[propertyName componentsSeparatedByString:@"$"][1] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] isEqualToString:@""] ){
                    value = [self objectForKey:[[propertyName componentsSeparatedByString:@"$"][0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]];
                    propertySetter = [[propertyName componentsSeparatedByString:@"$"][1] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
                }
                else
                    continue;
                
                
                if ([value isEqual:[NSNull null]])
                    continue;
                
                if ([value isKindOfClass:[NSArray class]] ||
                    [value isKindOfClass:[NSMutableArray class]]
                    ) {
                    
                    if (NSClassFromString(propertySetter))
                    {
                        NSMutableArray *contant = [[NSMutableArray alloc]init];
                        contant = [value fillWithClass:[NSClassFromString(propertySetter) class] Error:&*error];
                        [object setValue:contant forKey:propertyName];
                    }else if (NSClassFromString(propertyName)){
                        NSMutableArray *contant = [[NSMutableArray alloc]init];
                        contant = [value fillWithClass:[NSClassFromString(propertyName) class] Error:&*error];
                        [object setValue:contant forKey:propertyName];
                    }else {
                        NSLog(@"Please add elemant class name in setter in NSMutableArray properte to know what class to parse this array");
                        continue;
                    }
                    
                }
                else if ([value isKindOfClass:[NSNumber class]]) {
                    value = [value isEqual:[NSNull null]] || !value ? 0 : value;
                    
                    [object setValue:(NSNumber*)value forKey:propertyName];
                }
                else if ([propertyType isEqualToString:@"NSString"] ||
                         [propertyType isEqualToString:@"NSDate"])
                {
                    [object setValue:value forKey:propertyName];
                }
                else
                {
                    id element = [[NSClassFromString(propertyType) alloc] init];
                    id obj = [self valueForKey:propertyName];
                    if ([obj isEqual:[NSNull null]])
                        continue;
                    
                    if (!element)
                    {
                        *error = [NSError errorWithDomain:errorName code:-404 userInfo:@{@"Error":[NSString stringWithFormat:@"Class not found %@",propertyType]}];
                        continue;
                    }
                    
                    id item = [obj FillThisObject:element Error:&*error];
                    
                    [object setValue:item forKey:propertyName];
                }
                
                
            }
            @catch (NSException *exception) {
                if(error != NULL)
                {
                    *error = [NSError errorWithDomain:errorName code:-101 userInfo:exception.userInfo];
                }
            }
            @finally {
                
            }
        }
        return object;
    }
    @catch (NSException *exception) {
        if(error != NULL)
            *error = [NSError errorWithDomain:@"FADictionary" code:-100 userInfo:exception.userInfo];
        return nil;
    }
    @finally {
        
    }
}

+(NSDictionary*)getObjectInfoWithProperties:(objc_property_t *)properties propertyCount:(int) propertyCount
{
    NSMutableDictionary *Info = [[NSMutableDictionary alloc]init];
    @try {
        NSMutableArray * propertyNames = [NSMutableArray array];
        NSMutableArray * propertyTypes = [NSMutableArray array];
        NSMutableArray * propertyGetters = [NSMutableArray array];
        NSMutableArray * propertySetters = [NSMutableArray array];
        
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            NSString * name = [NSString stringWithUTF8String:property_getName(property)];
            //const char * type = property_getAttributes(property);
            NSString * typeName = [[[NSString stringWithUTF8String:property_copyAttributeValue( property, "T" )] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString * getterName = property_copyAttributeValue( property, "G" ) ?[NSString stringWithUTF8String:property_copyAttributeValue( property, "G" )] : @"";
            NSString * setterName = property_copyAttributeValue( property, "S" ) ? [[NSString stringWithUTF8String:property_copyAttributeValue( property, "S" )] stringByReplacingOccurrencesOfString:@":" withString:@""]: @"";
            
            //set values
            [propertyNames addObject:name];
            [propertyTypes addObject:typeName];
            [propertyGetters addObject:getterName];
            [propertySetters addObject:setterName];
            
        }
        
        [Info setObject:propertyNames forKey:@"propertyNames"];
        [Info setObject:propertyTypes forKey:@"propertyTypes"];
        [Info setObject:propertyGetters forKey:@"propertyGetters"];
        [Info setObject:propertySetters forKey:@"propertySetters"];
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    } @finally {
        
    }
    return Info;
}

-(NSString*)fixKeyName:(NSString*)key
{
    //    NSString *unfilteredString = @"!@#$%^&*()_+|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"] invertedSet];
    return [[key componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
}

-(NSMutableDictionary*)fixKeyNames
{
    NSMutableDictionary *result = [NSMutableDictionary new];
    for (NSString *key in self.allKeys)
        [result setObject:[self objectForKey:key] forKey:[self fixKeyName:key]];
    return result;
}

@end
