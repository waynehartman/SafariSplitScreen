//
//  AppDelegate.m
//  SafariSplitScreen
//
//  Created by Wayne Hartman on 9/18/15.
//  Copyright © 2015 Wayne Hartman. All rights reserved.
//

#import "AppDelegate.h"
@import SafariServices;

@interface AppDelegate () <SFSafariViewControllerDelegate>

@end

NSString * const kInitialUri = @"https://google.com";

@implementation AppDelegate

- (void)transitionToNewSafariViewControllerWithURL:(NSURL *)url {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:url];
    safariVC.delegate = self;

    [self.window insertSubview:safariVC.view atIndex:0];
    safariVC.view.frame = self.window.bounds;

    UIView *toView = safariVC.view;
    UIView *fromView = self.window.rootViewController.view;

    toView.transform = CGAffineTransformMakeScale(0.7f, 0.7f);

    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0.25
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         fromView.transform = CGAffineTransformMakeTranslation(0.0f, fromView.frame.size.height);
                         toView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [self.window.rootViewController.view removeFromSuperview];
                         self.window.rootViewController = safariVC;
                     }];
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New Tab", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"Enter website name", nil);
        textField.keyboardType = UIKeyboardTypeURL;
        textField.returnKeyType = UIReturnKeyGo;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:NULL]];
    
    void(^show)(void) = ^{
        [weakSelf.window.rootViewController presentViewController:alert animated:YES completion:NULL];
    };
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Go", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textfield = [[alert textFields] firstObject];
        NSString *text = [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (text.length > 0) {
            if (![text hasPrefix:@"http"]) {
                text = [NSString stringWithFormat:@"http://%@", text];
            }

            NSURL *url = [NSURL URLWithString:text];

            if (url) {
                [weakSelf transitionToNewSafariViewControllerWithURL:url];
            } else {
                show();
            }
        } else {
            show();
        }
    }]];
    
    show();
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:kInitialUri]];
    safariVC.delegate = self;

    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = safariVC;

    self.window = window;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
