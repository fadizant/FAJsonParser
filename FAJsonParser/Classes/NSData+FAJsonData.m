//
//  NSData+FAJsonData.m
//  FAJsonParser
//
//  Created by Fadi Abuzant on 4/13/18.
//

#import "NSData+FAJsonData.h"
#import "NSDictionary+FADictionary.h"
#import "NSArray+FAArray.h"

@implementation NSData (FAJsonData)

- (id)JSONWithError:(NSError**)error
{
    return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:error];
}

- (id)JSON
{
    return [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:nil];
}

-(id)FillThisObject:(id)object Error:(NSError**)error{
    id JSON = [self JSONWithError:error];
    if (*error)
        return nil;
    
    if (JSON && [JSON isKindOfClass:[NSDictionary class]])
        return [((NSDictionary*)JSON) FillThisObject:object Error:error];
    
    return nil;
}

-(id)FillThisObject:(id)object{
    id JSON = [self JSON];
    
    if (JSON && [JSON isKindOfClass:[NSDictionary class]])
        return [((NSDictionary*)JSON) FillThisObject:object];
    
    return nil;
}

-(NSMutableArray*)fillWithClass:(Class)class Error:(NSError**)error{
    id JSON = [self JSONWithError:error];
    if (*error)
        return nil;
    
    if (JSON && [JSON isKindOfClass:[NSArray class]])
        return [((NSArray*)JSON) fillWithClass:class Error:error];
    
    return nil;
}

-(NSMutableArray*)fillWithClass:(Class)class{
    id JSON = [self JSON];
    
    if (JSON && [JSON isKindOfClass:[NSArray class]])
        return [((NSArray*)JSON) fillWithClass:class];
    
    return nil;
}

@end
