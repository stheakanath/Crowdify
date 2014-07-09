//
//  SPTPartialAlbum.h
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
#import "SPTPartialObject.h"
#import "SPTJSONDecoding.h"

@class SPTImage;

/** Represents a "partial" album on the Spotify service. You can promote this
 to a full album object using `SPTRequest`. */
@interface SPTPartialAlbum : NSObject <SPTPartialObject, SPTJSONObject>

///----------------------------
/// @name Properties
///----------------------------

/** Returns a list of album covers in various sizes, as `SPTImage` objects. */
@property (nonatomic, readonly, copy) NSArray *covers;

/** Convenience method that returns the smallest available cover image. */
@property (nonatomic, readonly) SPTImage *smallestCover;

/** Convenience method that returns the largest available cover image. */
@property (nonatomic, readonly) SPTImage *largestCover;

@end
