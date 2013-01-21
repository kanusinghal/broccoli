//
//  MovieTrailerViewController.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 11/29/12.
//
//

#import "MovieTrailerViewController.h"

@interface MovieTrailerViewController ()

@end

@implementation MovieTrailerViewController
@synthesize myWebView = _myWebView;
@synthesize activityIndicator = _activityIndicator;
@synthesize trailer = _trailer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = contentView;
    
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	webFrame.origin.y = 0.0f;
	_myWebView = [[UIWebView alloc] initWithFrame:webFrame];
	_myWebView.backgroundColor = [UIColor blueColor];
	_myWebView.scalesPageToFit = YES;
	_myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	_myWebView.delegate = self;
	[self.view addSubview: _myWebView];
	[_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_trailer]]];
    
	_activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	_activityIndicator.center = self.view.center;
	[self.view addSubview: _activityIndicator];
}

- (void)viewDidUnload {
    [_activityIndicator release];
    _activityIndicator = nil;
	[_myWebView release];
    _myWebView = nil;
    [super viewDidUnload];
}

#pragma mark WEBVIEW Methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[_activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><br /><br /><font size=+5 color='red'>Error<br /><br />Your request %@</font></center></html>",
							 error.localizedDescription];
	[_myWebView loadHTMLString:errorString baseURL:nil];
}

- (void)dealloc {
    [_myWebView release];
    [super dealloc];
}
@end
