//
//  AppDelegate.m
//  SafariSplitScreen
//
//  Created by Wayne Hartman on 9/18/15.
//  Copyright © 2015 Wayne Hartman. All rights reserved.
//

#import "AppDelegate.h"
@import SafariServices;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://google.com"]];

    self.window = window;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
