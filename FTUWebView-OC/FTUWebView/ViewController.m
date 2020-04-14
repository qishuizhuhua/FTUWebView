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
    UIAlertController  *inputAlertController = [UIAlertController alertControllerWithTitle:@"输入" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [inputAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.font = [UIFont systemFontOfSize:12];
    }];
    
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlStrings = [inputAlertController.textFields firstObject].text;
        FTUWebViewController *vc = [[FTUWebViewController alloc] initWithWebActionManager:[FTUWebActionManager shareInstance]];
        vc.hidesBottomBarWhenPushed = true;
        [vc loadWithURLString:urlStrings];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [inputAlertController addAction:submitAction];
    [self presentViewController:inputAlertController animated:true completion:nil];
    
    
}

@end
