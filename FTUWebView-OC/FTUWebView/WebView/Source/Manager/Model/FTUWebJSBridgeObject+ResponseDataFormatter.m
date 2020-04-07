//
//  FTUWebJSBridgeObject+ResponseDataFormatter.m
//  FTUWebView
//
//  Created by ke on 2020/4/2.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebJSBridgeObject+ResponseDataFormatter.h"

@implementation FTUWebJSBridgeObject (ResponseDataFormatter)

- (NSString *)callbackJSONWithStatus:(NSString *)status code:(NSString *)code message:(NSString *)message data:(id)data {
    NSDictionary *JSONDictionary = @{@"status": status ?: @"",
                                     @"code": code ?: @"",
                                     @"msg": message ?: @"",
                                     @"data": data ?: @""
                                     };
    return [self JSONWithObject:JSONDictionary];
}

- (NSString *)JSONWithObject:(id)object {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
