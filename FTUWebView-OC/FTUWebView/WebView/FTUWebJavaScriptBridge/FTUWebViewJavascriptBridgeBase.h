//
//  WebViewJavascriptBridgeBase.h
//
//  Created by @LokiMeyburg on 10/15/14.
//  Copyright (c) 2014 @LokiMeyburg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kOldProtocolScheme @"wvjbscheme"
#define kNewProtocolScheme @"https"
#define kQueueHasMessage @"__wvjb_queue_message__"
#define kBridgeLoaded @"__bridge_loaded__"

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);
typedef NSDictionary WVJBMessage;

@protocol WebViewJavascriptBridgeBaseDelegate <NSObject>
- (NSString *)_evaluateJavascript:(NSString *)javascriptCommand;
@optional
- (void)_webViewJavascriptBridgeBaseDelegateNeedHandleCallBackWithResult: (id)result responseCallbackBlock: (WVJBResponseCallback)responseCallbackBlock;
@end


@interface FTUWebViewJavascriptBridgeBase : NSObject


@property (weak, nonatomic) id<WebViewJavascriptBridgeBaseDelegate> delegate;

/// 保存交互过程中需要发送给JavaScript环境的消息
@property (strong, nonatomic) NSMutableArray *startupMessageQueue;
/// 保存oc于JavaScript环境相互调用的回调，通过_uniqueId加上时间戳来确定每个调用的回调
@property (strong, nonatomic) NSMutableDictionary *responseCallbacks;
/// 保存OC环境注册的方法，key是方法名，value是这个方法对应的回调block
@property (strong, nonatomic) NSMutableDictionary *messageHandlers;
@property (strong, nonatomic) WVJBHandler messageHandler;

+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;
- (void)reset;
- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString *)handlerName;
- (void)flushMessageQueue:(NSString *)messageQueueString;
- (void)injectJavascriptFile;
- (BOOL)isWebViewJavascriptBridgeURL:(NSURL *)url;
- (BOOL)isQueueMessageURL:(NSURL *)urll;
- (BOOL)isBridgeLoadedURL:(NSURL *)urll;
- (void)logUnkownMessage:(NSURL *)url;
- (NSString *)webViewJavascriptCheckCommand;
- (NSString *)webViewJavascriptFetchQueyCommand;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end
