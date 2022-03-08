//
//  AppDelegate.m
//  PollfishMaxAdapterExampleObjC
//
//  Created by Fotis Mitropoulos on 21/2/22.
//

#import "AppDelegate.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ALSdk shared].mediationProvider = @"max";
    [[ALSdk shared] initializeSdk];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

@end
