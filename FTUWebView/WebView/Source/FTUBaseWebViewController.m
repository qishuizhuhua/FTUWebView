//
//  FTUBaseWebViewController.m
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUBaseWebViewController.h"

@interface FTUBaseWebViewController ()

@end

@implementation FTUBaseWebViewController
{
    WKWebView *_webView;
    NSURLRequest *_notLoadRequest;
//    NSArray<WKUserScript *> *_userScripts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    ///init webview
    [self.view addSubview:self.webView];
    ///设置代理
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    ///layout webview ？细节处理
    self.webView.translatesAutoresizingMaskIntoConstraints = false;
    
    ///处理横竖屏
    NSArray *vLayouts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)];
    NSArray *hLayouts = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)];
    [self.view addConstraints:vLayouts];
    [self.view addConstraints:hLayouts];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_notLoadRequest != nil) {
        [self loadWithRequest:_notLoadRequest];
        _notLoadRequest = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"\n [WEBVIEW] >>>>> [%@ dealloc <<<<<] \n", NSStringFromClass([self class]));
}

- (WKWebView *)webView {
   if (_webView == nil) {
        //设置网页的配置文件
        WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
       
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
//        // 配置预先注入脚本 ?
//        if (_userScripts != nil && _userScripts.count > 0) {
//            for (WKUserScript *script in _userScripts) {
//                [userContentController addUserScript:script];
//            }
//        }
       
        webViewConfiguration.userContentController = userContentController;
        // 允许在线播放
        webViewConfiguration.allowsInlineMediaPlayback = true;
        // 允许可以与网页交互，选择视图  此默认值是WKSelectionGranularityDynamic，写true有问题，不需要
        webViewConfiguration.selectionGranularity = true;
        // web内容处理池
        webViewConfiguration.processPool = [[WKProcessPool alloc] init];
        // 是否支持记忆读取
        webViewConfiguration.suppressesIncrementalRendering = true;
        
        //创建 WebView
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:webViewConfiguration];
        _webView.scrollView.showsHorizontalScrollIndicator = true;
        _webView.scrollView.showsVerticalScrollIndicator = true;
        _webView.backgroundColor = [UIColor grayColor];
       
        //开启手势触摸
        _webView.allowsBackForwardNavigationGestures = true;
        
        //适应你设定的尺寸
//        [_webView sizeToFit];
    }
    return _webView;
}


#pragma mark - Public
- (void)loadWithURLString: (NSString *)URLString {
    //除去地址后空格
    NSURL *url = [NSURL URLWithString:[URLString stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self loadWithURL:url];
}
- (void)loadWithURL: (NSURL *)URL {
        NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:45.0];
    [self loadWithRequest:request];
}
- (void)loadWithRequest: (NSURLRequest *)request {
    if (_webView.superview == nil) {
        _notLoadRequest = request;
    } else {
        [self.webView loadRequest:request];
    }
}

@end
