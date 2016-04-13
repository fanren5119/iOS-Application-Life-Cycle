//
//  AppDelegate.m
//  BackgroundRun
//
//  Created by 王磊 on 16/4/13.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgoundTask];
    }];
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(selectorToTimer) userInfo:nil repeats:YES];
    }
}

- (void)endBackgoundTask
{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.timer invalidate];
        self.timer = nil;
        
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    });
}

- (void)selectorToTimer
{
    NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    if (backgroundTimeRemaining == DBL_MAX) {
        NSLog(@"background time remaining = undetermined");
    } else {
        NSLog(@"background time remaining = %.2f", backgroundTimeRemaining);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        [self endBackgoundTask];
    }
}


@end
