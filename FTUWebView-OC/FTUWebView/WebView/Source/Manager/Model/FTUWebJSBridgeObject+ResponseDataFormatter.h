//
//  FTUWebJSBridgeObject+ResponseDataFormatter.h
//  FTUWebView
//
//  Created by ke on 2020/4/2.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebJSBridgeObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTUWebJSBridgeObject (ResponseDataFormatter)

- (NSString *)JSONWithObject: (id)object;
- (NSString *)callbackJSONWithStatus: (NSString *)status code: (NSString *)code message: (NSString *)message data: (id)data;


@end

NS_ASSUME_NONNULL_END
