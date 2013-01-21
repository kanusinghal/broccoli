//
//  SignInViewController.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInViewController.h"

#import "BroccoliAppDelegate.h"
#import "BroccoliViewController.h"
#import "GooglePlusSignInButton.h"

@interface SignInViewController ()

@end

@implementation SignInViewController
@synthesize signInButton = _signInButton;
@synthesize mainView = _mainView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reportAuthStatus {
    BroccoliAppDelegate *appDelegate = (BroccoliAppDelegate *)
    [[UIApplication sharedApplication] delegate];
    if (appDelegate.auth) {
        NSLog(@"Status: Authenticated");
    } else {
        // To authenticate, use Google+ sign-in button.
        NSLog(@"Status: Not authenticated");
    }
}

- (void)viewDidLoad
{
    // Set up sample view of Google+ sign-in.
    _signInButton.delegate = self;
    _signInButton.clientID = [BroccoliAppDelegate clientID];
    _signInButton.scope = [NSArray arrayWithObjects:
                           @"https://www.googleapis.com/auth/plus.me",
                           nil];
    
    BroccoliAppDelegate *appDelegate = (BroccoliAppDelegate *)
        [[UIApplication sharedApplication] delegate];
    appDelegate.signInButton = _signInButton;
    [self reportAuthStatus];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    BroccoliAppDelegate *appDelegate = (BroccoliAppDelegate *)
        [[UIApplication sharedApplication] delegate];
    appDelegate.signInButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_signInButton release];
    [super dealloc];
}

#pragma mark - GooglePlusSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        NSLog(@"Status: Authentication error: %@", error);
        return;
    }
    //BroccoliAppDelegate *appDelegate = (BroccoliAppDelegate *)
    //    [[UIApplication sharedApplication] delegate];
    //appDelegate.auth = auth;
    //[_mainView showMovieListingView];
}

@end
