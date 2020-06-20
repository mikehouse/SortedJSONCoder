//
//  M13OrderedDictionary+DeepDictionaryInitializer.h
//  SortedJSONCoder
//

#import <M13OrderedDictionary/M13OrderedDictionary.h>

NS_ASSUME_NONNULL_BEGIN

@interface M13OrderedDictionary (DeepDictionaryInitializer)

+ (instancetype)deepOrderedDictionaryWithDictionary:(NSDictionary *)dictionary
                                            options:(NSStringCompareOptions)options;

+ (instancetype)deepOrderedDictionaryWithDictionary:(NSDictionary *)dictionary
                                         comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator;

@end

NS_ASSUME_NONNULL_END
