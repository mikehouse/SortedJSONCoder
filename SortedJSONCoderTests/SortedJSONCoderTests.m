//
//  SortedJSONCoderTests.m
//  SortedJSONCoderTests
//

#import <XCTest/XCTest.h>
#import <SortedJSONCoder/SortedJSONCoder.h>

@interface SortedJSONCoderTests : XCTestCase

@end

@implementation SortedJSONCoderTests

- (void)testLiteralSort {
    NSDictionary *target = @{
        @"sessionInfo": @{
            @"quarantineInfo": @[],
            @"quarantinedItems": @(0)
        }};
    SortedJSONEncoder *jsonEncoder = [SortedJSONEncoder new];
    NSError *error = NULL;
    NSData *data = [jsonEncoder encode:target options:NSLiteralSearch error:&error];

    XCTAssertNil(error);

    NSString *expected = @"{\"sessionInfo\":{\"quarantineInfo\":[],\"quarantinedItems\":0}}";
    NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    XCTAssertEqualObjects(actual, expected);
}

- (void)testCaseInsensitiveSort {
    NSDictionary *target = @{
        @"sessionInfo": @{
            @"quarantineInfo": @[],
            @"quarantinedItems": @(0)
        }};
    SortedJSONEncoder *jsonEncoder = [SortedJSONEncoder new];
    NSError *error = NULL;
    NSData *data = [jsonEncoder encode:target options:NSCaseInsensitiveSearch error:&error];

    XCTAssertNil(error);

    NSString *expected = @"{\"sessionInfo\":{\"quarantinedItems\":0,\"quarantineInfo\":[]}}";
    NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    XCTAssertEqualObjects(actual, expected);
}

- (void)testSystemSort {
    NSDictionary *target = @{
        @"sessionInfo": @{
            @"quarantineInfo": @[],
            @"quarantinedItems": @(0)
        }};
    SortedJSONEncoder *jsonEncoder = [SortedJSONEncoder new];
    NSError *error = NULL;
    NSData *data = [jsonEncoder encode:target options:0 error:&error];

    XCTAssertNil(error);

    NSString *expected = @"{\"sessionInfo\":{\"quarantineInfo\":[],\"quarantinedItems\":0}}";
    NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    XCTAssertEqualObjects(actual, expected);
}

- (void)testPlainCompareSort {
    NSDictionary *target = @{
        @"sessionInfo": @{
            @"quarantineInfo": @[],
            @"quarantinedItems": @(0)
        }};
    SortedJSONEncoder *jsonEncoder = [SortedJSONEncoder new];
    NSError *error = NULL;
    NSData *data = [jsonEncoder encode:target comparator:^NSComparisonResult(NSString *s1, NSString *s2) {
        return [s1 compare:s2];
    } error:&error];

    XCTAssertNil(error);

    NSString *expected = @"{\"sessionInfo\":{\"quarantineInfo\":[],\"quarantinedItems\":0}}";
    NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    XCTAssertEqualObjects(actual, expected);
}

- (void)testPrettyPrinted {
    NSDictionary *target = @{
            @"sessionInfo": @{
                    @"quarantineInfo": @[],
                    @"quarantinedItems": @(0)
            }};
    SortedJSONEncoder *jsonEncoder = [SortedJSONEncoder new];
    jsonEncoder.pretty = true;
    NSError *error = NULL;
    NSData *data = [jsonEncoder encode:target options:NSLiteralSearch error:&error];

    XCTAssertNil(error);

    NSString *expected = @"{\n\t\"sessionInfo\": {\n\t\t\"quarantineInfo\": [\n\t\t],\n\t\t\"quarantinedItems\": 0\n\t}\n}";
    NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    XCTAssertEqualObjects(actual, expected);
}

- (void)testPrettyPrinted2 {
    NSDictionary *target = @{
            @"sessionInfo": @{
                    @"quarantineInfo": @[@{@"aa":@"bb"}],
                    @"quarantinedItems": @(0)
            }};
    SortedJSONEncoder *jsonEncoder = [SortedJSONEncoder new];
    jsonEncoder.pretty = true;
    NSError *error = NULL;
    NSData *data = [jsonEncoder encode:target options:NSLiteralSearch error:&error];

    XCTAssertNil(error);

    NSString *expected = @"{\n\t\"sessionInfo\": {\n\t\t\"quarantineInfo\": [\n\t\t\t{\n\t\t\t\t\"aa\": \"bb\"\n\t\t\t}\n\t\t],\n\t\t\"quarantinedItems\": 0\n\t}\n}";
    NSString *actual = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    XCTAssertEqualObjects(actual, expected);
}

@end
