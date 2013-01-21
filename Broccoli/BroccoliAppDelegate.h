//
//  BroccoliAppDelegate.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieInfoService.h"
#import "UserMovieListTableViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface BroccoliAppDelegate : UIResponder <UIApplicationDelegate, LogoutUserDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) GTMOAuth2ViewControllerTouch *signInView;
@property (strong, nonatomic) GTMOAuth2Authentication *auth;
@property (nonatomic, strong) MovieInfoService *movieService;

// The OAuth 2.0 client ID to be used for Google+ sign-in.
+ (NSString *)clientID;
+ (NSString *)kKeychainItemName;
+ (NSString *)kMyClientSecret;

@end
