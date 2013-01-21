//
//  UserMovieListTableViewController.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 12/19/12.
//
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

// It is a way of saying that "LogoutUserDelegate" is declared elsewhere
// Define a protocol that has methods logout a user.
@protocol LogoutUserDelegate <NSObject>

// By default, methods are "required"; you can change this by prefacing methods with "@optional"
- (void) logoutUser;

@end

@interface UserMovieListTableViewController: UIViewController
<UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate> {
    IBOutlet UITableView *tv;
    ADBannerView *adBannerView;
    UIView *contentView;
}
@property (nonatomic, strong) NSString *userName;
@property (strong, nonatomic) id <LogoutUserDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITableView *tv;
@property (nonatomic, strong) ADBannerView *adBannerView;
@property (nonatomic, retain) IBOutlet UIView *contentView;

@end

