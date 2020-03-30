//
//  FTUWebActionManager.h
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTUWebURLFilterObject.h"
#import "FTUWebJSBridgeObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTUWebActionManager : NSObject

//两套机制
//1）URLFilter JS的注入
//2）JSBridge JSBridge 与前端交互

//URLFilter
- (void)setupWithURLFilterConfigPath: (NSString *)configPath;

- (void)addURLFilterObject: (FTUWebURLFilterObject *)object;
- (void)removeURLFilterObject: (FTUWebURLFilterObject *)object;
- (void)removeAllURLFilterObject;
- (FTUWebURLFilterObject *)URLFilterObjectWithURL: (NSString *)URL;
- (NSArray <FTUWebURLFilterObject *> *)allURLFilterObjects;

//JSBridge
- (void)setupWithJSBridgeConfigPath: (NSString *)configPath;

- (void)addJSBridgeObject: (FTUWebJSBridgeObject *)object;
- (void)removeJSBridgeObject: (FTUWebJSBridgeObject *)object;
- (void)removeAllJSBridgeObject;
- (FTUWebJSBridgeObject *)JSBridgeObjectWithName: (NSString *)name;
- (NSArray <FTUWebJSBridgeObject *> *)JSBridgeObjectsWithType: (FTUWebJSBridgeObjectType)type;
- (NSArray <FTUWebJSBridgeObject *> *)allJSBridgeObjects;

//reset
- (void)reset;
@end

NS_ASSUME_NONNULL_END
