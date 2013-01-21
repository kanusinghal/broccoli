//
//  MovieInfoService.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieInfoService.h"
#import "MovieObject.h"
#import "MovieListingTableViewController.h"

@interface MovieInfoService()
@end

@implementation MovieInfoService

@synthesize userList = _userList;

+ (id)instance {
    static MovieInfoService *movieInfoService = nil;
    @synchronized(self) {
        // Fetch user movie list data from app engine task.
        if (movieInfoService == nil) {
            movieInfoService = [[self alloc] init];
        }
    }
    return movieInfoService;
}

- (id)init {
    self = [super init];
    if (self) {
        _userList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_userList dealloc];
    [super dealloc];
}

- (void) addMovieToUserList: (MovieObject*) movieObject {
    [_userList addObject:movieObject];
}

- (void) removeMovieFromUserList: (NSUInteger) index {
    [_userList removeObjectAtIndex:index];
}

- (void) addMovieToUserListAtIndex: (MovieObject*) movieObject index: (NSUInteger) index {
    [_userList insertObject:movieObject atIndex:index];
}

- (void) addMoviesToUserList: (NSArray*) movieObjects {
    [_userList addObjectsFromArray:movieObjects];
}

- (NSArray*) getUserList {
    return _userList;
}

- (void) clearUserList {
    _userList = [[NSMutableArray alloc] init];
}

@end
