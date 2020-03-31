//
//  FTUWebActionManager+ShareInstance.m
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebActionManager+ShareInstance.h"

static FTUWebActionManager *_shareWebActionManager;

@implementation FTUWebActionManager (ShareInstance)

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareWebActionManager = [[FTUWebActionManager alloc] init];
        if (_shareWebActionManager) {
            [_shareWebActionManager setupURLFilterObjects];
            [_shareWebActionManager setupJSBridgeObjects];
        }
    });
    return _shareWebActionManager;
}

- (void)setupURLFilterObjects {
    [self setupWithURLFilterConfigPath:[[NSBundle mainBundle] pathForResource:@"FTUWebFilterConfig" ofType:@"plist"]];
}

- (void)setupJSBridgeObjects {
    [self setupWithJSBridgeConfigPath:[[NSBundle mainBundle] pathForResource:@"FTUWebJSBridgeConfig" ofType:@"plist"]];
}

@end
