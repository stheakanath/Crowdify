//
//  PageContentViewController.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "PageContentViewController.h"
#import "AppDelegate.h"
#import <Spotify/Spotify.h>

@interface PageContentViewController ()

@end

@implementation PageContentViewController

static NSString * const kClientId = @"6f1f14410267442598d834882582dd65";
static NSString * const kCallbackURL = @"crowdify-iphone-app://callback";
static NSString * const kTokenSwapServiceURL = @"http://localhost:1234/swap";
static NSString * const kTokenRefreshServiceURL = @"http://localhost:1234/refresh";

static NSString * const kSessionUserDefaultsKey = @"SpotifySession";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.clickButton = [[SpotifyButton alloc] initWithFrame:CGRectMake(60.0, 370.0, 200.0, 40.0)];
    [self.clickButton setTitle:@"Please Wait..." forState:UIControlStateNormal];
    [self.clickButton setEnabled:NO];
    //[self.clickButton addTarget:self action:@selector(linkspotify:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clickButton];
    self.view.backgroundColor = [UIColor blackColor];
}

/*-(IBAction)linkspotify:(id)sender {
    id sessionData = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionUserDefaultsKey];
    SPTSession *session = sessionData ? [NSKeyedUnarchiver unarchiveObjectWithData:sessionData] : nil;
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (session) {
        if ([session isValid]) {
            [self enableAudioPlaybackWithSession:session];
        } else {
            [auth renewSession:session withServiceEndpointAtURL:[NSURL URLWithString:kTokenRefreshServiceURL] callback:^(NSError *error, SPTSession *session) {
                if (error) {
                    NSLog(@"*** Error renewing session: %@", error);
                    return;
                }
                
                [self enableAudioPlaybackWithSession:session];
            }];
        }
    } else {
        NSURL *loginURL = [auth loginURLForClientId:kClientId
                                declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
                                             scopes:@[SPTAuthStreamingScope]];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // If you open a URL during application:didFinishLaunchingWithOptions:, you
            // seem to get into a weird state.
            [[UIApplication sharedApplication] openURL:loginURL];
        });
    }

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
        // This is the callback that'll be triggered when auth is completed (or fails).
        
        if (error != nil) {
            NSLog(@"*** Auth error: %@", error);
            return;
        }
        
        NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
        [[NSUserDefaults standardUserDefaults] setObject:sessionData
                                                  forKey:kSessionUserDefaultsKey];
        [self enableAudioPlaybackWithSession:session];
    };
    
 
     STEP 2: Handle the callback from the authentication service. -[SPAuth -canHandleURL:withDeclaredRedirectURL:]
     helps us filter out URLs that aren't authentication URLs (i.e., URLs you use elsewhere in your application).
     
     Make the token swap endpoint URL matches your auth service URL.
 
    
  if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url
                                            tokenSwapServiceEndpointAtURL:[NSURL URLWithString:kTokenSwapServiceURL]
                                                                 callback:authCallback];
        return YES;
    }
    
    return NO;

}*/


-(void)enableAudioPlaybackWithSession:(SPTSession *)session {
    NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sessionData forKey:kSessionUserDefaultsKey];
    [userDefaults synchronize];
}

@end
