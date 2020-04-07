//
//  FTUWebJSBridgeCloseWebViewObject.m
//  FTUWebView
//
//  Created by ke on 2020/4/2.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebJSBridgeCloseWebViewObject.h"
#import "FTUWebJSBridgeObject+ResponseDataFormatter.h"

@implementation FTUWebJSBridgeCloseWebViewObject

{
    FTUWebJSBridgeObjectActionBlock _action;
    id _data;
}

- (NSString *)name {
    return @"closeWebView";
}


- (FTUWebJSBridgeObjectActionBlock)action {
    if (_action == nil) {
        __weak FTUWebJSBridgeCloseWebViewObject *weakSelf = self;
        _action = ^(NSString *name, id data) {
//            if ([weakSelf.fromViewController isKindOfClass:[FTUTabBarWebViewController class]]) {
//              FTUTabBarWebViewController *webVC = (FTUTabBarWebViewController *)weakSelf.fromViewController;
//                [webVC.webView goToBackForwardListItem:webVC.webView.backForwardList.backList.firstObject];
//            }
            [weakSelf.fromViewController.navigationController popViewControllerAnimated:YES];
        };
    }
    return [_action copy];
}

- (id)responseData {
    return [self callbackJSONWithStatus:@"1" code:@"10301" message:@"close webview success" data:nil];
}

@end
