//
//  SPTTrack.h
//  Basic Auth
//
//  Created by Daniel Kennett on 14/11/2013.
/*
 Copyright 2013 Spotify AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "SPTJSONDecoding.h"
#import "SPTPartialObject.h"
#import "SPTPartialAlbum.h"

/** Represents a "partial" track on the Spotify service. You can promote this
 to a full track object using `SPTRequest`. */
@interface SPTPartialTrack : NSObject <SPTJSONObject, SPTPartialObject>

///----------------------------
/// @name Properties
///----------------------------

/** The duration of the track. */
@property (nonatomic, readonly) NSTimeInterval duration;

/** The artists of the track, as `SPTPartialArtist` objects. */
@property (nonatomic, readonly, copy) NSArray *artists;

/** The album of the track. */
@property (nonatomic, readonly, strong) SPTPartialAlbum *album;

@end
