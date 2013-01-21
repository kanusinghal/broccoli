//
//  MovieListingTableViewController.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieDetailViewController.h" 

// It is a way of saying that "AddNewMovieItemDelegate" is declared elsewhere
// Define a protocol that has methods to add an item to the user list.
@protocol LogoutUserDelegate <NSObject>

// By default, methods are "required"; you can change this by prefacing methods with "@optional"
- (void) logoutUser;

@end

@interface MovieListingTableViewController :
    UITableViewController<UISearchBarDelegate, AddNewMovieItemDelegate> {

    UISearchBar *searchBar;
}
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSString *userName;
@property (strong, nonatomic) id <LogoutUserDelegate> delegate;

@end
