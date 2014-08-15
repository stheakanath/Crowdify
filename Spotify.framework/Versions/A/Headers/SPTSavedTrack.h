//
//  SPTSavedTrack.h
//  Spotify iOS SDK
//
//  Created by Jose Manuel Perez on 08/08/14.
//  Copyright (c) 2014 Spotify AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTTrack.h"

/** This class represents a track in the Your Music Library. */
@interface SPTSavedTrack : SPTTrack <SPTJSONObject>

///----------------------------
/// @name Properties
///----------------------------

/** The date when the track was saved. */
@property (nonatomic, readonly, copy) NSDate *addedAt;

@end
