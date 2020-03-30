//
//  FTUWebJSBridgeObject.h
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol FTUWebJSBridgeObjectRunJavaScriptProtocol<NSObject>

- (void)runJavaScriptShellWithScript: (NSString * _Nullable)script;

@end

/**
 类型

 - FTUWebJSBridgeObjectTypeDefault: 有条件筛选, 会根据name特定执行的动作
 - FTUWebJSBridgeObjectTypeUnconditional: 无条件筛选, 一定执行
 */
typedef NS_ENUM(NSUInteger, FTUWebJSBridgeObjectType) {
    FTUWebJSBridgeObjectTypeDefault = 0,
    FTUWebJSBridgeObjectTypeUnconditional
};

typedef void(^FTUWebJSBridgeObjectActionBlock)(NSString *name, id data);

@interface FTUWebJSBridgeObject : NSObject

///JSBridge拦截
///1.那种条件筛选
///2.定义的名称
///3.事件回调
///4.从哪个vc来
///5.JavaScript执行
///6.返回数据
@property (nonatomic, assign) FTUWebJSBridgeObjectType type;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) FTUWebJSBridgeObjectActionBlock action;
@property (nonatomic, weak, nullable) UIViewController *fromViewController;
@property (nonatomic, weak, nullable) id<FTUWebJSBridgeObjectRunJavaScriptProtocol> javascriptExecutor;
@property (nonatomic, nullable) id responseData;


- (instancetype)initWithName: (NSString *)name action: (FTUWebJSBridgeObjectActionBlock)action;

@end

NS_ASSUME_NONNULL_END
