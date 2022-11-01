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
}

#pragma mark mas
- (void)uiLayout {
    [self.view addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@RHHeigth(20));
        make.left.equalTo(@RHHeigth(20));
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

-(UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"离岛免税商品溯源公共平台";
        _titleLab.font = RHSacleFont(25);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = RH_BlackTextColor;
    }
    return _titleLab;
}

@end
