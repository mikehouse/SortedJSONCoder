//
//  SortedJSONEncoder.h
//  SortedJSONCoder
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortedJSONEncoder : NSObject

@property (readwrite, nonatomic, assign) BOOL pretty;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

///
/// @param jsonObject - dictionary to be converted to JSON.
/// @param options - sort options in which dictionary will be written to JSON.
/// @param error - encoding error.
/// @return - Data json representation.
///
- (NSData *_Nullable)encode:(NSDictionary *)jsonObject
                    options:(NSStringCompareOptions)options
                      error:(NSError *_Nullable *_Nullable)error;

///
/// @param jsonObject - dictionary to be converted to JSON.
/// @param comparator - custom sorting logic in which dictionary will be written to JSON.
/// @param error - encoding error.
/// @return - Data json representation.
///
- (NSData *_Nullable)encode:(NSDictionary *)jsonObject
                 comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator
                      error:(NSError *_Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
