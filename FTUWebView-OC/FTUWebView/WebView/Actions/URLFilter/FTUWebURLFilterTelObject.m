//
//  FTUWebURLFilterTelObject.m
//  FTUWebView
//
//  Created by ke on 2020/4/2.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebURLFilterTelObject.h"

///H5电话号码拦截拨打打电话

@implementation FTUWebURLFilterTelObject
{
    FTUWebURLFilterObjectActionBlock _action;
    UIWebView *_callWebView;
}

- (NSString *)url {
    return @"tel:";
}

- (FTUWebURLFilterObjectActionBlock)action {
    if (_action == nil) {
        if (_callWebView == nil) {
            _callWebView = [[UIWebView alloc] init];
            [[UIApplication sharedApplication].keyWindow addSubview:_callWebView];
        }
        _callWebView.frame = CGRectZero;
        __weak UIWebView *weakCallWebView = _callWebView;
        _action = ^(NSURL *url) {
            [weakCallWebView loadRequest:[NSURLRequest requestWithURL:url]];
        };
    }
    return [_action copy];
}

@end
