//
//  MovieListingTableViewController.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieListingTableViewController.h"
#import "MovieDetailViewController.h"
#import "MovieInfoService.h"
#import "MovieObject.h"
#import "SimpleTableCell.h"
#import "APIController.h"
#import "Helpers.h"
#import "JSON.h"
#import "MovieObject.h"

@interface MovieListingTableViewController ()
    @property (nonatomic, strong) NSMutableData *responseData;
    @property (nonatomic, strong) NSMutableArray *movies;
    @property (nonatomic, strong) MovieInfoService *movieService;
    @property (nonatomic, strong) UIActivityIndicatorView *spinner;
    @property (nonatomic, strong) APIController *listAPIController;
@end

@implementation MovieListingTableViewController

@synthesize userName = _userName;
@synthesize responseData = _responseData;
@synthesize movies = _movies;
@synthesize movieService = _movieService;
@synthesize listAPIController = _listAPIController;
@synthesize delegate = _delegate;

// UI Elements
@synthesize searchBar = _searchBar;
@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the title
    self.navigationItem.title = @"Search For Movies";
    // Set the background color of nav bar.
    UIColor *backGroundColor =
        [UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:1];
    [self.navigationController.navigationBar setTintColor: backGroundColor];
    //Add the search bar
    float w = UIScreen.mainScreen.bounds.size.width;
    _searchBar = [[UISearchBar alloc]
                 initWithFrame:CGRectMake(0.0f, 0.0f, w, 44.0f)];
    [_searchBar setTintColor: backGroundColor];
    self.tableView.tableHeaderView = _searchBar;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"Search movie info online...";
    
    UIButton *iButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [iButton addTarget:self action:@selector(logoutUser:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *logoutButton = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"sign-out.png"] style:UIBarButtonItemStyleDone target:self action:@selector(logoutUser:)] autorelease];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    
    // Local copy of user movie list.
    _movies = [[NSMutableArray alloc] initWithObjects:nil];
    
    // Singleton class, keeping track of the most recent/upto date
    // user movie list.
    _movieService = [MovieInfoService instance];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_searchBar release];
    _searchBar = nil;
    [_spinner release];
    _spinner = nil;
    [super viewDidUnload];
}

- (IBAction)logoutUser:(id)sender {
    [_delegate logoutUser];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([_searchBar.text isEqualToString:@""]) {
        //Clear stuff here
        _movies = [[NSMutableArray alloc] initWithObjects:nil];
        [self.tableView reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    if ([_searchBar.text isEqualToString:@""]) {
        //Clear stuff here
        _movies = [[NSMutableArray alloc] initWithObjects:nil];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //_searchBar.text=@"";
    
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    [_spinner stopAnimating];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarButton {
    // Start with a clean copy of user search movie list.
    _movies = [[NSMutableArray alloc] initWithObjects:nil];
    
    // Replace the spaces in the search string with '+'
    // to be passed to the search server.
    NSString *searchString=
        [searchBarButton.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    // Show the spinner while the query returns.
    [self showSpinner];
    
    // Make the search api call.
    // Load the search results screen.
    NSString *url = [NSString stringWithFormat:
                     @"http://dealsaggregatorengine.appspot.com/deals?search=%@",
                     searchString];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:url]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    NSURLConnection *theConnection =
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (theConnection) {
        self.responseData = [[NSMutableData data] retain];
    } else {
        // Unable to establish connection. Do nothing!
        // This will end up in showing an empty list to the user.
    }
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
        NSString *trailer =
            [[NSString alloc] initWithString:[result objectForKey:@"trailer"]];
        
        [obj initWithMovieName:movieName withThumbnail:thumbnail 
                   withTheater:theater withAudienceScore: audienceScore
                   withCriticsScore:criticsScore withRunTime:runTime withSynopsis:synopsis
                      withCast:cast withProfileImage:profileImage withId:@""
                withTrailer:trailer];
        
        [_movies addObject:obj];
    }
    // Add movie list fetched from the server
    // to the Singleton User movie list.
    [_spinner stopAnimating];
    [self searchBarCancelButtonClicked:_searchBar];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    dvController.userName = _userName;
    dvController.delegate = self;
    [self.navigationController pushViewController:dvController animated:YES];
    
}

// DELEGATE METHOD - handle the message from the MovieDetailViewController
- (void) didAddNewItem:(MovieObject *)newItem {
    
	// Handle the incoming data/object
	if (newItem) {
        [_movieService addMovieToUserList:newItem];
        // Alert message saying item added.
        UIAlertView *alertView = [[[UIAlertView alloc]
								   initWithTitle:@"Movie Added"
								   message:@"Movie added to you list!"
								   delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (void)dealloc {
    [_movies dealloc];
    [super dealloc];
}

@end
