//
//  FTUWebViewController.m
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebViewController.h"

@interface FTUWebViewController ()

@end

@implementation FTUWebViewController
{
    UIProgressView *_loadProgressView;
    
    /// navigationBar
    UIBarButtonItem *_navigationBackButtonItem;
    UIBarButtonItem *_navigationCloseButtonItem;
    UIBarButtonItem *_navigationRefreshButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///KVO
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    
    ///设置导航栏按钮
    [self setupNavigationBarItems];
    
    ///设置进度条
    [self.view addSubview:self.loadProgressView];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(orientation)) {
        //高度要做适配
        [self.loadProgressView setFrame:CGRectMake(0, 100, self.view.bounds.size.width, 1.5)];
    } else {
        [self.loadProgressView setFrame:CGRectMake(0, 32, self.view.bounds.size.width, 1.5)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


#pragma mark - private function
//设置导航条按钮
- (void)setupNavigationBarItems {
    self.navigationItem.leftBarButtonItem = [self navigationBackButtonItem];
    self.navigationItem.rightBarButtonItem = [self navigationRefreshButtonItem];
}

//更新导航条按钮
- (void)updateNavigationBarItems {
    if ([self.webView canGoBack]) {
        [self.navigationItem setLeftBarButtonItems:@[self.navigationBackButtonItem, self.navigationCloseButtonItem]];
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = true;
        [self.navigationItem setLeftBarButtonItem:self.navigationBackButtonItem];
    }
}

//更新进度条
- (void)updateCurrentProgress: (float)progress {
    [self.loadProgressView setProgress:progress animated:true];
    if (progress < 1.0) {
        [self.loadProgressView setAlpha:1.0];
    } else {
        [UIView animateWithDuration:0.24 animations:^{
            [self.loadProgressView setAlpha:0.0];
            [self.loadProgressView setProgress:0.0];
        }];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if ([super respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [super webView:webView didCommitNavigation:navigation];
    }
    [self updateNavigationBarItems];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSNumber *value = [change objectForKey:NSKeyValueChangeNewKey];
        float progress = [value floatValue];
        [self updateCurrentProgress:progress];
    }
    else if ([keyPath isEqualToString:@"title"]) {
        NSString *title = [change objectForKey:NSKeyValueChangeNewKey];
        self.title = title ?: @"";
    }
    else if ([keyPath isEqualToString:@"canGoBack"]) {
        [self updateNavigationBarItems];
    }
    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:FTUWebViewControllerKVODefaultContext];
    }
}

#pragma mark - UIDeviceOrientationDidChangeNotification
- (void)deviceOrientationDidChangeNotification: (NSNotification *)notification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsPortrait(orientation)) {
        [self.loadProgressView setFrame:CGRectMake(0, 64, self.view.bounds.size.width, 1.5)];
    }
    else {
        [self.loadProgressView setFrame:CGRectMake(0, 32, self.view.bounds.size.width, 1.5)];
    }
}


#pragma mark - Lazy Load
- (UIProgressView *)loadProgressView {
    if (_loadProgressView == nil) {
        _loadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _loadProgressView.progressTintColor = [UIColor colorWithRed:85.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0];
        _loadProgressView.trackTintColor = [UIColor clearColor];
    }
    return _loadProgressView;
}

//返回
- (UIBarButtonItem *)navigationBackButtonItem {
    if (_navigationBackButtonItem == nil) {
        _navigationBackButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStyleDone target:self action:@selector(navigationBackButtonItemAction:)];
    }
    return _navigationBackButtonItem;
}

- (void)navigationBackButtonItemAction: (UIBarButtonItem *)item {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
        [self.navigationController popViewControllerAnimated:true];
    }
}

//关闭
- (UIBarButtonItem *)navigationCloseButtonItem {
    if (_navigationCloseButtonItem == nil) {
        _navigationCloseButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_close"] style:UIBarButtonItemStyleDone target:self action:@selector(navigationCloseButtonItemAction:)];
    }
    return _navigationCloseButtonItem;
}

- (void)navigationCloseButtonItemAction: (UIBarButtonItem *)item {
    [self.webView stopLoading];
    //最好做个判断
    [self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:true];
}

//刷新
- (UIBarButtonItem *)navigationRefreshButtonItem {
    if (_navigationRefreshButtonItem == nil) {
        _navigationRefreshButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_refresh"] style:UIBarButtonItemStyleDone target:self action:@selector(navigationRefreshButtonItemAction:)];
    }
    return _navigationRefreshButtonItem;
}

- (void)navigationRefreshButtonItemAction: (UIBarButtonItem *)item {
    [self.webView reload];
}

@end
