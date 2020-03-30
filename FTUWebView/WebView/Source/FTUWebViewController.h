//
//  FTUWebViewController.h
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUActionWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

static void *FTUWebViewControllerKVODefaultContext = &FTUWebViewControllerKVODefaultContext;

@interface FTUWebViewController : FTUActionWebViewController

- (UIBarButtonItem *)navigationBackButtonItem;
- (UIBarButtonItem *)navigationCloseButtonItem;
- (UIBarButtonItem *)navigationRefreshButtonItem;

- (void)setupNavigationBarItems;
- (void)updateNavigationBarItems;

@end

NS_ASSUME_NONNULL_END
