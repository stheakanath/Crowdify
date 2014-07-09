//
//  AppDelegate.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "AppDelegate.h"
#import <Spotify/Spotify.h>
#import "ViewController.h"

static NSString * const kClientId = @"6f1f14410267442598d834882582dd65";
static NSString * const kCallbackURL = @"crowdify-iphone-app://callback";
static NSString * const kTokenSwapServiceURL = @"http://localhost:1234/swap";
static NSString * const kTokenRefreshServiceURL = @"http://localhost:1234/refresh";

static NSString * const kSessionUserDefaultsKey = @"SpotifySession";

ViewController *viewController;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    viewController = (ViewController *)self.window.rootViewController;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.window addSubview:self.navigationController.view];
    [[self.navigationController navigationBar] setTintColor:[UIColor whiteColor]];
    
    id sessionData = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionUserDefaultsKey];
    SPTSession *session = sessionData ? [NSKeyedUnarchiver unarchiveObjectWithData:sessionData] : nil;
    SPTAuth *auth = [SPTAuth defaultInstance];
    if (session) {
        if ([session isValid]) {
            NSLog(@"%@", session.accessToken);
            [viewController addTheSession:session];
            [viewController handleNewSession:session];
        } else {
            NSLog(@"me");
            [auth renewSession:session withServiceEndpointAtURL:[NSURL URLWithString:kTokenRefreshServiceURL] callback:^(NSError *error, SPTSession *session) {
                if (error) {
                    NSLog(@"*** Error renewing session: %@", error);
                    return;
                }

                [viewController addTheSession:session];
                [viewController handleNewSession:session];
            }];
        }
    } else {
        NSURL *loginURL = [auth loginURLForClientId:kClientId
                                declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
                                             scopes:@[SPTAuthPlaylistModifyScope]];
        
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // If you open a URL during application:didFinishLaunchingWithOptions:, you
            // seem to get into a weird state.
            [[UIApplication sharedApplication] openURL:loginURL];
        });
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
        if (error != nil) {
            NSLog(@"*** Auth error: %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Your Spotify Ruby token handler is not set up locally! (Check Github for file) Therefore cannot advance to collaborative playlist screen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
        [[NSUserDefaults standardUserDefaults] setObject:sessionData forKey:kSessionUserDefaultsKey];
        [viewController addTheSession:session];
        [viewController handleNewSession:session];
    };
    
    if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url tokenSwapServiceEndpointAtURL:[NSURL URLWithString:kTokenSwapServiceURL] callback:authCallback];
        return YES;
    }
    return NO;
}

@end
