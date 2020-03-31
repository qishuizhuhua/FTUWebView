//
//  FTUBaseWebViewController.h
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *FTUBaseWebViewControllerBlank = @"about:blank";

@interface FTUBaseWebViewController : UIViewController<WKUIDelegate, WKNavigationDelegate>

- (WKWebView *)webView;

- (void)loadWithURLString: (NSString *)URLString;
- (void)loadWithURL: (NSURL *)URL;
- (void)loadWithRequest: (NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
