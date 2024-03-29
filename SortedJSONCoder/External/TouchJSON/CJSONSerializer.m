//
//  CJSONSerializer.m
//  TouchCode
//
//  Created by Jonathan Wight on 12/07/2005.
//  Copyright 2005 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CJSONSerializer.h"
#import <M13OrderedDictionary/M13OrderedDictionary.h>
#import "JSONRepresentation.h"

NSString *const kJSONSerializerErrorDomain = @"CJSONSerializerErrorDomain";


static NSData *kNULL = NULL;
static NSData *kFalse = NULL;
static NSData *kTrue = NULL;

@implementation CJSONSerializer

@synthesize options;

+ (void)initialize
    {
    @autoreleasepool
        {
        if (kNULL == NULL)
            kNULL = [[NSData alloc] initWithBytesNoCopy:(void *)"null" length:4 freeWhenDone:NO];
        if (kFalse == NULL)
            kFalse = [[NSData alloc] initWithBytesNoCopy:(void *)"false" length:5 freeWhenDone:NO];
        if (kTrue == NULL)
            kTrue = [[NSData alloc] initWithBytesNoCopy:(void *)"true" length:4 freeWhenDone:NO];
        }
    }

+ (CJSONSerializer *)serializer
    {
    return([[self alloc] init]);
    }

- (BOOL)isValidJSONObject:(id)inObject
    {
    if ([inObject isKindOfClass:[NSNull class]])
        {
        return(YES);
        }
    else if ([inObject isKindOfClass:[NSNumber class]])
        {
        return(YES);
        }
    else if ([inObject isKindOfClass:[NSString class]])
        {
        return(YES);
        }
    else if ([inObject isKindOfClass:[NSArray class]])
        {
        return(YES);
        }
    else if ([inObject isKindOfClass:[NSDictionary class]]
             || [inObject isKindOfClass:[M13OrderedDictionary class]])
        {
        return(YES);
        }
    else if ([inObject isKindOfClass:[NSData class]])
        {
        return(YES);
        }
    else if ([inObject respondsToSelector:@selector(JSONDataRepresentation)])
        {
        return(YES);
        }
    else
        {
        return(NO);
        }
    }

- (NSData *)serializeObject:(id)inObject error:(NSError **)outError
    {
    NSData *theResult = NULL;

    if ([inObject isKindOfClass:[NSNull class]])
        {
        theResult = [self serializeNull:inObject error:outError];
        }
    else if ([inObject isKindOfClass:[NSNumber class]])
        {
        theResult = [self serializeNumber:inObject error:outError];
        }
    else if ([inObject isKindOfClass:[NSString class]])
        {
        theResult = [self serializeString:inObject error:outError];
        }
    else if ([inObject isKindOfClass:[NSArray class]])
        {
        theResult = [self serializeArray:inObject error:outError];
        }
    else if ([inObject isKindOfClass:[NSDictionary class]]
             || [inObject isKindOfClass:[M13OrderedDictionary class]])
        {
        theResult = [self serializeDictionary:inObject error:outError];
        }
    else if ([inObject isKindOfClass:[NSData class]])
        {
        NSString *theString = [[NSString alloc] initWithData:inObject encoding:NSUTF8StringEncoding];
        if (theString == NULL)
            {
            if (outError)
                {
                NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSString stringWithFormat:@"Cannot serialize data of type '%@'", NSStringFromClass([inObject class])], NSLocalizedDescriptionKey,
                    NULL];
                *outError = [NSError errorWithDomain:kJSONSerializerErrorDomain code:CJSONSerializerErrorCouldNotSerializeDataType userInfo:theUserInfo];
                }
            }
        else
            {
            theResult = [self serializeString:theString error:outError];
            }
        }
    else if ([inObject respondsToSelector:@selector(JSONDataRepresentation)])
        {
        theResult = [inObject JSONDataRepresentation];
        }
    else
        {
        if (outError)
            {
            NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSString stringWithFormat:@"Cannot serialize data of type '%@'", NSStringFromClass([inObject class])], NSLocalizedDescriptionKey,
                NULL];
            *outError = [NSError errorWithDomain:kJSONSerializerErrorDomain code:CJSONSerializerErrorCouldNotSerializeDataType userInfo:theUserInfo];
            }
        return(NULL);
        }
    if (theResult == NULL)
        {
        if (outError)
            {
            NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSString stringWithFormat:@"Could not serialize object '%@'", inObject], NSLocalizedDescriptionKey,
                NULL];
            *outError = [NSError errorWithDomain:kJSONSerializerErrorDomain code:CJSONSerializerErrorCouldNotSerializeObject userInfo:theUserInfo];
            }
        return(NULL);
        }
    return(theResult);
    }

- (NSData *)serializeNull:(NSNull *)inNull error:(NSError **)outError
    {
    #pragma unused (inNull, outError)
    return(kNULL);
    }

- (NSData *)serializeNumber:(NSNumber *)inNumber error:(NSError **)outError
    {
    #pragma unused (outError)
    NSData *theResult = NULL;
    switch (CFNumberGetType((__bridge CFNumberRef)inNumber))
        {
        case kCFNumberCharType:
            {
            int theValue = [inNumber intValue];
            if (theValue == 0)
                theResult = kFalse;
            else if (theValue == 1)
                theResult = kTrue;
            else
                theResult = [[inNumber stringValue] dataUsingEncoding:NSASCIIStringEncoding];
            }
            break;
        case kCFNumberFloat32Type:
        case kCFNumberFloat64Type:
        case kCFNumberFloatType:
        case kCFNumberDoubleType:
        case kCFNumberSInt8Type:
        case kCFNumberSInt16Type:
        case kCFNumberSInt32Type:
        case kCFNumberSInt64Type:
        case kCFNumberShortType:
        case kCFNumberIntType:
        case kCFNumberLongType:
        case kCFNumberLongLongType:
        case kCFNumberCFIndexType:
        default:
            theResult = [[inNumber stringValue] dataUsingEncoding:NSASCIIStringEncoding];
            break;
        }
    return(theResult);
    }

- (NSData *)serializeString:(NSString *)inString error:(NSError **)outError
    {
    #pragma unused (outError)

    const char *theUTF8String = [inString UTF8String];

    NSMutableData *theData = [NSMutableData dataWithLength:strlen(theUTF8String) * 2 + 2];

    char *theOutputStart = [theData mutableBytes];
    char *OUT = theOutputStart;

    *OUT++ = '"';

    for (const char *IN = theUTF8String; IN && *IN != '\0'; ++IN)
        {
        switch (*IN)
            {
            case '\\':
                {
                *OUT++ = '\\';
                *OUT++ = '\\';
                }
                break;
            case '\"':
                {
                *OUT++ = '\\';
                *OUT++ = '\"';
                }
                break;
            case '/':
                {
                if (self.options & kJSONSerializationOptions_EncodeSlashes)
                    {
                    *OUT++ = '\\';
                    *OUT++ = '/';
                    }
                else
                    {
                    *OUT++ = *IN;
                    }
                }
                break;
            case '\b':
                {
                *OUT++ = '\\';
                *OUT++ = 'b';
                }
                break;
            case '\f':
                {
                *OUT++ = '\\';
                *OUT++ = 'f';
                }
                break;
            case '\n':
                {
                *OUT++ = '\\';
                *OUT++ = 'n';
                }
                break;
            case '\r':
                {
                *OUT++ = '\\';
                *OUT++ = 'r';
                }
                break;
            case '\t':
                {
                *OUT++ = '\\';
                *OUT++ = 't';
                }
                break;
            default:
                {
                *OUT++ = *IN;
                }
                break;
            }
        }

    *OUT++ = '"';

    theData.length = OUT - theOutputStart;
    return(theData);
    }

- (NSData *)serializeArray:(NSArray *)inArray error:(NSError **)outError
    {
    NSMutableData *theData = [NSMutableData data];

    if (self.pretty) {
        [theData appendBytes:" [" length:2];
    } else {
        [theData appendBytes:"[" length:1];
    }

    self.depth += 1;

    NSEnumerator *theEnumerator = [inArray objectEnumerator];
    NSString *openPadding = [self jsonPaddingString];
    if (openPadding.length > 0 && [inArray count] > 0) {
        [theData appendData:[openPadding dataUsingEncoding:NSASCIIStringEncoding]];
    }
    id theValue = NULL;
    NSUInteger i = 0;
    while ((theValue = [theEnumerator nextObject]) != NULL)
        {
        NSData *theValueData = [self serializeObject:theValue error:outError];
        if (theValueData == NULL)
            {
            return(NULL);
            }
        [theData appendData:theValueData];
        if (++i < [inArray count]) {
            [theData appendBytes:"," length:1];
            NSString *nextPadding = [self jsonPaddingString];
            if (nextPadding.length > 0) {
                [theData appendData:[nextPadding dataUsingEncoding:NSASCIIStringEncoding]];
            }
        }
        }

    self.depth -= 1;
    NSString *closePadding = [self jsonPaddingString];
    if (closePadding.length > 0) {
        [theData appendData:[closePadding dataUsingEncoding:NSASCIIStringEncoding]];
    }
    [theData appendBytes:"]" length:1];

    return(theData);
    }

- (NSString *)jsonPaddingString {
    if (self.pretty == false) {
        return @"";
    }
    NSMutableString *padding = [[NSMutableString alloc] init];
    if (self.depth >= 0) {
        [padding appendString:@"\n"];
    }
    for (int i = 0; i < self.depth; ++i) {
        [padding appendString:@"\t"];
    }
    return padding;
}

- (NSData *)serializeDictionary:(id)inDictionary error:(NSError **)outError
    {
    NSMutableData *theData = [NSMutableData data];

    [theData appendBytes:"{" length:1];
    self.depth += 1;
    NSArray *theKeys = [inDictionary allKeys];
    NSString *openPadding = [self jsonPaddingString];
    if (openPadding.length > 0 && theKeys.count > 0) {
        [theData appendData:[openPadding dataUsingEncoding:NSASCIIStringEncoding]];
    }

    NSEnumerator *theEnumerator = [theKeys objectEnumerator];
    NSString *theKey = NULL;
    while ((theKey = [theEnumerator nextObject]) != NULL)
        {
        id theValue = [inDictionary objectForKey:theKey];

        NSData *theKeyData = [self serializeString:theKey error:outError];
        if (theKeyData == NULL)
            {
            return(NULL);
            }
        NSData *theValueData = [self serializeObject:theValue error:outError];
        if (theValueData == NULL)
            {
            return(NULL);
            }


        [theData appendData:theKeyData];
        if ([theValue isKindOfClass:[NSDictionary class]]
                || [theValue isKindOfClass:[NSArray class]]
                || self.pretty == false) {
            [theData appendBytes:":" length:1];
        } else {
            [theData appendBytes:": " length:2];
        }
        [theData appendData:theValueData];

        if (theKey != [theKeys lastObject]) {
            [theData appendData:[@"," dataUsingEncoding:NSASCIIStringEncoding]];
            NSString *nextPadding = [self jsonPaddingString];
            if (nextPadding.length > 0) {
                [theData appendData:[nextPadding dataUsingEncoding:NSASCIIStringEncoding]];
            }
        }
        }

        self.depth -= 1;
        NSString *closePadding = [self jsonPaddingString];
        if (closePadding.length > 0) {
            [theData appendData:[closePadding dataUsingEncoding:NSASCIIStringEncoding]];
        }
        [theData appendBytes:"}" length:1];

    return(theData);
    }

@end
