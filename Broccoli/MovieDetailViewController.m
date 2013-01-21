//
//  MovieDetailViewController.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "MovieDetailViewController.h"
#import "APIController.h"
#import "Helpers.h"
#import "JSON.h"
#import "MovieObject.h"
#import "MovieTrailerViewController.h"

@interface MovieDetailViewController ()
    @property (strong, nonatomic) APIController *listAPIController;
    @property BOOL isHideAddButton;
@end

@implementation MovieDetailViewController

@synthesize movie = _movie;
@synthesize userName = _userName;
@synthesize listAPIController = _listAPIController;
@synthesize delegate = _delegate;
@synthesize isHideAddButton = _isHideAddButton;
// UI Elements
@synthesize movieTitle = _movieTitle;
@synthesize profileImageView = _profileImageView;
@synthesize castLabel = _castLabel;
@synthesize movieSynopsis = _movieSynopsis;
@synthesize theaterLabel = _theaterLabel;
@synthesize addButton = _addButton;
@synthesize trailerButton = _trailerButton;
@synthesize scrollView = _scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isHideAddButton) {
        _addButton.hidden = YES; 
    } else {
        [self configureButtonUI:_addButton];
    }
    
    [self configureButtonUI:_trailerButton];
    
    // Do any additional setup after loading the view.
    [_scrollView setScrollEnabled: TRUE];
    [_scrollView setContentSize: CGSizeMake(320, 700)];
    [self configureView];
}

- (void) configureButtonUI:(UIButton*) button
{
    // Set the button Text Color
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    // Set default backgrond color
    UIColor *backGroundColor =
        [UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:1];
    [button setBackgroundColor:backGroundColor];
    
    // Add Custom Font
    [[button titleLabel] setFont:[UIFont fontWithName:@"Knewave" size:18.0f]];
    
    // Draw a custom gradient
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = button.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor],
                          (id)[[UIColor colorWithRed:51.0f / 255.0f green:51.0f / 255.0f blue:51.0f / 255.0f alpha:1.0f] CGColor],
                          nil];
    [button.layer insertSublayer:btnGradient atIndex:0];
    
    // Round button corners
    CALayer *btnLayer = [button layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];
    
    // Apply a 1 pixel, black border around Buy Button
    [btnLayer setBorderWidth:1.0f];
    [btnLayer setBorderColor:[[UIColor blackColor] CGColor]];
}

- (void)viewDidUnload
{
    [_scrollView release];
    _scrollView = nil;
    [_addButton release];
    _addButton = nil;
    [_trailerButton release];
    _trailerButton = nil;
    [_movieTitle release];
    _movieTitle = nil;
    [_profileImageView release];
    _profileImageView = nil;
    [_castLabel release];
    _castLabel = nil;
    [_movieSynopsis release];
    _movieSynopsis = nil;
    [_theaterLabel release];
    _theaterLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)showTrailer:(id)sender {
    UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"BroccoliStoryboard" bundle:nil];
    MovieTrailerViewController *mtController =
        [storyboard instantiateViewControllerWithIdentifier:@"showTrailerView"];
    mtController.trailer = _movie.trailer;
    [self.navigationController pushViewController:mtController animated:YES];
}

- (void) hideAddButton {
    _isHideAddButton = true;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setMovie:(MovieObject *) selectedMovie
{
    _movie = [[MovieObject alloc] init];
    [_movie initWithMovieObject: selectedMovie];
        
    // Update the view.
    [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    MovieObject *theMovie = [[[MovieObject alloc] init] autorelease];
    [theMovie initWithMovieObject:_movie];
    
    if (theMovie) {
        _movieTitle.text = theMovie.movieName;
        _theaterLabel.text = theMovie.theater;
        NSURL *imageURL = [NSURL URLWithString:theMovie.profileImage];
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        _profileImageView.image = [[UIImage alloc] initWithData:data];
        
        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        _castLabel.text = theMovie.cast;
        UIFont *castLabelFont = [UIFont fontWithName:@"Verdana" size:13.0];
        CGSize castLabelSize =
            [theMovie.cast sizeWithFont:castLabelFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        _castLabel.frame = CGRectMake(_castLabel.frame.origin.x, _castLabel.frame.origin.y,
            castLabelSize.width, castLabelSize.height);
        
        UIFont *synopsisLabelFont = [UIFont fontWithName:@"Verdana" size:13.0];
        CGSize synopsisLabelSize =
            [theMovie.synopsis sizeWithFont:synopsisLabelFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        _movieSynopsis.text = theMovie.synopsis;
        _movieSynopsis.frame = CGRectMake(
            _movieSynopsis.frame.origin.x, _movieSynopsis.frame.origin.y,
            synopsisLabelSize.width, synopsisLabelSize.height);
    }
}

- (IBAction)addMovieToUserList:(id)sender {
    // Store the selected movie to user list in the AppEngine.
    NSString *storeItemUrl = @"http://dealsaggregatorengine.appspot.com";
    NSURL *URL =
        [NSURL URLWithString:[NSString stringWithFormat:@"%@/storeitem", storeItemUrl]];
    
    NSMutableDictionary *postDictionary = [NSMutableDictionary dictionary];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _userName] forKey:@"userName"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.movieName] forKey:@"title"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.thumbnail] forKey:@"thumbnail"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.theater] forKey:@"theater"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.audienceScore] forKey:@"audienceScore"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.criticsScore] forKey:@"criticsScore"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.runTime] forKey:@"runTime"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.cast] forKey:@"cast"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.synopsis] forKey:@"synopsis"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.profileImage] forKey:@"profileImage"];
    [postDictionary setObject:[NSString stringWithFormat:@"%@", _movie.trailer] forKey:@"trailer"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];	
    [request setHTTPMethod:@"POST"];
    
    NSLog(@"posting %@", [postDictionary urlQueryString]);
    [request setHTTPBody:[[postDictionary urlQueryString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (!_listAPIController) {
        _listAPIController = [[[APIController alloc] init] autorelease];		
    }
    [_listAPIController connectWithRequest:request target:self selector:@selector(finishList:)];
}

- (void) finishList:(NSString *) resultString {
	if (!resultString) {
		UIAlertView *alertView = [[[UIAlertView alloc]
								   initWithTitle:@"Network problem"
								   message:@"The connection to our server failed."
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
		[alertView show];
	} else {
		id result = [resultString JSONValue];
		NSLog(@"got result %@", [result description]);
        
		id status = [result objectForKey:@"status"];
        id storedId = [result objectForKey:@"storedItemId"];
        NSLog(@"Status %@", status);
		if ([status intValue] == 200) { // success
            // Send a message to the delegate
            // Pass on the new item text that the user entered
            MovieObject *obj = [[MovieObject alloc] init];
            [obj initWithMovieName:_movie.movieName withThumbnail:_movie.thumbnail 
                       withTheater:_movie.theater withAudienceScore: _movie.audienceScore
                  withCriticsScore:_movie.criticsScore withRunTime:_movie.runTime
                      withSynopsis:_movie.synopsis
                          withCast:_movie.cast
                       withProfileImage:_movie.profileImage
                    withId:[[NSString alloc] initWithString:storedId]
                    withTrailer:[[NSString alloc] initWithString:_movie.trailer]];
            
            [_delegate didAddNewItem:obj];	
		} else {
			UIAlertView *alertView = [[[UIAlertView alloc]
									   initWithTitle:@"Problem"
									   message:[result objectForKey:@"message"]
									   delegate:nil
									   cancelButtonTitle:@"OK"
									   otherButtonTitles:nil] autorelease];
			[alertView show];			
		}
	}
}

- (void)dealloc {
    [_movie dealloc];
    //[_userName dealloc];
    [super dealloc];
}

@end
