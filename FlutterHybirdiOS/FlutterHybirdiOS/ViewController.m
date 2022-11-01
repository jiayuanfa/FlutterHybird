//
//  ViewController.m
//  FlutterHybirdiOS
//
//  Created by 贾元发 on 28.10.22.
//

#import <Flutter/Flutter.h>
#import "ViewController.h"
#import "AppDelegate.h"
#import "FirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(handlerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Flutter get" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor redColor]];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)handlerButtonAction {
    // 使用FlutterViewController打开Flutter页面
//    FlutterViewController *flutterViewController = [FlutterViewController new];
//    [flutterViewController setInitialRoute:@"{name:'devio', datalist:['aa', 'bb', 'cc']}"];
//    [self presentViewController:flutterViewController animated:YES completion:nil];
    
    
    // 使用FlutterEngine打开Flutter页面
//    FlutterEngine *flutterEngine =
//            ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
//        FlutterViewController *flutterViewController =
//            [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
//        [self presentViewController:flutterViewController animated:YES completion:nil];
    
//    FirstViewController *fvc = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
//    [self.navigationController pushViewController:fvc animated:YES];
    
    // 第一种方法 通过storyBord的名字 取得SB再通过通过SB调用instantiateViewControllerWithIdentifier取得VC
    [self.navigationController pushViewController:[FirstViewController new] animated:YES];
}

@end
