//
//  NSObject+FAObject.m
//  FARequest
//
//  Created by Fadi Abuzant on 2/25/18.
//

#import "NSObject+FAObject.h"
#import "NSDictionary+FADictionary.h"
#import "NSArray+FAArray.h"
#import <objc/runtime.h>

@implementation NSObject (FAObject)

-(NSMutableDictionary*)Dictionary{
    return [self Dictionary:nil];
}

-(NSMutableDictionary*)Dictionary:(NSError**)error
{
    NSMutableDictionary *returnValue = [[NSMutableDictionary alloc]init];
    @try {
        
        //get properties and values from object
        unsigned int propertyCount = 0;
        objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
        
        NSDictionary * info = [self getObjectInfoWithProperties:properties propertyCount:propertyCount];
        
        NSMutableArray * propertyNames = [info objectForKey:@"propertyNames"];
        NSMutableArray * propertyTypes = [info objectForKey:@"propertyTypes"];
        NSMutableArray * propertyGetters = [info objectForKey:@"propertyGetters"];
        NSMutableArray * propertySetters = [info objectForKey:@"propertySetters"];
        
        free(properties);
        
        //get properties and values from super class of object
        Class superClass = [self superclass];
        while (superClass != [NSObject class]) {
            
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList(superClass, &propertyCount);
            
            NSDictionary * info = [self getObjectInfoWithProperties:properties propertyCount:propertyCount];
            
            [propertyNames addObjectsFromArray:[info objectForKey:@"propertyNames"]];
            [propertyTypes addObjectsFromArray:[info objectForKey:@"propertyTypes"]];
            [propertyGetters addObjectsFromArray:[info objectForKey:@"propertyGetters"]];
            [propertySetters addObjectsFromArray:[info objectForKey:@"propertySetters"]];
            
            free(properties);
            
            
            superClass = [superClass superclass];
        }
        
        NSMutableArray * propertyValues = [[NSMutableArray alloc]init];
        for (NSString* prop in propertyNames)
            if([self valueForKey:prop] && ![[self valueForKey:prop] isEqual:[NSNull null]])
                [propertyValues addObject:[self valueForKey:prop]];
            else
                [propertyValues addObject:@""];
        
        
        for (int i = 0; i < propertyNames.count; i++) {
            @try {
                id arg = [propertyValues objectAtIndex:i];
                
                if(!arg)
                    continue;
                
                NSString *name = [propertyNames objectAtIndex:i];
                NSString *getter = [propertyGetters objectAtIndex:i];
                
                if (![getter isEqualToString:@""]) {
                    name = getter;
                }
                
                //for Swift
                if ([name componentsSeparatedByString:@"$"].count == 2 &&
                    ![[[name componentsSeparatedByString:@"$"][0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] isEqualToString:@""] &&
                    ![[[name componentsSeparatedByString:@"$"][1] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] isEqualToString:@""] ){
                    name = [[name componentsSeparatedByString:@"$"][0] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
                }
                
                if ([arg isKindOfClass:[NSNumber class]]) {
                    NSNumber *someNSNumber = (NSNumber*)arg;
                    
                    CFNumberType numberType = CFNumberGetType((CFNumberRef)someNSNumber);
                    switch (numberType) {
                        case kCFNumberSInt8Type:
                        case kCFNumberSInt16Type:
                        case kCFNumberIntType:
                            [returnValue setObject:[NSNumber numberWithInt:[arg intValue]] forKey:name];
                            break;
                        case kCFNumberFloat32Type:
                        case kCFNumberFloat64Type:
                        case kCFNumberCGFloatType:
                        case kCFNumberFloatType:
                            [returnValue setObject:[NSNumber numberWithFloat:[arg floatValue]] forKey:name];
                            break;
                        case kCFNumberDoubleType:
                            [returnValue setObject:[NSNumber numberWithDouble:[arg doubleValue]] forKey:name];
                            break;
                        case kCFNumberNSIntegerType:
                            [returnValue setObject:[NSNumber numberWithInteger:[arg integerValue]] forKey:name];
                            break;
                        case kCFNumberLongType:
                        case kCFNumberSInt32Type:
                            [returnValue setObject:[NSNumber numberWithLong:[arg longValue]] forKey:name];
                            break;
                        case kCFNumberLongLongType:
                        case kCFNumberSInt64Type:
                            [returnValue setObject:[NSNumber numberWithLongLong:[arg longLongValue]] forKey:name];
                            break;
                        case kCFNumberCharType:
                            [returnValue setObject:[NSNumber numberWithBool:[arg boolValue]] forKey:name];
                            break;
                        default:
                            [returnValue setObject:[NSNumber numberWithInt:[arg intValue]] forKey:name];
                            break;
                    }
                    
                }
                else if ([arg isKindOfClass:[NSArray class]] || [arg isKindOfClass:[NSMutableArray class]])
                {
                    [returnValue setObject:[arg dictionaryArray:&*error] forKey:name];
                }
                else if ([arg isKindOfClass:[NSString class]] ||
                         [arg isKindOfClass:[NSDate class]] ||
                         [arg isKindOfClass:[NSData class]] ||
                         [arg isKindOfClass:[NSDictionary class]] ||
                         [arg isKindOfClass:[NSMutableDictionary class]])
                    [returnValue setObject:arg forKey:name];
                else
                {
                    NSMutableDictionary *object = [arg Dictionary:&*error];
                    [returnValue setObject:object forKey:name];
                }
                
                
            }
            @catch (NSException *exception) {
                if(error != NULL)
                    *error = [NSError errorWithDomain:@"FADictionary" code:-101 userInfo:exception.userInfo];
            }
            @finally {
                
            }
        }
        
        
    }
    @catch (NSException *exception) {
        if(error != NULL)
            *error = [NSError errorWithDomain:@"FADictionary" code:-100 userInfo:exception.userInfo];
    }
    @finally {
        
    }
    
    return returnValue;
}

-(NSDictionary*)getObjectInfoWithProperties:(objc_property_t *)properties propertyCount:(int) propertyCount
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

-(BOOL)SaveWithKey:(NSString*)key{
    NSError *error;
    NSDictionary * dic = [self Dictionary:&error];
    if (error) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

-(BOOL)LoadWithKey:(NSString*)key{
    NSError *error;
    NSMutableDictionary *dic = [[[NSUserDefaults standardUserDefaults] objectForKey:key] mutableCopy];
    [dic FillThisObject:self Error:&error];
    if (error) {
        return NO;
    } else {
        return YES;
    }
}
@end
