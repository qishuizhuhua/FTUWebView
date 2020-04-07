//
//  ViewController.m
//  FTUWebView
//
//  Created by ke on 2020/3/30.
//  Copyright © 2020 ke. All rights reserved.
//

#import "ViewController.h"
#import "FTUWebViewController.h"

#import "FTUWebActionManager+ShareInstance.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}



- (IBAction)URLAction:(id)sender {
    FTUWebViewController *vc = [[FTUWebViewController alloc] initWithWebActionManager:[FTUWebActionManager shareInstance]];
    vc.hidesBottomBarWhenPushed = true;
//    [vc loadWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [vc loadWithURLString:@"http://whycoco.coding.me/helloJRBridge/index.html"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)InputURLAction:(id)sender {
    
    
    
}

@end
