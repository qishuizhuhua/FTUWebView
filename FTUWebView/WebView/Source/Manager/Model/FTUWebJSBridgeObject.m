//
//  FTUWebJSBridgeObject.m
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebJSBridgeObject.h"

@implementation FTUWebJSBridgeObject

- (instancetype)initWithName:(NSString *)name action:(FTUWebJSBridgeObjectActionBlock)action {
    self = [super init];
    if (self) {
        _name = name;
        _action = action;
    }
    return self;
}

@end
