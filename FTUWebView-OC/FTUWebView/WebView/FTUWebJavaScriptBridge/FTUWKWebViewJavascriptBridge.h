//
//  WKWebViewJavascriptBridge.h
//
//  Created by @LokiMeyburg on 10/15/14.
//  Copyright (c) 2014 @LokiMeyburg. All rights reserved.
//

#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1)
#define supportsWKWebView
#endif

#if defined supportsWKWebView

#import <Foundation/Foundation.h>
#import "FTUWebViewJavascriptBridgeBase.h"
#import <WebKit/WebKit.h>


@interface FTUWKWebViewJavascriptBridge : NSObject <WKNavigationDelegate, WebViewJavascriptBridgeBaseDelegate>

/// 初始化一个OC环境的桥WKwebViewJavascriptBridge
/// @param webView WKWebView页面
+ (instancetype)bridgeForWebView:(WKWebView *)webView;

/// 开启日志
+ (void)enableLogging;

- (void)registerDefaultHandler: (WVJBHandler)handler;
- (void)removeDefaultHandler;

/// oc环境注册方法
/// @param handlerName OC提供给JS的方法名字
/// @param handler OC给JS的回调
- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;
- (void)removeHandler:(NSString *)handlerName;
- (void)removeAllHandler;

- (void)callHandler:(NSString *)handlerName;
- (void)callHandler:(NSString *)handlerName data:(id)data;
- (void)callHandler:(NSString *)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
- (void)reset;
- (void)setWebViewDelegate:(id)webViewDelegate;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end

#endif
