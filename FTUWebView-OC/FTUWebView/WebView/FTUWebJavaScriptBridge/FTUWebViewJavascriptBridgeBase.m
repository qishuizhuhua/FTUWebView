//
//  WebViewJavascriptBridgeBase.m
//
//  Created by @LokiMeyburg on 10/15/14.
//  Copyright (c) 2014 @LokiMeyburg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTUWebViewJavascriptBridgeBase.h"
#import "FTUWebViewJavascriptBridge_JS.h"


@implementation FTUWebViewJavascriptBridgeBase
{
    __weak id _webViewDelegate;
    long _uniqueId;
}

static bool logging = false;
static int logMaxLength = 500;

+ (void)enableLogging { logging = true; }
+ (void)setLogMaxLength:(int)length { logMaxLength = length; }

//初始化基础环境需要保存的内容
- (id)init
{
    if (self = [super init]) {
        self.messageHandlers = [NSMutableDictionary dictionary];
        self.startupMessageQueue = [NSMutableArray array];
        self.responseCallbacks = [NSMutableDictionary dictionary];
        _uniqueId = 0;
    }
    return self;
}

- (void)dealloc
{
    self.startupMessageQueue = nil;
    self.responseCallbacks = nil;
    self.messageHandlers = nil;
}

- (void)reset
{
    self.startupMessageQueue = [NSMutableArray array];
    self.responseCallbacks = [NSMutableDictionary dictionary];
    _uniqueId = 0;
}

///将oc消息的，参数data，回调IDcallbackId，消息名handlerName存入一个名为message字典中
- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString *)handlerName
{
    NSMutableDictionary *message = [NSMutableDictionary dictionary];

    if (data) {
        message[@"data"] = data;
    }

    if (responseCallback) {
        NSString *callbackId = [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
        self.responseCallbacks[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }

    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self _queueMessage:message];
}

//从WEB发送的消息返回后，在这里处理
- (void)flushMessageQueue:(NSString *)messageQueueString
{
    if (messageQueueString == nil || messageQueueString.length == 0) {
        NSLog(@"WebViewJavascriptBridge: WARNING: ObjC got nil while fetching the message queue JSON from webview. This can happen if the WebViewJavascriptBridge JS is not currently present in the webview, e.g if the webview just loaded a new page.");
        return;
    }

    id messages = [self _deserializeMessageJSON:messageQueueString];
    for (WVJBMessage *message in messages) {
        if (![message isKindOfClass:[WVJBMessage class]]) {
            NSLog(@"WebViewJavascriptBridge: WARNING: Invalid %@ received: %@", [message class], message);
            continue;
        }
        [self _log:@"RCVD" json:message];

        NSString *responseId = message[@"responseId"];
        if (responseId) {
            WVJBResponseCallback responseCallback = _responseCallbacks[responseId];
            responseCallback(message[@"responseData"]);
            [self.responseCallbacks removeObjectForKey:responseId];
        } else {
            WVJBResponseCallback responseCallback = NULL;
            NSString *callbackId = message[@"callbackId"];
            if (callbackId) {
                responseCallback = ^(id responseData) {
                    if (responseData == nil) {
                        responseData = [NSNull null];
                    }

                    WVJBMessage *msg = @{ @"responseId" : callbackId,
                                          @"responseData" : responseData };
                    [self _queueMessage:msg];
                };
            } else {
                responseCallback = ^(id ignoreResponseData) {
                    // Do nothing
                };
            }

            WVJBHandler handler = self.messageHandlers[message[@"handlerName"]];

            if (!handler) {
                NSLog(@"WVJBNoHandlerException, No handler for message from JS: %@", message);
                if ([_delegate respondsToSelector:@selector(_webViewJavascriptBridgeBaseDelegateNeedHandleCallBackWithResult:responseCallbackBlock:)]) {
                    [_delegate _webViewJavascriptBridgeBaseDelegateNeedHandleCallBackWithResult:message[@"data"] responseCallbackBlock:responseCallback];
                }
                continue;
            }
            handler(message[@"data"], responseCallback);
        }
    }
}

//初始化注入WebViewJavascriptBridge_JS文件
- (void)injectJavascriptFile
{
    NSString *js = FTUWebViewJavascriptBridge_JS();
    [self _evaluateJavascript:js];
    //如果javascript环境初始化完成以后，有startupMessageQueue消息。则立即发送消息。
    if (self.startupMessageQueue) {
        NSArray *queue = self.startupMessageQueue;
        self.startupMessageQueue = nil;
        for (id queuedMessage in queue) {
            [self _dispatchMessage:queuedMessage];
        }
    }
}

- (BOOL)isWebViewJavascriptBridgeURL:(NSURL *)url
{
    if (![self isSchemeMatch:url]) {
        return NO;
    }
    return [self isBridgeLoadedURL:url] || [self isQueueMessageURL:url];
}

/*
   是否是WebViewJavascriptBridge发送或者接受的消息
*/
- (BOOL)isSchemeMatch:(NSURL *)url
{
    NSString *scheme = url.scheme.lowercaseString;
    return [scheme isEqualToString:kNewProtocolScheme] || [scheme isEqualToString:kOldProtocolScheme];
}

///是WebViewJavascriptBridge发送的消息，还是WebViewJavascriptBridge的初始化消息。
- (BOOL)isQueueMessageURL:(NSURL *)url
{
    NSString *host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kQueueHasMessage];
}

///是否是https://__bridge_loaded__这种初始化加载消息
- (BOOL)isBridgeLoadedURL:(NSURL *)url
{
    NSString *host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kBridgeLoaded];
}

- (void)logUnkownMessage:(NSURL *)url
{
    NSLog(@"WebViewJavascriptBridge: WARNING: Received unknown WebViewJavascriptBridge command %@", [url absoluteString]);
}

- (NSString *)webViewJavascriptCheckCommand
{
    return @"typeof WebViewJavascriptBridge == \'object\';";
}

- (NSString *)webViewJavascriptFetchQueyCommand
{
    return @"WebViewJavascriptBridge._fetchQueue();";
}

- (void)disableJavscriptAlertBoxSafetyTimeout
{
    [self sendData:nil responseCallback:nil handlerName:@"_disableJavascriptAlertBoxSafetyTimeout"];
}

// Private
// -------------------------------------------
//把javascript代码写入webview
- (void)_evaluateJavascript:(NSString *)javascriptCommand
{
    [self.delegate _evaluateJavascript:javascriptCommand];
}

- (void)_queueMessage:(WVJBMessage *)message
{
    if (self.startupMessageQueue) {
        [self.startupMessageQueue addObject:message];
    } else {
        [self _dispatchMessage:message];
    }
}

///OC消息序列化，转化为javascript环境的格式，在主线程中调用_evaluateJavascript
- (void)_dispatchMessage:(WVJBMessage *)message
{
    NSString *messageJSON = [self _serializeMessage:message pretty:NO];
    [self _log:@"SEND" json:messageJSON];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];

    NSString *javascriptCommand = [NSString stringWithFormat:@"WebViewJavascriptBridge._handleMessageFromObjC('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self _evaluateJavascript:javascriptCommand];

    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self _evaluateJavascript:javascriptCommand];
        });
    }
}

- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

- (NSArray *)_deserializeMessageJSON:(NSString *)messageJSON
{
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

- (void)_log:(NSString *)action json:(id)json
{
    if (!logging) {
        return;
    }
    if (![json isKindOfClass:[NSString class]]) {
        json = [self _serializeMessage:json pretty:YES];
    }
    if ([json length] > logMaxLength) {
        NSLog(@"WVJB %@: %@ [...]", action, [json substringToIndex:logMaxLength]);
    } else {
        NSLog(@"WVJB %@: %@", action, json);
    }
}

@end
