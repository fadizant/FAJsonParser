//
//  NSArray+FAArray.m
//  Gloocall
//
//  Created by Fadi on 30/12/15.
//  Copyright © 2015 Apprikot. All rights reserved.
//

#import "NSArray+FAArray.h"
#import "NSDictionary+FADictionary.h"
#import "NSObject+FAObject.h"
#import <objc/runtime.h>

@implementation NSArray (FAArray)

-(NSMutableArray*)dictionaryArray{
    return [self dictionaryArray:nil];
}

-(NSMutableArray*)dictionaryArray:(NSError**)error
{
    @try {
        
        NSMutableArray *object = [[NSMutableArray alloc]init];
        if (self.count) {
            
            
            for (int i = 0; i < self.count; i++) {
                @try {
                    id arg = [self objectAtIndex:i];
                    NSMutableDictionary *item = [[NSMutableDictionary alloc]init];
                    if(!arg)
                        continue;
                    
                    if ([arg isKindOfClass:[NSNumber class]]) {
                        NSNumber *someNSNumber = (NSNumber*)arg;
                        
                        CFNumberType numberType = CFNumberGetType((CFNumberRef)someNSNumber);
                        switch (numberType) {
                            case kCFNumberSInt8Type:
                            case kCFNumberSInt16Type:
                            case kCFNumberSInt32Type:
                            case kCFNumberSInt64Type:
                            case kCFNumberIntType:
                                [object addObject:[NSNumber numberWithInt:[arg intValue]]];
                                break;
                            case kCFNumberFloat32Type:
                            case kCFNumberFloat64Type:
                            case kCFNumberCGFloatType:
                            case kCFNumberFloatType:
                                [object addObject:[NSNumber numberWithFloat:[arg intValue]]];
                                break;
                            case kCFNumberDoubleType:
                                [object addObject:[NSNumber numberWithDouble:[arg intValue]]];
                                break;
                            case kCFNumberNSIntegerType:
                                [object addObject:[NSNumber numberWithInteger:[arg intValue]]];
                                break;
                            case kCFNumberCharType:
                                [object addObject:[NSNumber numberWithBool:[arg intValue]]];
                                break;
                            default:
                                [object addObject:[NSNumber numberWithInt:[arg intValue]]];
                                break;
                        }
                        
                    }
                    else if ([arg isKindOfClass:[NSString class]] ||
                             [arg isKindOfClass:[NSDate class]])
                    {
                        [object addObject:arg];
                    }
                    else
                    {
                        item = [arg Dictionary:&*error];
                        [object addObject:item];
                    }
                    
                    
                    
                }
                @catch (NSException *exception) {
                    *error = [NSError errorWithDomain:@"FADictionary" code:-101 userInfo:nil];
                }
                @finally {
                    
                }
            }
            
            
        }
        
        return object;
        
    }
    @catch (NSException *exception) {
        return [[NSMutableArray alloc]init];
    }
    @finally {
        
    }
}

-(NSMutableArray*)fillWithClass:(Class)class{
    return [self fillWithClass:class Error:nil];
}

-(NSMutableArray*)fillWithClass:(Class)class Error:(NSError**)error
{
    @try {
        NSMutableArray *object = [[NSMutableArray alloc]init];
        for (int i=0; i<self.count; i++) {
            id item = [self objectAtIndex:i];
            if([item isKindOfClass:[NSDictionary class]]){
                id newItem = [[class alloc]init];
                newItem = [((NSDictionary*)item) FillThisObject:newItem Error:error];
                [object addObject:newItem];
            }
            else
            {
                id newItem = [[class alloc]init];
                if ([newItem isKindOfClass:[NSNumber class]]) {
                    item = [item isEqual:[NSNull null]] || !item ? 0 : item;
                    
                    [object addObject:(NSNumber*)item];
                }
                else if ([newItem isKindOfClass:[NSString class]] ||
                         [newItem isKindOfClass:[NSDate class]])
                {
                    [object addObject:item];
                }
                else
                {
                    newItem = item;
                    [object addObject:newItem];
                }
            }
        }
        return object;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


//fix duplicate items
-(NSMutableArray*)addArrayWithoutDuplicateByProparty:(NSString*)propartyName Array:(NSMutableArray*)array Update:(BOOL)update{
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:self];
    for (id object in array) {
        @try {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %%@",propartyName] , [object valueForKey:propartyName]];
            NSArray *filteredArray = [mutableArray filteredArrayUsingPredicate:predicate];
            if (filteredArray.count) {
                //update array item if found
                if (update)
                    [mutableArray replaceObjectAtIndex:[self indexOfObject:filteredArray.firstObject] withObject:object];
            } else {
                //add item if not exist
                [mutableArray addObject:object];
            }
        } @catch (NSException *exception) {
            [mutableArray addObject:object];
        } @finally {
            
        }
        
    }
    return mutableArray;
}

@end
