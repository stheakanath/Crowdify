//
//  SPTTrackPlayer.h
//  Spotify iOS SDK
//
//  Created by Daniel Kennett on 20/02/14.
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
#import "SPTTypes.h"

/// Defines reasons for playback ending that aren't considered errors.
typedef NS_ENUM(NSUInteger, SPTPlaybackEndReason) {
	/// Playback ended for an unknown reason.
	SPTPlaybackEndReasonUnknown = 0,
	/// Playback ended because a new provider started playing.
	SPTPlaybackEndReasonStartedNewProvider,
	/// Playback ended because the player reached the end of the track list and repeat is not enabled.
	SPTPlaybackEndReasonEndOfTracks,
	/// Playback ended because the provider does not contain any playable tracks.
	SPTPlaybackEndReasonNoPlayableTracks,
	/// Playback ended because the playback session logged out.
	SPTPlaybackEndReasonLoggedOut
};

@protocol SPTTrackProvider;
@protocol SPTTrackPlayerDelegate;

@class SPTAudioStreamingController;
@class SPTSession;

/**
 This class ties together SPTAudioStreamingController and SPTCoreAudioController
 to provide a basic audio player. For more advanced playback setups, use the
 aforementioned classes directly.
 */
@interface SPTTrackPlayer : NSObject

///----------------------------
/// @name Initialisation and Setup
///----------------------------

/** Initialises a new track player.
 
 @warning Audio playback will not be available until `-[SPTTrackPlayer enablePlaybackWithSession:callback:]` is called.

 @param companyName Your company's name.
 @param appName Your application's name.
 @return Returns an intialised track player.
 @see -[SPTTrackPlayer enablePlaybackWithSession:callback:]
 */
-(id)initWithCompanyName:(NSString *)companyName appName:(NSString *)appName;

/** Initialises a new track player with the given `SPTAudioStreamingController`.
 
 @warning Audio playback will not be available until `-[SPTTrackPlayer enablePlaybackWithSession:callback:]` is called.
 
 @param streamingController The `SPTAudioStreamingController` instance to use for playback.
 @return Returns an intialised track player.
 @see -[SPTTrackPlayer enablePlaybackWithSession:callback:]

 */
-(id)initWithStreamingController:(SPTAudioStreamingController *)streamingController;

/** Attempts to enable playback with the given session.
 
 @param session The session to use for audio playback. Must be valid and authenticated with the 
 `SPTAuthStreamingScope` scope.
 @param block The block to call when playback is enabled (or not). If playback could not be enabled, 
 the block's `error` parameter will contain information.
 */
-(void)enablePlaybackWithSession:(SPTSession *)session callback:(SPTErrorableOperationCallback)block;

/** Returns the delegate of the track player. */
@property (nonatomic, weak) id <SPTTrackPlayerDelegate> delegate;

///----------------------------
/// @name Playback Control
///----------------------------

/** Play the given track provider from the given index.

 Playback of any current provider will be stopped and the given provider
 will be played from the given index.
 
 @param provider The track provider to play.
 @param index The index to start playback from. Must be in the range [0..`provider.tracks.count` - 1]
 */
-(void)playTrackProvider:(id <SPTTrackProvider>)provider fromIndex:(NSInteger)index;

/** Play the given track provider.

 Playback of any current provider will be stopped and the given provider
 will be played from the beginning.
 
 Equivalent to `-[SPTTrackPlayer playTrackProvider:provider fromIndex:0];`
 
 @param provider The track provider to play.
 @see -[SPTTrackPlayer playTrackProvider:fromIndex:]
 */
-(void)playTrackProvider:(id <SPTTrackProvider>)provider;

/** Skips playback to the next track. */
-(void)skipToNextTrack;

/** Skips playback to the previous track.
 
 The default behaviour of this method will restart the current track if
 playback is sufficiently progressed, matching the behaviour of most
 other media players.

 @param disallowSameTrackRestart If set to `YES`, playback will always be skipped 
 to the track prior to the current one, bypassing default behaviour to restart the current track.
 */
-(void)skipToPreviousTrack:(BOOL)disallowSameTrackRestart;

/** Seeks playback to the given location in the current track.
 
 @param offset The offset to seek to. Must be equal or less than the length of the currently playing track.
 */
-(void)seekToOffset:(NSTimeInterval)offset;

/** Pauses playback at the current position.

 If no track is playing, does nothing.
 */
-(void)pausePlayback;

/** Resumes playback from the currently paused position.
 
 If no track is playing, does nothing. 
 */
-(void)resumePlayback;

///----------------------------
/// @name Playback State
///----------------------------

/** Returns the track provider currently being used for playback. */
@property (nonatomic, strong, readonly) id <SPTTrackProvider> currentProvider;

/** Returns the index of the currently playing track in the current track provider, or `NSNotFound` if no track is playing. */
@property (nonatomic, readonly) NSInteger indexOfCurrentTrack;

/** Returns the current approximate playback position of the current track. */
@property (nonatomic, readonly) NSTimeInterval currentPlaybackPosition;

/** Returns `YES` if playback is paused, otherwise `NO`. */
@property (nonatomic, readonly) BOOL paused;

/** Returns `YES` if repeat is enabled, otherwise `NO`.
 
 If repeat is enabled, playback will loop back to the first track when
 the end of the last track is reached.
 */
@property (nonatomic) BOOL repeatEnabled;

/** Returns `YES` if audio playback is available, otherwise `NO`.
 
 If playback is not available, call `enablePlaybackWithSession:callback` with a valid
 session. If that session is authenticated and is allowed to play audio, playback will
 become available.
 
 @see -[SPTTrackPlayer enablePlaybackWithSession:callback:]
 */
@property (nonatomic, readonly) BOOL playbackIsAvailable;

@end

/** This protocol defines methods used by `SPTTrackPlayer` to inform delegates of playback events. */
@protocol SPTTrackPlayerDelegate <NSObject>

@optional

/** Called when a new track started playing.
 
 @param player The player that sent the message. 
 @param index The index of the new track in the given track provider.
 @param provider The provider playback is sourced from.
 */
-(void)trackPlayer:(SPTTrackPlayer *)player didStartPlaybackOfTrackAtIndex:(NSInteger)index ofProvider:(id <SPTTrackProvider>)provider;

/** Called when a track finished playing.

 @param player The player that sent the message.
 @param index The index of the outgoing track in the given track provider.
 @param provider The provider playback is sourced from.
 */
-(void)trackPlayer:(SPTTrackPlayer *)player didEndPlaybackOfTrackAtIndex:(NSInteger)index ofProvider:(id<SPTTrackProvider>)provider;

/** Called when a provider finished playing with a reason that is not considered an error.

 After this message is called, the track player that sent the message will no longer be playing music.

 @param player The player that sent the message.
 @param provider The provider playback was sourced from.
 @param reason The reason playback ended.
 */
-(void)trackPlayer:(SPTTrackPlayer *)player didEndPlaybackOfProvider:(id <SPTTrackProvider>)provider withReason:(SPTPlaybackEndReason)reason;

/** Called when a provider finished playing with an error.

 After this message is called, the track player that sent the message will no longer be playing music.

 @param player The player that sent the message.
 @param provider The provider playback was sourced from.
 @param error The error that caused playback to end.
 */
-(void)trackPlayer:(SPTTrackPlayer *)player didEndPlaybackOfProvider:(id <SPTTrackProvider>)provider withError:(NSError *)error;

/** Called when the track player recieved a message for the end user from the Spotify service.

 This string should be presented to the user in a reasonable manner.

 @param player The player that sent the message.
 @param message The message to display to the user.
 */
-(void)trackPlayer:(SPTTrackPlayer *)player didReceiveMessageForEndUser:(NSString *)message;

@end

