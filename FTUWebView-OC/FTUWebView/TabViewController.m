//
//  TabViewController.m
//  FTUWebView
//
//  Created by ke on 2020/4/2.
//  Copyright © 2020 ke. All rights reserved.
//

#import "TabViewController.h"
#import "ViewController.h"
#import "FTUTabBarWebViewController.h"
#import "FTUWebActionManager+ShareInstance.h"


@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"vc"];

       UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nc1.tabBarItem.title = @"Custom";
    
    
    FTUTabBarWebViewController *vc2 = [[FTUTabBarWebViewController alloc] initWithWebActionManager:[FTUWebActionManager shareInstance]];
//    [vc2 loadWithURLString:@"http://whycoco.coding.me/helloJRBridge/index.html"];
    [vc2 loadWithURLString:@"http://www.baidu.com"];
       UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nc2.tabBarItem.title = @"FTUWeb";
    self.viewControllers = @[nc1,nc2];
}

@end
