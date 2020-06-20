//
//  SortedJSONEncoder.m
//  SortedJSONCoder
//

#import "SortedJSONEncoder.h"
#import <M13OrderedDictionary/M13OrderedDictionary.h>
#import "M13OrderedDictionary+DeepDictionaryInitializer.h"
#import "CJSONSerializer.h"

@interface SortedJSONEncoder ()

@end

@implementation SortedJSONEncoder

- (instancetype)init {
    self = [super init];
    return self;
}

- (NSData *)encode:(NSDictionary *)jsonObject
           options:(NSStringCompareOptions)options
             error:(NSError **)error {
    M13OrderedDictionary *ordered = [M13OrderedDictionary
        deepOrderedDictionaryWithDictionary:jsonObject options:options];
    CJSONSerializer *serializer = [CJSONSerializer serializer];
    return [serializer serializeObject:ordered error:error];
}

- (NSData *)encode:(NSDictionary *)jsonObject
        comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator
             error:(NSError **)error {
    M13OrderedDictionary *ordered = [M13OrderedDictionary
        deepOrderedDictionaryWithDictionary:jsonObject comparator:comparator];
    CJSONSerializer *serializer = [CJSONSerializer serializer];
    return [serializer serializeObject:ordered error:error];
}

@end
