//
//  FirstViewController.m
//  FlutterHybirdiOS
//
//  Created by 贾元发 on 1.11.22.
//

#import "FirstViewController.h"
#import "MainViewController.h"

@interface FirstViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;

    [self uiLayout];
}


- (void)goToAction:(UIButton *)sender{
    NSLog(@"点击了%@", sender.titleLabel.text);
    
    [self.navigationController pushViewController:[MainViewController new] animated:YES];
}

#pragma mark mas
- (void)uiLayout {
    [self.view addSubview:self.button];
    [self.view addSubview:self.textField];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@RHHeigth(20));
        make.left.equalTo(@RHHeigth(20));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.button.mas_bottom).with.offset(RHHeigth(20));
        make.left.equalTo(self.button.mas_left);
    }];
}


#pragma mark lazy
-(UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"Go To" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(goToAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        [_textField setPlaceholder:@"请输入要传递的内容"];
    }
    return _textField;
}

@end
