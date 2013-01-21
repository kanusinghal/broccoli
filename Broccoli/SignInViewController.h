//
//  SignInViewController.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BroccoliViewController.h"
#import "GooglePlusSignIn.h"

@class GooglePlusSignInButton;

@interface SignInViewController : UIViewController<GooglePlusSignInDelegate> {
    BroccoliViewController *mainView;
}

// The button that handles Google+ sign-in.
@property (retain, nonatomic) IBOutlet GooglePlusSignInButton *signInButton;

@property(nonatomic, retain) BroccoliViewController *mainView;

@end
