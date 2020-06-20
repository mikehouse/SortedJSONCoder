//
//  ViewController.m
//  DemoSortedJSONCoder
//

#import "ViewController.h"
#import <SortedJSONCoder/SortedJSONEncoder.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *d1 = @{
        @"1": @"",
        @"2": @"",
        @"10": @"",
        @"20": @""
    };

    SortedJSONEncoder *encoder = [SortedJSONEncoder new];

    NSData *jsonDataLiteralSort = [encoder encode:d1 options:NSLiteralSearch error:nil];
    NSString *jsonStringLiteralSort = [[NSString alloc] initWithData:jsonDataLiteralSort encoding:NSUTF8StringEncoding];
    NSLog(@"Literal sorted json:\n\t%@\n", jsonStringLiteralSort);
    NSAssert([jsonStringLiteralSort isEqualToString:@"{\"1\":\"\",\"10\":\"\",\"2\":\"\",\"20\":\"\"}"], @"");

    NSData *jsonDataNumericSort = [encoder encode:d1 options:NSNumericSearch error:nil];
    NSString *jsonStringNumericSort = [[NSString alloc] initWithData:jsonDataNumericSort encoding:NSUTF8StringEncoding];
    NSLog(@"Numeric sorted json:\n\t%@\n", jsonStringNumericSort);
    NSAssert([jsonStringNumericSort isEqualToString:@"{\"1\":\"\",\"2\":\"\",\"10\":\"\",\"20\":\"\"}"], @"");
}

- (void)writeJSON:(NSDictionary *)object toPath:(NSURL *)path {
    SortedJSONEncoder *encoder = [SortedJSONEncoder new];
    NSData *data = [encoder encode:object options:NSCaseInsensitiveSearch error:nil];
    [data writeToURL:path atomically:YES];
}

- (void)writeJSON2:(NSDictionary *)object toPath:(NSURL *)path {
    SortedJSONEncoder *encoder = [SortedJSONEncoder new];
    NSData *data = [encoder encode:object comparator:^NSComparisonResult(NSString *s1, NSString *s2) {
        return [s1 localizedCaseInsensitiveCompare:s2];
    } error:nil];
    [data writeToURL:path atomically:YES];
}

@end
