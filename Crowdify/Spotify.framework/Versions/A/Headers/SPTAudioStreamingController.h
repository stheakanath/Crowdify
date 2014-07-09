//
//  SPTAudioStreamingController.h
//  Spotify iOS SDK
//
//  Created by Daniel Kennett on 16/10/2013.
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
#import <CoreGraphics/CoreGraphics.h>
#import "SPTTypes.h"

typedef double SPTVolume;

/** The playback bitrates availabe. */
typedef NS_ENUM(NSUInteger, SPTBitrate) {
	/** The lowest bitrate. */
	SPTBitrateLow = 0,
	/** The normal bitrate. */
	SPTBitrateNormal = 1,
	/** The highest bitrate. */
	SPTBitrateHigh = 2,
};

FOUNDATION_EXPORT NSString * const SPTAudioStreamingMetadataTrackName;
FOUNDATION_EXPORT NSString * const SPTAudioStreamingMetadataTrackURI;
FOUNDATION_EXPORT NSString * const SPTAudioStreamingMetadataArtistName;
FOUNDATION_EXPORT NSString * const SPTAudioStreamingMetadataArtistURI;
FOUNDATION_EXPORT NSString * const SPTAudioStreamingMetadataAlbumName;
FOUNDATION_EXPORT NSString * const SPTAudioStreamingMetadataAlbumURI;
FOUNDATION_EXPORT NSString * const SPTAudioStreamingMetadataTrackDuration;

@class SPTSession;
@class SPTCoreAudioController;
@protocol SPTAudioStreamingDelegate;
@protocol SPTAudioStreamingPlaybackDelegate;

/// This class manages audio streaming from Spotify.
@interface SPTAudioStreamingController : NSObject

///----------------------------
/// @name Initialisation and Setup
///----------------------------

/** Initialise a new `SPAudioStreamingController`.
 
 @param companyName Your company name.
 @param appName Your application's name.
 @return Returns an initialised `SPAudioStreamingController` instance.
 */
-(id)initWithCompanyName:(NSString *)companyName appName:(NSString *)appName;

/** Initialise a new `SPAudioStreamingController`.

 This is the designated initialiser of this class.

 @param companyName Your company name.
 @param appName Your application's name.
 @param audioController An instance of SPTCoreAudioController to output audio to, or `nil` to use the default.
 @return Returns an initialised `SPAudioStreamingController` instance.
 */
-(id)initWithCompanyName:(NSString *)companyName appName:(NSString *)appName audioController:(SPTCoreAudioController *)audioController;

/** Log into the Spotify service for audio playback.
 
 Audio playback will not be available until the receiver is successfully logged in.
 
 @param session The session to log in with. Must be valid and authenticated with the
 `SPTAuthStreamingScope` scope.
 @param block The callback block to be executed when login succeeds or fails. In the cause of
 failure, an `NSError` object will be passed.
 */
-(void)loginWithSession:(SPTSession *)session callback:(SPTErrorableOperationCallback)block;

///----------------------------
/// @name Properties
///----------------------------

/** Returns `YES` if the receiver is logged into the Spotify service, otherwise `NO`. */
@property (nonatomic, readonly) BOOL loggedIn;

/** The receiver's delegate, which deals with session events such as login, logout, errors, etc. */
@property (nonatomic, weak) id <SPTAudioStreamingDelegate> delegate;

/** The receiver's playback delegate, which deals with audio playback events. */
@property (nonatomic, weak) id <SPTAudioStreamingPlaybackDelegate> playbackDelegate;

///----------------------------
/// @name Controlling Playback
///----------------------------

/** Set playback volume to the given level.

 @param volume The volume to change to, as a value between `0.0` and `1.0`.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 @see -volume
 */
-(void)setVolume:(SPTVolume)volume callback:(SPTErrorableOperationCallback)block;

/** Set the target streaming bitrate.
 
 The library will attempt to stream audio at the given bitrate. If the given
 bitrate is not available, the closest match will be used. This process is
 completely transparent, but you should be aware that data usage isn't guaranteed.
 
 @param bitrate The bitrate to target.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 */
-(void)setTargetBitrate:(SPTBitrate)bitrate callback:(SPTErrorableOperationCallback)block;

/** Seek playback to a given location in the current track.

 @param offset The time to seek to.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 @see -currentPlaybackPosition
 */
-(void)seekToOffset:(NSTimeInterval)offset callback:(SPTErrorableOperationCallback)block;

/** Set the "playing" status of the receiver.

 @param playing Pass `YES` to resume playback, or `NO` to pause it.
 @param block The callback block to be executed when the command has been
 received, which will pass back an `NSError` object if an error ocurred.
 @see -isPlaying
 */
-(void)setIsPlaying:(BOOL)playing callback:(SPTErrorableOperationCallback)block;

/** Play a track with the given Spotify URI.

 @param uri The URI of the track to play.
 @param block The callback block to be executed when the playback command has been
 received, which will pass back an `NSError` object if an error ocurred.
 @see -currentTrackMetadata
 */
-(void)playURI:(NSURL *)uri callback:(SPTErrorableOperationCallback)block;

///----------------------------
/// @name Playback State
///----------------------------

/** Returns basic metadata about the currently playing track, or `nil` if there is no track playing.
 
 Metadata is under the following keys:
 
 - `SPTAudioStreamingMetadataTrackName`: The track's name.
 - `SPTAudioStreamingMetadataTrackURI`: The track's Spotify URI.
 - `SPTAudioStreamingMetadataArtistName`: The track's artist's name.
 - `SPTAudioStreamingMetadataArtistURI`: The track's artist's Spotify URI.
 - `SPTAudioStreamingMetadataAlbumName`: The track's album's name.
 - `SPTAudioStreamingMetadataAlbumURI`: The track's album's URI.
 - `SPTAudioStreamingMetadataTrackDuration`: The track's duration as an `NSTimeInterval` boxed in an `NSNumber`.

 */
@property (nonatomic, readonly, copy) NSDictionary *currentTrackMetadata;

/** Returns `YES` if the receiver is playing audio, otherwise `NO`. */
@property (nonatomic, readonly) BOOL isPlaying;

/** Returns `YES` if repeat is on, otherwise `NO`. */
@property (nonatomic, readonly) SPTVolume volume;

/** Returns `YES` if the receiver expects shuffled playback, otherwise `NO`. */
@property (nonatomic, readonly) BOOL shuffle;

/** Returns `YES` if the receiver expects repeated playback, otherwise `NO`. */
@property (nonatomic, readonly) BOOL repeat;

/** Returns the current approximate playback position of the current track. */
@property (nonatomic, readonly) NSTimeInterval currentPlaybackPosition;

@end


/// Defines events relating to the connection to the Spotify service.
@protocol SPTAudioStreamingDelegate <NSObject>

@optional

/** Called when the streaming controller logs in successfully.
 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidLogin:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller logs out.
 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidLogout:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller encounters a temporary connection error.
 
 You should not throw an error to the user at this point. The library will attempt to reconnect without further action.

 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidEncounterTemporaryConnectionError:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller encounters a fatal error.
 
 At this point it may be appropriate to inform the user of the problem.

 @param audioStreaming The object that sent the message.
 @param error The error that occurred.
 */
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didEncounterError:(NSError *)error;

/** Called when the streaming controller recieved a message for the end user from the Spotify service.

 This string should be presented to the user in a reasonable manner.

 @param audioStreaming The object that sent the message.
 @param message The message to display to the user.
 */
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didReceiveMessage:(NSString *)message;

@end


/// Defines events relating to audio playback.
@protocol SPTAudioStreamingPlaybackDelegate <NSObject>

@optional

/** Called when playback status changes.
 @param audioStreaming The object that sent the message.
 @param isPlaying Set to `YES` if the object is playing audio, `NO` if it is paused.
 */
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangePlaybackStatus:(BOOL)isPlaying;

/** Called when playback is seeked "unaturally" to a new location.
 @param audioStreaming The object that sent the message.
 @param offset The new playback location.
 */
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didSeekToOffset:(NSTimeInterval)offset;

/** Called when playback volume changes.
 @param audioStreaming The object that sent the message.
 @param volume The new volume.
 */
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeVolume:(SPTVolume)volume;

/** Called when shuffle status changes.
 @param audioStreaming The object that sent the message.
 @param isShuffled Set to `YES` if the object requests shuffled playback, otherwise `NO`.
 */
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeShuffleStatus:(BOOL)isShuffled;

/** Called when repeat status changes.
 @param audioStreaming The object that sent the message.
 @param isRepeated Set to `YES` if the object requests repeated playback, otherwise `NO`.
 */
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeRepeatStatus:(BOOL)isRepeated;

/** Called when playback moves to a new track.
 @param audioStreaming The object that sent the message.
 @param trackMetadata Metadata for the new track. See -currentTrackMetadata for keys.
 */
-(void)audioStreaming:(SPTAudioStreamingController *)audioStreaming didChangeToTrack:(NSDictionary *)trackMetadata;

/** Called when the audio streaming object requests playback skips to the next track.
 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidSkipToNextTrack:(SPTAudioStreamingController *)audioStreaming;

/** Called when the audio streaming object requests playback skips to the previous track.
 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidSkipToPreviousTrack:(SPTAudioStreamingController *)audioStreaming;

/** Called when the audio streaming object becomes the active playback device on the user's account.
 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidBecomeActivePlaybackDevice:(SPTAudioStreamingController *)audioStreaming;

/** Called when the audio streaming object becomes an inactive playback device on the user's account.
 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidBecomeInactivePlaybackDevice:(SPTAudioStreamingController *)audioStreaming;

/** Called when the streaming controller lost permission to play audio.

 This typically happens when the user plays audio from their account on another device.

 @param audioStreaming The object that sent the message.
 */
-(void)audioStreamingDidLosePermissionForPlayback:(SPTAudioStreamingController *)audioStreaming;

@end
