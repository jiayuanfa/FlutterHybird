//
//  ViewController+MianViewController.m
//  FlutterHybridiOS
//
//  Created by jph on 2019/2/27.
//  Copyright © 2019 devio. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "ViewController.h"

// 实现FlutterStreamHandler接口，以完成对Flutter消息的监听
@interface MainViewController ()<FlutterStreamHandler>

@property (nonatomic, strong) ViewController *nativeViewController;
@property (nonatomic) FlutterViewController* flutterViewController;

@property (nonatomic) FlutterBasicMessageChannel* messageChannel;
@property (nonatomic) FlutterEventChannel* eventChannel;
@property (nonatomic) FlutterMethodChannel* methodChannel;
@property (nonatomic) FlutterEventSink eventSink;

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *nativeView;
@property (nonatomic, strong) UIView *flutterView;

@property (nonatomic, assign) int height;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage:) name:@"sendMessage" object:nil];
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.height = 200;
    
    [self initUI];
    [self initChannel];
    [self uiLayout];
}

#pragma mark - sendMessage

// 取出textField传过来的消息 并发送给Flutter
- (void)sendMessage:(NSNotification*)notification{
    NSString* mesage = [notification.object valueForKey:@"message"];
    if ([@"true" isEqual:[notification.object valueForKey:@"useEventChannel"]]) {
        //用EventChannel传递数据
        if (self.eventSink != nil) {
            self.eventSink(mesage);
        }
    } else {
        //用MessageChannel传递数据
        [self.messageChannel sendMessage: mesage reply:^(id  _Nullable reply) {
            if (reply != nil) {
                [self sendShow:reply];
            }
        }];
    }
}

#pragma mark - init Channel
- (void)initChannel{
    [self initMessageChannel];
    [self initEventChannel];
    [self initMethodChannel];
}

// 初始化MessageChannel, 监听来自Flutter的消息
- (void)initMessageChannel{
    self.messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"BasicMessageChannelPlugin" binaryMessenger:self.flutterViewController codec:[FlutterStringCodec sharedInstance]];
    MainViewController*  __weak weakSelf = self;
    //设置消息处理器，处理来自Dart的消息
    [self.messageChannel setMessageHandler:^(NSString* message, FlutterReply reply) {
        reply([NSString stringWithFormat:@"BasicMessageChannel收到：%@",message]);
        [weakSelf sendShow:message];
    }];
}

// 初始化EventChannel
- (void)initEventChannel{
    self.eventChannel = [FlutterEventChannel eventChannelWithName:@"EventChannelPlugin" binaryMessenger:self.flutterViewController];
    
    //设置消息处理器，处理来自Dart的消息
    [self.eventChannel setStreamHandler:self];
}

// 初始化MethodChannel
- (void)initMethodChannel{
    self.methodChannel = [FlutterMethodChannel methodChannelWithName:@"MethodChannelPlugin" binaryMessenger:self.flutterViewController];
    MainViewController*  __weak weakSelf = self;
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([@"send" isEqualToString:call.method]) {
            result([NSString stringWithFormat:@"MethodChannelPlugin收到：%@",call.arguments]);//返回结果给Dart);
            [weakSelf sendShow:call.arguments];
        }
    }];
}

// 发送Flutter传过来的内容给Label用于展示
- (void)sendShow:(NSString*) message{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMessage" object:message];
}

#pragma mark - <FlutterStreamHandler>
//这个onListen是Flutter端开始监听这个channel时的回调，第二个参数EventSink是用来传数据的载体
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)eventSink {
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    self.eventSink = eventSink;
    return nil;
}

//flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    self.eventSink = nil;
    return nil;
}

#pragma mark - InitUI
-(void)initUI {
    self.nativeViewController = [ViewController new];
    self.flutterViewController = [FlutterViewController new];
    self.nativeViewController.view.frame = CGRectZero;
    // 设置个占位空间
    self.flutterViewController.view.frame = CGRectZero;
    
    // addChildViewController之后，才能响应逻辑点击
    [self addChildViewController:self.nativeViewController];
    [self addChildViewController:self.flutterViewController];
    
    self.nativeView = self.nativeViewController.view;
    self.flutterView = self.flutterViewController.view;
}

#pragma mark - UILayout
- (void)uiLayout {
    [self.view addSubview:self.stackView];
    //    [self presentViewController:self.flutterViewController animated:YES completion:nil];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@RHWidth(20));
        make.right.equalTo(@RHWidth(-20));
        make.top.equalTo(@RHWidth(20));
        make.bottom.equalTo(@RHWidth(-20));
    }];
    
    //    self.nativeView = [[UIView alloc] initWithFrame:CGRectZero];
    //    self.nativeView.backgroundColor = [UIColor redColor];
    //    self.flutterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    self.flutterView.backgroundColor = [UIColor blueColor];
    //    [self.stackView addArrangedSubview:self.nativeView];
    //    [self.stackView addArrangedSubview:self.flutterView];
    
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(0, 0, 200, 100);
    //    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //    [button setTitle:@"高度修改动画" forState:UIControlStateNormal];
    //    button.backgroundColor = [UIColor blueColor];
    //    [self.nativeView addSubview:button];
    
    
    // 添加到stackView
    [self.stackView addArrangedSubview:self.nativeView];
    [self.stackView addArrangedSubview:self.flutterView];
    
    // 添加高度约束
    [self.nativeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@120);
    }];
}

- (void)buttonAction{
    self.height += 50;
    
    // 这两行不是必须的
    //    [self.view setNeedsUpdateConstraints];
    //    [self.view updateConstraintsIfNeeded];
    [self.nativeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.height));
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        // 告知父类控件绘制，不然动画无法生效
        // 将图层树和CAAnimation对象提交到渲染服务进程
        [self.nativeView.superview layoutIfNeeded];
    }];
}

#pragma mark - Lazy load
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
        //        _stackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _stackView.spacing = 10.0;
        //        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.axis = UILayoutConstraintAxisVertical;
        // 子View最后一个填充满，其他按照高度排列
        _stackView.distribution = UIStackViewDistributionFill;
    }
    return _stackView;
}

@end
