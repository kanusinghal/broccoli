//
//  BroccoliViewController.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BroccoliViewController.h"
#import "BroccoliAppDelegate.h"
#import "GTMOAuth2Authentication.h"
#import "UserMovieListTableViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface BroccoliViewController ()
    // Get the saved authentication, if any, from the keychain.
    @property (strong, nonatomic) GTMOAuth2Authentication *auth;
    @property (strong, nonatomic) GTMOAuth2ViewControllerTouch *signInView;
    @property (strong, nonatomic) UserMovieListTableViewController *userMovieListView;
@end

@implementation BroccoliViewController
@synthesize auth = _auth;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.tabBarItem.title = @"My Movies";
    self.tabBarItem.image = [UIImage imageNamed:@"movie.png"];
    GTMOAuth2Authentication *auth = nil;
    auth = [GTMOAuth2ViewControllerTouch
               authForGoogleFromKeychainForName:[BroccoliAppDelegate kKeychainItemName]
               clientID:[BroccoliAppDelegate clientID]
               clientSecret:[BroccoliAppDelegate kMyClientSecret]];
    
    // User was authorized, take him to the movie listing screen.
    UIStoryboard *storyboard =
    [UIStoryboard storyboardWithName:@"BroccoliStoryboard" bundle:nil];
    UserMovieListTableViewController *userMovieListView;
    userMovieListView =
        [storyboard instantiateViewControllerWithIdentifier:@"userMovieListView"];;
    
    [self setUserMovieListView:userMovieListView];
    _userMovieListView.userName = [[NSString alloc] initWithString:auth.userEmail];
    BroccoliAppDelegate *appDelegate =
        (BroccoliAppDelegate*)[[UIApplication sharedApplication] delegate];
    _userMovieListView.delegate = appDelegate;
    UINavigationController *navigationController =
        [[UINavigationController alloc] init];
    [navigationController pushViewController:_userMovieListView animated:YES];
    [self.view addSubview: navigationController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [_auth release];
    
    [super dealloc];
}

@end
