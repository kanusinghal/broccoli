//
//  MovieTrailerViewController.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 11/29/12.
//
//

#import <UIKit/UIKit.h>

@interface MovieTrailerViewController : UIViewController <UIWebViewDelegate>
	@property (retain, nonatomic) UIWebView *myWebView;
	@property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;
    @property (strong, nonatomic) NSString *trailer;
@end
