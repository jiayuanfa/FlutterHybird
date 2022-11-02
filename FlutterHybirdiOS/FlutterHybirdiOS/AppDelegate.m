//
//  AppDelegate.m
//  FlutterHybirdiOS
//
//  Created by 贾元发 on 28.10.22.
//

#import "AppDelegate.h"
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
//#import "ViewController.h"
#import "FirstViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[FirstViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
    // 此处初始化FlutterEngine
    self.flutterEngine = [[FlutterEngine alloc] initWithName:@"my flutter engine"];
      // Runs the default Dart entrypoint with a default Flutter route.
      [self.flutterEngine run];
      // Used to connect plugins (only if you have plugins with iOS platform code).
//    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
    return YES;
}

@end
