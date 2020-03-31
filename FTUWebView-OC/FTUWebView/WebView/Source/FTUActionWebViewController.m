//
//  FTUActionWebViewController.m
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUActionWebViewController.h"
#import "FTUWKWebViewJavascriptBridge.h"

@interface FTUActionWebViewController ()

@end

@implementation FTUActionWebViewController
{
    FTUWebActionManager *_webActionManager;
    FTUWKWebViewJavascriptBridge *_webViewJavaScriptBridge;
}

- (instancetype)initWithWebActionManager:(FTUWebActionManager *)webActionManager {
    self = [super init];
    if (self) {
        _webActionManager = webActionManager;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //WebViewJavascriptBridge注册
    [self registerJavaScriptHandlersWithBridge:self.webViewJavaScriptBridge];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self filterActionWithURL:webView.URL];
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    /// subclass need call super
//    if ([super respondsToSelector:@selector(webView:didCommitNavigation:)]) {
//        [super webView:webView didCommitNavigation:navigation];
//    }
    [self handleAllJSBridgeWithType:FTUWebJSBridgeObjectTypeUnconditional];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    /// subclass need call super
//    if ([super respondsToSelector:@selector(webView:didFinishNavigation:)]) {
//        [super webView:webView didFinishNavigation:navigation];
//    }
    [self handleAllJSBridgeWithType:FTUWebJSBridgeObjectTypeUnconditional];
}

#pragma mark - WKUIDelegate (WKWebView弹出对话框)
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(true);
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(false);
    }];
    [alertController addAction:doneAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText ?: @"";
    }];
    __weak UIAlertController *weakAlert = alertController;
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = [weakAlert.textFields firstObject].text;
        completionHandler(text ?: @"");
    }];
    [alertController addAction:doneAction];
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - FTUWebActionManagerHandler
- (void)filterActionWithURL: (NSURL *)URL {
    if (URL != nil) {
        NSString *urlString = URL.absoluteString;
        if ([urlString containsString:FTUBaseWebViewControllerBlank]) {
            return;
        }
        FTUWebURLFilterObject *object = [_webActionManager URLFilterObjectWithURL:urlString];
        if (object.action != nil) {
            object.fromViewController = self;
            object.action(URL);
        }
    }
}

- (void)handleJSBridgeWithName: (NSString *)name data: (id)data {
    if (name != nil) {
        FTUWebJSBridgeObject *object = [_webActionManager JSBridgeObjectWithName:name];
        if (object.action != nil) {
            object.fromViewController = self;
            object.javascriptExecutor = self;
            object.action(name, data);
        }
    }
}

- (void)handleAllJSBridgeWithType: (FTUWebJSBridgeObjectType)type {
    NSArray *objects = [_webActionManager JSBridgeObjectsWithType:type];
    for (FTUWebJSBridgeObject *object in objects) {
        if (object.action != nil) {
            object.fromViewController = self;
            object.javascriptExecutor = self;
            object.action([object.name copy], nil);
        }
    }
}

#pragma mark - FTUWebJSBridgeObjectRunJavaScriptProtocol
- (void)runJavaScriptShellWithScript:(NSString *)script {
    [self.webView evaluateJavaScript:script completionHandler:^(id _Nullable object, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@" >>>>> [%@ - runscript: {%@...}] error! <<<<<", NSStringFromClass([self class]), [script substringToIndex:(script.length > 10 ? 10: script.length - 1)]);
        }
        else {
            NSLog(@" >>>> [%@ - runscript: {%@...}] success! <<<<<", NSStringFromClass([self class]), [script substringToIndex:(script.length > 10 ? 10: script.length - 1)]);
        }
    }];
}


#pragma mark - FTUWKWebViewJavascriptBridge
- (FTUWKWebViewJavascriptBridge *)webViewJavaScriptBridge {
    if (_webViewJavaScriptBridge == nil) {
        _webViewJavaScriptBridge = [FTUWKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [_webViewJavaScriptBridge setWebViewDelegate:self];
    }
    return _webViewJavaScriptBridge;
}

- (void)registerJavaScriptHandlersWithBridge: (FTUWKWebViewJavascriptBridge *)bridge {
    __weak FTUActionWebViewController *weakSelf = self;
    for (FTUWebJSBridgeObject *object in _webActionManager.allJSBridgeObjects) {
        [bridge removeHandler:object.name];
        __weak FTUWebJSBridgeObject *weakObject = object;
        [bridge registerHandler:object.name handler:^(id data, WVJBResponseCallback responseCallback) {
            [weakSelf handleJSBridgeWithName:weakObject.name data:data];
            if (weakObject.responseData != nil) {
                responseCallback(weakObject.responseData);
            }
        }];
    }
}
@end
