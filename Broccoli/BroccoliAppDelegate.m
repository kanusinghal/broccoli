//
//  BroccoliAppDelegate.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BroccoliAppDelegate.h"
#import "MovieListingTableViewController.h"
#import "BroccoliViewController.h"

@implementation BroccoliAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize auth = _auth;
@synthesize movieService = _movieService;

// Please use the client ID created for you by Google.
static NSString *const kClientID = @"129930356100.apps.googleusercontent.com";
static NSString *const kKeychainItemName = @"OAuth2 Sample: Google+";
static NSString *const kMyClientSecret = @"yqoiE3Z7nurZIujKvWa37-8w";

+ (NSString *)clientID {
    return kClientID;
}

+ (NSString *)kKeychainItemName {
    return kKeychainItemName;
}

+ (NSString *)kMyClientSecret {
    return kMyClientSecret;
}

#pragma mark Object life-cycle.

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _movieService = [MovieInfoService instance];
    // Show the login screen if the user hasn't already logged in
    // else take the user to the app.
    GTMOAuth2Authentication *auth = nil;
    auth = [GTMOAuth2ViewControllerTouch
            authForGoogleFromKeychainForName:kKeychainItemName
            clientID:kClientID
            clientSecret:kMyClientSecret];
    // Retain the authentication object, which holds the auth tokens
    // We can determine later if the auth object contains an access token
    // by calling its -canAuthorize method
    if ([auth canAuthorize]) {
        _tabBarController = [[[UITabBarController alloc] init] autorelease];
    
        BroccoliViewController* vc1 = [[BroccoliViewController alloc] init];
        MovieListingTableViewController* vc2 =
            [[MovieListingTableViewController alloc] init];
        vc2.userName = [auth userEmail];
        vc2.delegate = self;
        UINavigationController* navController = [[UINavigationController alloc]
                                             initWithRootViewController:vc2];
        navController.tabBarItem.title = @"Search";
        navController.tabBarItem.image = [UIImage imageNamed:@"search.png"];
    
        NSArray* controllers = [NSArray arrayWithObjects:vc1, navController, nil];
        _tabBarController.viewControllers = controllers;
    
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.rootViewController = _tabBarController;
    } else {
        // Show user login screen.
        GTMOAuth2ViewControllerTouch *newSignInView;
        newSignInView = [[GTMOAuth2ViewControllerTouch alloc]
                         initWithScope:@"https://www.googleapis.com/auth/plus.me"
                         clientID:kClientID
                         clientSecret:kMyClientSecret
                         keychainItemName:kKeychainItemName
                         delegate:self
                         finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self setSignInView:newSignInView];
        _window.rootViewController = _signInView;
    }
    // Save the authentication object, which holds the auth tokens and
    // the scope string used to obtain the token.  For Google services,
    // the auth object also holds the user's email address.
    [self setAuth:auth];
    // Override point for customization after application launch.
    [_window makeKeyAndVisible];
    return YES;
}

- (void)setAuth:(GTMOAuth2Authentication*) newAuth {
    [newAuth retain];
    [_auth release];
    // Make the new assignment.
    _auth = newAuth ;
}

- (void)setSignInView:(GTMOAuth2ViewControllerTouch*) newSignInView {
    [newSignInView retain];
    [_signInView release];
    // Make the new assignment.
    _signInView = newSignInView ;
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    if (error != nil) {
        // Authentication failed
        NSLog(@"Authentication failed");
        UIAlertView *alertView = [[[UIAlertView alloc]
								   initWithTitle:@"Authentication problem"
								   message:@"Authentication failed. Try again!"
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
        [alertView show];
    } else {
        // Authentication succeeded
        _tabBarController = [[[UITabBarController alloc] init] autorelease];
        
        BroccoliViewController* vc1 = [[BroccoliViewController alloc] init];
        MovieListingTableViewController* vc2 =
            [[MovieListingTableViewController alloc] init];
        vc2.userName = [auth userEmail];
        vc2.delegate = self;
        UINavigationController* navController = [[UINavigationController alloc]
                                                 initWithRootViewController:vc2];
        navController.tabBarItem.title = @"Search";
        navController.tabBarItem.image = [UIImage imageNamed:@"search.png"];
        
        NSArray* controllers = [NSArray arrayWithObjects:vc1, navController, nil];
        _tabBarController.viewControllers = controllers;
        
        _window.rootViewController = _tabBarController;

    }
}

- (void) logoutUser {
    if ([[_auth serviceProvider] isEqual:@"Google"]) {
        // remove the token from Google's servers
        [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:_auth];
    }
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
    
    [self setAuth:nil];
    GTMOAuth2ViewControllerTouch *newSignInView;
    newSignInView = [[GTMOAuth2ViewControllerTouch alloc]
                     initWithScope:@"https://www.googleapis.com/auth/plus.me"
                     clientID:kClientID
                     clientSecret:kMyClientSecret
                     keychainItemName:kKeychainItemName
                     delegate:self
                     finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [self setSignInView:newSignInView];
    [_movieService clearUserList];
    _window.rootViewController = _signInView;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
