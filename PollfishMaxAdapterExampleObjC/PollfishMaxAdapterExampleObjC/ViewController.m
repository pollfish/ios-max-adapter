//
//  ViewController.m
//  PollfishMaxAdapterExampleObjC
//
//  Created by Fotis Mitropoulos on 21/2/22.
//

#import "ViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>

@interface ViewController ()<MARewardedAdDelegate>
@property (weak, nonatomic) IBOutlet UIButton *showRewardedAdButton;
@property (nonatomic, strong) MARewardedAd *rewardedAd;
@property (nonatomic, assign) NSInteger retryAttempt;
@end

@implementation ViewController

NSString *const adUnitid = @"YOUR_AD_ID";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (@available(iOS 14, *)) {
        [self requestIDFAPermission];
    } else {
        [self createRewardedAd];
    }
}

- (void)requestIDFAPermission {
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createRewardedAd];
            });
        }];
    } else {
        // Fallback on earlier versions
    }
#endif
}

- (IBAction)showRewardedAd:(id)sender {
    if ([_rewardedAd isReady]) {
        [_rewardedAd showAd];
    }
}

- (void)createRewardedAd
{
    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier: adUnitid];
    
    // Optional parameters, if have already been set in the AppLovin dashboard
    // In case you've already set them in the Dashboard, params in code will override the ones you've already set
    [self.rewardedAd setLocalExtraParameterForKey:@"release_mode" value:[NSNumber numberWithBool:NO]];
    [self.rewardedAd setLocalExtraParameterForKey:@"offerwall_mode" value:[NSNumber numberWithBool:TRUE]];
    [self.rewardedAd setLocalExtraParameterForKey:@"request_uuid" value:@"REQUEST_UUID"];
    [self.rewardedAd setLocalExtraParameterForKey:@"api_key" value:@"YOUR_API_KEY"];
    
    self.rewardedAd.delegate = self;
    [self.rewardedAd loadAd];
    [_showRewardedAdButton setEnabled:false];
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {
    [_showRewardedAdButton setEnabled:true];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    self.retryAttempt++;
    NSInteger delaySec = pow(2, MIN(6, self.retryAttempt));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.rewardedAd loadAd];
        [self.showRewardedAdButton setEnabled:false];
    });
}

- (void)didDisplayAd:(MAAd *)ad {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didHideAd:(MAAd *)ad {
    [self.rewardedAd loadAd];
    [_showRewardedAdButton setEnabled:false];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    [self.rewardedAd loadAd];
    [_showRewardedAdButton setEnabled:false];
}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didStartRewardedVideoForAd:(MAAd *)ad {}

- (void)didCompleteRewardedVideoForAd:(MAAd *)ad {}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {
    NSLog(@"Reward received: %ld %@", (long)reward.amount, reward.label);
}


@end
