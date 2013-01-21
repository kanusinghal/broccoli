//
//  MovieObject.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieObject : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *profileImage;
@property (nonatomic, copy) NSString *theater;
@property (nonatomic, copy) NSString *audienceScore;
@property (nonatomic, copy) NSString *criticsScore;
@property (nonatomic, copy) NSString *runTime;
@property (nonatomic, copy) NSString *synopsis;
@property (nonatomic, copy) NSString *cast;
@property (nonatomic, copy) NSString *trailer;

-(id)initWithMovieName:(NSString*)name withThumbnail:(NSString*)thumbnail
    withTheater:(NSString*)theater withAudienceScore:(NSString*)audienceScore
    withCriticsScore:(NSString*)criticsScore withRunTime:(NSString*)runTime
    withSynopsis:(NSString*)synopsis withCast:(NSString*)cast
    withProfileImage: (NSString*)profileImage withId: (NSString*)id
    withTrailer: (NSString*)trailer;

-(id)initWithMovieObject:(MovieObject*) movieObject;

@end
