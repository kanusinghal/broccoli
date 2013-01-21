//
//  UserMovieListTableViewController.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserMovieListTableViewController.h"
#import "MovieDetailViewController.h"
#import "MovieInfoService.h"
#import "MovieObject.h"
#import "SimpleTableCell.h"
#import "APIController.h"
#import "Helpers.h"
#import "JSON.h"
#import "MovieObject.h"

@interface UserMovieListTableViewController ()
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) MovieInfoService *movieService;
@property (nonatomic, strong) APIController *listAPIController;
@property (nonatomic, strong) NSNumber *indexToDelete;
@property (nonatomic, strong) MovieObject *objToDelete;
@end

@implementation UserMovieListTableViewController

@synthesize responseData = _responseData;
@synthesize movies = _movies;
@synthesize movieService = _movieService;
@synthesize listAPIController = _listAPIController;
@synthesize indexToDelete = _indexToDelete;
@synthesize objToDelete = _objToDelete;
@synthesize userName = _userName;
@synthesize delegate = _delegate;
@synthesize tv = _tv;
@synthesize adBannerView = _adBannerView;
@synthesize contentView = _contentView;

// UI Elements
@synthesize spinner = _spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"View Refreshed");
    // Local copy of user movie list.
    _movies = [[NSMutableArray alloc] initWithObjects:nil];
    for (MovieObject* obj in [_movieService getUserList]) {
        [_movies addObject:obj];
    }
    [_tv reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the title
    self.navigationItem.title = @"Movies";
    // Set the background color of nav bar.
    UIColor *backGroundColor =
    [UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:1];
    [self.navigationController.navigationBar setTintColor: backGroundColor];
    
    UIButton *iButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [iButton addTarget:self action:@selector(logoutUser:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sign-out.png"] style:UIBarButtonItemStyleDone target:self action:@selector(logoutUser:)] autorelease];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    
    // Local copy of user movie list.
    _movies = [[NSMutableArray alloc] initWithObjects:nil];
    // Singleton class, keeping track of the most recent/upto date
    // user movie list.
    _movieService = [MovieInfoService instance];
    
    // Load the user list.
    // Show the spinner, while the user movie list
    // is being fetched.
    [self showSpinner];
    NSString *url = [NSString stringWithFormat:
                     @"http://dealsaggregatorengine.appspot.com/fetch?userName=%@",
                     _userName];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    // An NSURLConnections created with the
    // -initWithRequest:delegate:
    // methods are scheduled on the current runloop immediately.
    NSURLConnection *theConnection =
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        self.responseData = [[NSMutableData data] retain];
    } else {
        // Unable to establish connection. Do nothing!
        // This will end up in showing an empty list to the user.
    }
    [self createAdBannerView];
    [self.view addSubview:_adBannerView];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_spinner release];
    _spinner = nil;
    [super viewDidUnload];
}

- (IBAction)logoutUser:(id)sender {
    [_delegate logoutUser];
}

- (void) showSpinner {
    // Show the Activity Spinner while we search for movies
    // matching user query.
    _spinner = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = _spinner.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
    [_spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    _spinner.frame = frame;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    [_spinner release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *error = nil;
    NSDictionary *res = [NSJSONSerialization
                         JSONObjectWithData:self.responseData
                         options:NSJSONReadingMutableLeaves
                         error:&error];
    // extract specific value...
    NSArray *results = [res objectForKey:@"movies"];
    for (NSDictionary *result in results) {
        MovieObject *obj = [[[MovieObject alloc] init] autorelease];
        NSString *movieName =
        [[NSString alloc] initWithString:[result objectForKey:@"title"]];
        NSString *thumbnail =
        [[NSString alloc] initWithString:[result objectForKey:@"thumbnail"]];
        NSString *theater =
        [[NSString alloc] initWithString:[result objectForKey:@"theater"]];
        NSString *audienceScore =
        [[NSString alloc] initWithString:[result objectForKey:@"audienceScore"]];
        NSString *criticsScore =
        [[NSString alloc] initWithString:[result objectForKey:@"criticsScore"]];
        NSString *runTime =
        [[NSString alloc] initWithString:[result objectForKey:@"runTime"]];
        NSString *synopsis =
        [[NSString alloc] initWithString:[result objectForKey:@"synopsis"]];
        NSString *cast =
        [[NSString alloc] initWithString:[result objectForKey:@"cast"]];
        NSString *profileImage =
        [[NSString alloc] initWithString:[result objectForKey:@"profileImage"]];
        NSString *id =
        [[NSString alloc] initWithString:[result objectForKey:@"id"]];
        NSString *trailer =
        [[NSString alloc] initWithString:[result objectForKey:@"trailer"]];
        
        [obj initWithMovieName:movieName withThumbnail:thumbnail
                   withTheater:theater withAudienceScore: audienceScore
              withCriticsScore:criticsScore withRunTime:runTime withSynopsis:synopsis
                      withCast:cast withProfileImage:profileImage withId:id
                   withTrailer:trailer];
        
        [_movies addObject:obj];
    }
    // Add movie list fetched from the server
    // to the Singleton User movie list.
    [_movieService addMoviesToUserList:_movies];
    [_spinner stopAnimating];
    
    [_tv reloadData];
}

- (void) createAdBannerView
{
    _adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    CGRect bannerFrame = _adBannerView.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    _adBannerView.frame = bannerFrame;
    
    _adBannerView.delegate = self;
    _adBannerView.requiredContentSizeIdentifiers =
    [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self adjustBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self adjustBannerView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void) adjustBannerView
{
    CGRect contentViewFrame = self.view.bounds;
    CGRect adBannerFrame = _adBannerView.frame;
    
    if([_adBannerView isBannerLoaded])
    {
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:_adBannerView.currentContentSizeIdentifier];
        contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    else
    {
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    [UIView animateWithDuration:0.5 animations:^{
        _adBannerView.frame = adBannerFrame;
        _contentView.frame = contentViewFrame;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_movies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    MovieObject *movieObj = [_movies objectAtIndex:indexPath.row];
    cell.titleLabel.text = movieObj.movieName;
    NSURL *imageURL = [NSURL URLWithString:movieObj.thumbnail];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    cell.thumbnailImageView.image = [[UIImage alloc] initWithData:data];
    cell.theaterLabel.text = movieObj.theater;
    cell.audienceRating.text = movieObj.audienceScore;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MovieObject *movieObj = [_movies objectAtIndex:indexPath.row];
        NSString *url = [NSString stringWithFormat:
                         @"http://dealsaggregatorengine.appspot.com/delete?id=%@",
                         movieObj.id];
        NSURL *URL = [NSURL URLWithString:url];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"GET"];
        
        
        _listAPIController = [[[APIController alloc] init] autorelease];
		_indexToDelete = [NSNumber numberWithInt: indexPath.row];
        [_listAPIController connectWithRequest:request target:self selector:@selector(finishDelete:)];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
        _objToDelete = [_movies objectAtIndex:[_indexToDelete integerValue]];
        [_movieService removeMovieFromUserList:[_indexToDelete integerValue]];
        [_movies removeAllObjects];
        [_movies addObjectsFromArray:[_movieService userList]];
        [tableView endUpdates];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 88;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Show the Movie Detail view when a movie is selectet.
    UIStoryboard *storyboard =
    [UIStoryboard storyboardWithName:@"BroccoliStoryboard" bundle:nil];
    MovieDetailViewController *dvController =
    [storyboard instantiateViewControllerWithIdentifier:@"movieDetailView"];
    dvController.movie = [_movies objectAtIndex:indexPath.row];
    [dvController hideAddButton];
    [self.navigationController pushViewController:dvController animated:YES];
    
}

- (void) finishDelete:(NSString *) resultString {
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
        NSLog(@"Status %@", status);
		if ([status intValue] == 200) { // success
		} else {
			UIAlertView *alertView = [[[UIAlertView alloc]
									   initWithTitle:@"Problem"
									   message:[result objectForKey:@"message"]
									   delegate:nil
									   cancelButtonTitle:@"OK"
									   otherButtonTitles:nil] autorelease];
			[alertView show];
            if (_objToDelete != NULL) {
                [_tv beginUpdates];
                [_tv insertRowsAtIndexPaths:[NSArray arrayWithObjects:_indexToDelete, nil]
                           withRowAnimation:UITableViewRowAnimationFade];
                [_movieService addMovieToUserListAtIndex:_objToDelete index:[_indexToDelete integerValue]];
                [_movies removeAllObjects];
                [_movies addObjectsFromArray:[_movieService userList]];
                [_tv endUpdates];
            }
		}
	}
}

- (void)dealloc {
    [_userName dealloc];
    [_movies dealloc];
    [_movieService dealloc];
    [super dealloc];
}

@end
