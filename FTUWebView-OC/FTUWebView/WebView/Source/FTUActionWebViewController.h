//
//  FTUActionWebViewController.h
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUBaseWebViewController.h"
#import "FTUWebActionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTUActionWebViewController : FTUBaseWebViewController<FTUWebJSBridgeObjectRunJavaScriptProtocol>

/// 事件层初始化
/// @param webActionManager 事件管理器
- (instancetype)initWithWebActionManager: (FTUWebActionManager *)webActionManager;

@end

NS_ASSUME_NONNULL_END
