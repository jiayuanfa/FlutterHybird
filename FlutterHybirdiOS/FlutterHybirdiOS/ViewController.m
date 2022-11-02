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

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *showLabel;
@property(nonatomic, strong) UISwitch *channelswitch;
@property(nonatomic,assign) BOOL useEventChannel;
@property(nonatomic, strong) UILabel *channelLabel;
@property(nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addObserverWithShowMessage];
    [self layoutUI];
}

#pragma mark - notification
// 接收消息
- (void)addObserverWithShowMessage{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMessage:) name:@"showMessage" object:nil];
}

- (void)showMessage:(NSNotification*)notification{
    id params = notification.object;
    self.showLabel.text = [NSString stringWithFormat:@"来自Dart：%@",params];
}

#pragma mark - layoutUI
- (void)layoutUI{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.showLabel];
    [self.view addSubview:self.channelswitch];
    [self.view addSubview:self.channelLabel];
    [self.view addSubview:self.textField];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@RHWidth(0));
        make.top.equalTo(@RHHeigth(0));
    }];
    
    [self.channelswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(RHWidth(5));
        make.top.equalTo(self.titleLabel);
        make.bottom.equalTo(self.titleLabel);
    }];
    
    [self.channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(RHWidth(5));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(RHHeigth(5));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(RHWidth(5));
        make.top.equalTo(self.channelLabel.mas_bottom).offset(RHHeigth(5));
    }];
    
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(RHWidth(5));
        make.top.equalTo(self.textField.mas_bottom).offset(RHHeigth(5));
    }];
}

#pragma mark - lazy load
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"通信与混合开发Native模块";
        _titleLabel.textColor = [UIColor redColor];
    }
    return _titleLabel;
}

-(UISwitch *)channelswitch{
    if(_channelswitch == nil){
        _channelswitch = [[UISwitch alloc] init];
        [_channelswitch setTintColor:RHColor(@"0x99999")];
        [_channelswitch setOnTintColor:[UIColor blueColor]];
        [_channelswitch setThumbTintColor:[UIColor whiteColor]];
        _channelswitch.layer.cornerRadius = 15.5f;
        _channelswitch.layer.masksToBounds = YES;
        [_channelswitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _channelswitch;
}

- (void)switchAction:(UISwitch *)sender{
    if (sender.isOn) {
        self.useEventChannel = YES;
        self.channelLabel.text = @"BasicMessageChannelPlugin";
    } else {
        self.useEventChannel = NO;
        self.channelLabel.text = @"EventChannelPlugin";
    }
    NSLog(@"开关状态%d", self.useEventChannel);
}

- (UILabel *)channelLabel{
    if (!_channelLabel) {
        _channelLabel = [UILabel new];
        _channelLabel.text = @"EventChannelPlugin";
        _channelLabel.textColor = [UIColor redColor];
    }
    return _channelLabel;
}

- (UILabel *)showLabel{
    if (!_showLabel) {
        _showLabel = [UILabel new];
        _showLabel.textColor = [UIColor blueColor];
        _showLabel.text = @"Flutter传递过来的内容";
    }
    return _showLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.placeholder = @"请输入要传递给Flutter的内容";
        [_textField addTarget:self action:@selector(textContentChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (void)textContentChanged:(UITextField *)sender {
    NSLog(@"内容为%@", sender.text);
    
    // 发送内容通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessage" object:@{@"message": sender.text,@"useEventChannel":self.useEventChannel? @"true":@"false"}];
}

- (void)dealloc {
    
}

// 打开Flutter页面的几种方法
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
