//
//  MovieDetailViewController.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MovieObject;

// It is a way of saying that "AddNewMovieItemDelegate" is declared elsewhere
// Define a protocol that has methods to add an item to the user list.
@protocol AddNewMovieItemDelegate <NSObject>

// By default, methods are "required"; you can change this by prefacing methods with "@optional"
- (void) didAddNewItem:(MovieObject *)newItem;

@end

@interface MovieDetailViewController : UIViewController

@property (strong, nonatomic) MovieObject *movie;
@property (strong, nonatomic) NSString *userName;

@property (strong, nonatomic) IBOutlet UILabel *movieTitle;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *theaterLabel;
@property (strong, nonatomic) IBOutlet UILabel *castLabel;
@property (strong, nonatomic) IBOutlet UILabel *movieSynopsis;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// Delegate... this AddNewItem class will have a "delegate" property
// This is the way that a delegate must be declared 
// "id is a pointer to an object of any type"
// That's why we don't add the * referencing asterisk
// When an instance of this class is created, the creator will
// set the delegate property to self - a pointer to the creator object
@property (strong, nonatomic) id <AddNewMovieItemDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *addButton;
- (IBAction)addMovieToUserList:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *trailerButton;
- (IBAction)showTrailer:(id)sender;

- (void) hideAddButton;
@end


