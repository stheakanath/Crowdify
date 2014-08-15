//
//  AppDelegate.m
//  Crowdify
//
//  Created by Sony Theakanath on 6/23/14.
//  Copyright (c) 2014 Sony Theakanath. All rights reserved.
//

#import "AppDelegate.h"
#import "PlaylistViewController.h"
#import <Spotify/Spotify.h>

static NSString * const kClientId = @"6f1f14410267442598d834882582dd65";
static NSString * const kCallbackURL = @"crowdify-iphone-app://callback";
static NSString * const kTokenSwapServiceURL = @"http://localhost:1234/swap";
static NSString * const kTokenRefreshServiceURL = @"http://localhost:1234/refresh";

static NSString * const kSessionUserDefaultsKey = @"SpotifySession";

PlaylistViewController *viewController;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    viewController = (PlaylistViewController *)self.window.rootViewController;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0]];
    [shadow setShadowOffset: CGSizeMake(0.0f, -1.0f)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSShadowAttributeName:shadow, NSFontAttributeName:[UIFont fontWithName:@"ProximaNova-Regular" size:18.0] };
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:23/255.0f green:23/255.0f blue:23/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self.window addSubview:self.navigationController.view];
    [[self.navigationController navigationBar] setTintColor:[UIColor whiteColor]];
    
    id sessionData = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionUserDefaultsKey];
    SPTSession *session = sessionData ? [NSKeyedUnarchiver unarchiveObjectWithData:sessionData] : nil;
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    if (session && [session isValid]) {
        [viewController addTheSession:session];
        [viewController handleNewSession:session];
    } else {
        NSURL *loginURL = [auth loginURLForClientId:kClientId
                                declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
                                             scopes:@[SPTAuthStreamingScope]
                                   withResponseType:@"token"];
        
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
        // This is the callback that'll be triggered when auth is completed (or fails).
        
        if (error != nil) {
            NSLog(@"*** Auth error: %@", error);
            return;
        }
        
        NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
        [[NSUserDefaults standardUserDefaults] setObject:sessionData
                                                  forKey:kSessionUserDefaultsKey];
        [viewController addTheSession:session];
        [viewController handleNewSession:session];
    };
    
    /*
     STEP 2: Handle the callback from the authentication service. -[SPAuth -canHandleURL:withDeclaredRedirectURL:]
     helps us filter out URLs that aren't authentication URLs (i.e., URLs you use elsewhere in your application).
     */
    
    if ([[SPTAuth defaultInstance] canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]]) {
        [[SPTAuth defaultInstance] handleAuthCallbackWithTriggeredAuthURL:url
                                                                 callback:authCallback];
        return YES;
    }
    
    return NO;
}



@end
