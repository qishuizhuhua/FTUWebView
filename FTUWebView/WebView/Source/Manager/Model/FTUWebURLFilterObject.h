//
//  FTUWebURLFilterObject.h
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FTUWebURLFilterObjectActionBlock)(NSURL *url);

@interface FTUWebURLFilterObject : NSObject

///过滤
///1.url链接
///2.事件的回调
///3.从哪个vc来
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) FTUWebURLFilterObjectActionBlock action;
@property (nonatomic, weak) UIViewController *fromViewController;


- (instancetype)initWithURL: (NSString *)URL action: (FTUWebURLFilterObjectActionBlock)action;

@end

NS_ASSUME_NONNULL_END
