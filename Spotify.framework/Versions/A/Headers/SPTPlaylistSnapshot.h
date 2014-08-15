//
//  SPPlaylist.h
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
#import "SPTRequest.h"
#import "SPTTypes.h"

@class SPTPlaylistSnapshot;
@class SPTSession;
@class SPTUser;
@class SPTListPage;

/** The field indicating whether the playlist is public. */
FOUNDATION_EXPORT NSString * const SPTPlaylistSnapshotPublicKey;

/** The field indicating the name of the playlist. */
FOUNDATION_EXPORT NSString * const SPTPlaylistSnapshotNameKey;

typedef void (^SPTPlaylistMutationCallback)(NSError *error, SPTPlaylistSnapshot *playlist);

/** Represents a user's playlist on the Spotify service. */
@interface SPTPlaylistSnapshot : NSObject <SPTJSONObject, SPTTrackProvider>

///----------------------------
/// @name Requesting Playlists
///----------------------------

/** Request the playlist at the given Spotify URI.

 @note This method takes Spotify URIs in the form `spotify:*`, NOT HTTP URLs.

 @param uri The Spotify URI of the playlist to request.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistReadScope` or `SPTAuthPlaylistReadPrivateScope` scope as necessary.
 @param block The block to be called when the operation is complete. The block will pass a Spotify SDK metadata object on success, otherwise an error.
 */
+(void)playlistWithURI:(NSURL *)uri session:(SPTSession *)session callback:(SPTRequestCallback)block;

///----------------------------
/// @name Properties
///----------------------------

/** The name of the playlist. */
@property (nonatomic, readonly, copy) NSString *name;

/** The Spotify URI of the playlist. */
@property (nonatomic, readonly, copy) NSURL *uri;

/** `YES` if the playlist is collaborative (i.e., can be modified by anyone), otherwise `NO`. */
@property (nonatomic, readonly) BOOL isCollaborative;

/** `YES` if the playlist is public (i.e., can be seen by anyone), otherwise `NO`. */
@property (nonatomic, readonly) BOOL isPublic;

/** The playlist's owner. */
@property (nonatomic, readonly) SPTUser *owner;

/** The tracks of the playlist, as a page of `SPTPartialTrack` objects. */
@property (nonatomic, readonly) SPTListPage *firstTrackPage;

///----------------------------
/// @name Playlist Manipulation
///----------------------------

/** Append tracks to the playlist.

 @param tracks The tracks to add, as `SPTTrack` or `SPTPartialTrack` objects.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyPublicScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is complete. This block will pass an error if the operation failed, otherwise a new playlist snapshot reflecting the change.
 */
-(void)addTracksToPlaylist:(NSArray *)tracks withSession:(SPTSession *)session callback:(SPTPlaylistMutationCallback)block;

/** Set the tracks in a playlist, overwriting any tracks already in it

 @param tracks The tracks to set, as `SPTTrack` or `SPTPartialTrack` objects.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyPublicScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is complete. This block will pass an error if the operation failed, otherwise a new playlist snapshot reflecting the change.
 */
-(void)setTracksInPlaylist:(NSArray *)tracks withSession:(SPTSession *)session callback:(SPTPlaylistMutationCallback)block;

/** Change playlist details

 @param data The data to be changed. Use the key constants to refer to the field to change
 (e.g. `SPTPlaylistSnapshotNameKey`, `SPTPlaylistSnapshotPublicKey`). When passing boolean values, use @YES or @NO.
 @param session An authenticated session. Must be valid and authenticated with the
 `SPTAuthPlaylistModifyScope` or `SPTAuthPlaylistModifyPrivateScope` scope as necessary.
 @param block The block to be called when the operation is complete. This block will pass an error if the operation failed, otherwise a new playlist snapshot reflecting the change.
 */
-(void)changePlaylistDetails:(NSDictionary *)data
				 withSession:(SPTSession *)session
					callback:(SPTPlaylistMutationCallback)block;

@end
