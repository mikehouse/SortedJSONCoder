**SortedJSONCoder** is a library for encoding/serialization objects to JSON preserving some sorting rules. Written in Objective-C.

## Credits

95% of code is third-party dependencies:

- JSON encoder/decoder https://github.com/TouchCode/TouchJSON
- An ordered dictionary https://github.com/Marxon13/M13OrderedDictionary 

## Support

- Swift
- Objective-C

## Installation

### Cocoapods

```ruby
pod 'SortedJSONCoder', :git => 'https://github.com/mikehouse/SortedJSONCoder.git', :commit => 'cc868564'
```
No way make support of `SPM` and `Carthage` as used third-party libraries do not support these.  
 
## Interface

### Objective-C

```objectivec
@interface SortedJSONEncoder : NSObject

- (instancetype)init;

- (NSData *)encode:(NSDictionary *)jsonObject
           options:(NSStringCompareOptions)options
             error:(NSError **)error;

- (NSData *)encode:(NSDictionary *)jsonObject
        comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator
             error:(NSError **)error;

@end
```

### Swift

```swift
class SortedJSONEncoder {

    init()

    func encode(_ jsonObject: [AnyHashable : Any], 
                     options: NSString.CompareOptions = []) throws -> Data

    func encode(_ jsonObject: [AnyHashable : Any], 
                  comparator: @escaping (String, String) -> ComparisonResult) throws -> Data
}

```
 
## Usage
 
### Objective-C
 
```objectivec
#import <SortedJSONCoder/SortedJSONEncoder.h>

- (void)writeJSON:(NSDictionary *)object toPath:(NSURL *)path {
    SortedJSONEncoder *encoder = [SortedJSONEncoder new];
    NSData *data = [encoder encode:object options:NSCaseInsensitiveSearch error:nil];
    [data writeToURL:path atomically:YES];
}
```
 
Localized case insensitive order:
 
```objectivec
#import <SortedJSONCoder/SortedJSONEncoder.h>

- (void)writeJSON2:(NSDictionary *)object toPath:(NSURL *)path {
    SortedJSONEncoder *encoder = [SortedJSONEncoder new];
    NSData *data = [encoder encode:object comparator:^NSComparisonResult(NSString *s1, NSString *s2) {
            return [s1 localizedCaseInsensitiveCompare:s2];
        } error:nil];
    [data writeToURL:path atomically:YES];
}
```

### Swift

```swift
import SortedJSONCoder

let encoder = SortedJSONEncoder()
let dict: [String:Any] = ["a":1];
let data = try encoder.encode(dict, options: .literal)
try data.write(to: URL(string: "/path/to/out.json")!)
```

Custom order logic:

```swift
import SortedJSONCoder

let encoder = SortedJSONEncoder()
let dict: [String:Any] = ["a":1];
let data = try encoder.encode(dict, comparator: { (s1: String, s2: String) -> ComparisonResult in
    if s1 == s2 { return .orderedSame }
    else if s1 < s2 { return .orderedAscending }
    else { return .orderedDescending }
})
try data.write(to: URL(string: "/path/to/out.json")!)
```

#### Pretty Printed 

```swift
let encoder = SortedJSONEncoder()
encoder.pretty = true
```

## Why ?

Say we have a json file from server side:

```json
{
    "payload": {
        "prop1_key": "prop1_value",
        "prop2_key": "prop2_value"
    },
    "sha256": "bd575a7f4028fe0b195682193c99eaa734e62def4790280394807068727a4539"
}
```

where `sha256` is SHA256 hash for payload's json data, that is

```objectivec
NSData *jsonData = [[NSData alloc] initWithContentsOfFile:@"/path/to/server.json"];
NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
NSDictionary *payload = jsonObject[@"payload"];
NSData *payloadData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingSortedKeys error:nil];

NSString *expectedSHA256 = jsonObject[@"sha256"];
NSString *actualSHA256 = [[payloadData sha256] hex];

XCTAssertEqual(expectedSHA256, actualSHA256);
```

As you can see this hash check may fail when backend and iOS use different algorithms for keys sorting for JSON serialization, moreover on iOS standard SDK no way use different/custom sorting algorithm as only one available is system one. And here this library can help, where you can provide any you'd like sorting algorithm for JSON encoding.

Swift version of this logic:

```swift
struct Root: Codable {
    let payload: Payload
    let sha256: String
    struct Payload: Codable {
        let prop1_key: String
        let prop2_key: String
    }
}

let rootJSONData: Data = try Data(contentsOf: URL(string: "/path/to/server.json")!)
let rootObject: Root = try JSONDecoder().decode(Root.self, from: rootJSONData)
let payloadJSONData = try JSONEncoder().encode(rootObject.payload)
let payloadJSONObject = try JSONSerialization.jsonObject(with: payloadJSONData, options: []) as! [AnyHashable : Any]

let sortedPayloadData = try SortedJSONEncoder().encode(payloadJSONObject, options: .caseInsensitive)
let sha256: String = sortedPayloadData.sha256.hex()

assert(sha256 == rootObject.sha256)
```

## Tests

Base cases covered.

## TODO

- Pretty json formatting
- Support custom indents for json elements
 
## License

The code of this library itself - MIT   
https://github.com/TouchCode/TouchJSON - FreeBSD License   
https://github.com/Marxon13/M13OrderedDictionary - MIT
 
