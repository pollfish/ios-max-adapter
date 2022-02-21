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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRewardedAd];
}

- (IBAction)showRewardedAd:(id)sender {
    if ([_rewardedAd isReady]) {
        [_rewardedAd showAd];
    }
}

- (void)createRewardedAd
{
    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier: @"AD_UNIT_ID"];
    self.rewardedAd.delegate = self;
    [self.rewardedAd loadAd];
    [_showRewardedAdButton setEnabled:false];
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {
    [_showRewardedAdButton setEnabled:true];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    [self.rewardedAd loadAd];
    [_showRewardedAdButton setEnabled:false];
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

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {}


@end
