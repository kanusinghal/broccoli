//
//  MovieInfoService.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieObject.h"

@interface MovieInfoService : NSObject {
    NSMutableArray *userList;
    NSMutableArray *movies;
}

@property (nonatomic, copy)NSMutableArray *userList;

+(MovieInfoService*)instance;
- (void) addMovieToUserList: (MovieObject*) movieObject;
- (void) addMoviesToUserList: (NSArray*) movieObjects;
- (void) removeMovieFromUserList: (NSUInteger) index;
- (void) addMovieToUserListAtIndex: (MovieObject*) movieObject index: (NSUInteger) index;
- (NSArray*) getUserList;
- (void) clearUserList;

@end
