//
//  AppDelegate.m
//  ZWControlVolume
//
//  Created by 崔先生的MacBook Pro on 2022/9/12.
//

#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    ViewController *vc = [ViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    [self volumeActive];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    NSLog(@"程序进入前台");
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterControllerView" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"程序被激活");
    [self volumeActive];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterControllerView" object:nil];
}

- (void)volumeActive {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];//重点方法
    [session setActive:YES error:nil];
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    //注，ios9上不加这一句会无效
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

@end
