//
//  MovieObject.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieObject.h"

@implementation MovieObject

@synthesize id = _id;
@synthesize movieName = _movieName;
@synthesize thumbnail = _thumbnail;
@synthesize theater = _theater;
@synthesize audienceScore = _audienceScore;
@synthesize criticsScore = _criticsScore;
@synthesize cast = _cast;
@synthesize synopsis = _synopsis;
@synthesize runTime = _runTime;
@synthesize profileImage = _profileImage;
@synthesize trailer = _trailer;

-(MovieObject*)initWithMovieName:(NSString*)name withThumbnail:(NSString *)thumbnail
    withTheater:(NSString*)theater withAudienceScore:(NSString*)audienceScore
    withCriticsScore:(NSString*)criticsScore withRunTime:(NSString*)runTime
    withSynopsis:(NSString*)synopsis withCast:(NSString*)cast
    withProfileImage:(NSString *)profileImage withId: (NSString*)id
    withTrailer: (NSString*)trailer {
    self = [super init];
    if (self) {
        _movieName = name;
        _thumbnail = thumbnail;
        _theater = theater;
        _audienceScore = audienceScore;
        _criticsScore = criticsScore;
        _runTime = runTime;
        _synopsis = synopsis;
        _cast = cast;
        _profileImage = profileImage;
        _id = id;
        _trailer = trailer;
    }
    return self;
}

-(MovieObject*)initWithMovieObject:(MovieObject*)movieObject {
    self = [super init];
    if (self) {
        _movieName = movieObject.movieName;
        _thumbnail = movieObject.thumbnail;
        _theater = movieObject.theater;
        _audienceScore = movieObject.audienceScore;
        _criticsScore = movieObject.criticsScore;
        _runTime = movieObject.runTime;
        _synopsis = movieObject.synopsis;
        _cast = movieObject.cast;
        _profileImage = movieObject.profileImage;
        _id = movieObject.id;
        _trailer = movieObject.trailer;
    }
    return self;
}

@end
