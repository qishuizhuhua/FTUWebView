//
//  FTUTabBarWebViewController.m
//  FTUWebView
//
//  Created by ke on 2020/4/2.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUTabBarWebViewController.h"

@interface FTUTabBarWebViewController ()

@end

@implementation FTUTabBarWebViewController

{
    NSString *_defaultTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload {
    [self.webView reload];
}

- (void)setupNavigationBarItems {
    
}

- (void)updateNavigationBarItems {
    if ([self.webView canGoBack]) {
        [self.navigationItem setLeftBarButtonItem:self.navigationBackButtonItem];
        [self.navigationItem setRightBarButtonItems:@[self.navigationRefreshButtonItem]];
    }
    else {
        self.navigationController.interactivePopGestureRecognizer.enabled = true;
        [self.navigationItem setLeftBarButtonItem:nil];
        [self.navigationItem setRightBarButtonItems:@[self.navigationRefreshButtonItem]];
    }
}

- (void)setDefaultTitle:(NSString *)title {
    _defaultTitle = [title copy];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:_defaultTitle];
    self.navigationItem.title = title;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        NSString *title = [change objectForKey:NSKeyValueChangeNewKey];
        self.title = title ?: _defaultTitle;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
