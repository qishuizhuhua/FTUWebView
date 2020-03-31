//
//  FTUWebURLFilterObject.m
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "FTUWebURLFilterObject.h"

@implementation FTUWebURLFilterObject

- (instancetype)initWithURL:(NSString *)URL action:(FTUWebURLFilterObjectActionBlock)action {
    self = [super init];
    if (self) {
        _url = URL;
        _action = action;
    }
    return self;
}

@end
