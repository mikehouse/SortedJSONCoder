//
//  M13OrderedDictionary+DeepDictionaryInitializer.m
//  SortedJSONCoder
//

#import <Foundation/Foundation.h>
#import <M13OrderedDictionary/M13OrderedDictionary.h>
#import "M13OrderedDictionary+DeepDictionaryInitializer.h"

@implementation M13OrderedDictionary (DeepDictionaryInitializer)

#pragma mark - Public

+ (instancetype)deepOrderedDictionaryWithDictionary:(NSDictionary *)dictionary
                                            options:(NSStringCompareOptions)options {
    return [M13OrderedDictionary deepOrderedDictionaryWithDictionary:dictionary
                                                          comparator:^NSComparisonResult(NSString *s1, NSString *s2) {
                                                              return [s1 compare:s2 options:options];
                                                          }];
}

+ (instancetype)deepOrderedDictionaryWithDictionary:(NSDictionary *)dictionary
                                         comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator {
    M13MutableOrderedDictionary *unordered = [M13MutableOrderedDictionary new];
    for (id <NSCopying> key in [dictionary allKeys]) {
        NSObject *value = dictionary[key];
        if ([value isKindOfClass:NSDictionary.class]) {
            NSDictionary *dict = (NSDictionary *) value;
            M13OrderedDictionary *update = [M13OrderedDictionary deepOrderedDictionaryWithDictionary:dict comparator:comparator];
            [unordered addObject:update pairedWithKey:key];
        } else if ([value isKindOfClass:NSArray.class]) {
            NSArray *array = (NSArray *) value;
            NSArray *update = [M13OrderedDictionary deepOrderedDictionaryWithArray:array comparator:comparator];
            [unordered addObject:update pairedWithKey:key];
        } else {
            [unordered addObject:value pairedWithKey:key];
        }
    }

    return [unordered sortedByKeysUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return comparator(obj1, obj2);
    }];
}

#pragma mark - Private

+ (NSArray *)deepOrderedDictionaryWithArray:(NSArray *)array
                                    options:(NSStringCompareOptions)options {
    if (array.count != 0) {
        NSObject *object = array.firstObject;
        if ([object isKindOfClass:NSDictionary.class]) {
            NSMutableArray *mArray = [NSMutableArray new];
            for (NSDictionary *element in array) {
                [mArray addObject:[M13OrderedDictionary
                    deepOrderedDictionaryWithDictionary:element options:options]];
            }
            return mArray;
        } else if ([object isKindOfClass:NSArray.class]) {
            NSMutableArray *mArray = [NSMutableArray new];
            for (NSArray *element in array) {
                NSArray *update = [M13OrderedDictionary deepOrderedDictionaryWithArray:element options:options];
                [mArray addObject:update];
            }
            return mArray;
        } else {
            return array;
        }
    }

    return array;
}

+ (NSArray *)deepOrderedDictionaryWithArray:(NSArray *)array
                                 comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator {
    if (array.count != 0) {
        NSObject *object = array.firstObject;
        if ([object isKindOfClass:NSDictionary.class]) {
            NSMutableArray *mArray = [NSMutableArray new];
            for (NSDictionary *element in array) {
                [mArray addObject:[M13OrderedDictionary
                    deepOrderedDictionaryWithDictionary:element comparator:comparator]];
            }
            return mArray;
        } else if ([object isKindOfClass:NSArray.class]) {
            NSMutableArray *mArray = [NSMutableArray new];
            for (NSArray *element in array) {
                NSArray *update = [M13OrderedDictionary deepOrderedDictionaryWithArray:element comparator:comparator];
                [mArray addObject:update];
            }
            return mArray;
        } else {
            return array;
        }
    }

    return array;
}

@end
