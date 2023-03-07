# Pollfish iOS Max Mediation Adapter

Max Mediation Adapter for iOS apps looking to load and show Rewarded Surveys from Pollfish in the same waterfall with other Rewarded Ads.

> **Note:** A detailed step by step guide is provided on how to integrate can be found [here](https://www.pollfish.com/docs/ios-max-adapter)

<br/>

## Step 1: Add Pollfish Max Adapter to your project

Download the following frameworks

* [Pollfish SDK](https://www.pollfish.com/docs/ios)
* [AppLovin SDK](https://dash.applovin.com/documentation/mediation/manual-integration-ios)
* [PollfishMaxAdapter](https://github.com/pollfish/ios-max-adapter)

and add them in your App's target dependecies 

1. Navigate to your project
2. Select your App's target and go to the **General** tab section **Frameworks, Libraries and Embedded Content**
3. Add all three dependent framewokrs one by one by pressing the + button -> Add other and selecting the appropriate framework

Add the following frameworks (if you don’t already have them) in your project

- AdSupport.framework  
- CoreTelephony.framework
- SystemConfiguration.framework 
- WebKit.framework (added in Pollfish v4.4.0)

**OR**

### **Retrieve Pollfish Max Adapter through CocoaPods**

Add a Podfile with PollfishMaxAdapter pod reference:

```ruby
pod 'PollfishMaxAdapter'
```

You can find the latest PollfishMaxAdapter version on CocoaPods [here](https://cocoapods.org/pods/PollfishMaxAdapter)

Run pod install on the command line to install PollfishMax pod.

<br/>

## Step 2: Request for a RewardedAd

Import `AppLovinSDK` 

<span style="text-decoration:underline">Swift</span>

```swift
import AppLovinSDK
```

<span style="text-decoration:underline">Objective C</span>

```objc
#import <AppLovinSDK/AppLovinSDK.h>
```

<br/>

Initialize the SDK in your app delegate’s `application:applicationDidFinishLaunching:` method

<span style="text-decoration:underline">Swift</span>

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    ALSdk.shared()!.mediationProvider = "max"
    
    ALSdk.shared()!.initializeSdk(completionHandler: nil)
    
    return true
}
```

<span style="text-decoration:underline">Objective C</span>

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ALSdk shared].mediationProvider = @"max";
    
    [[ALSdk shared] initializeSdkWithCompletionHandler:^(ALSdkConfiguration *configuration) {}];
}
```

<br/>

Implement `MARewardedAdDelegate` so that you are notified when your ad is ready and of other ad-related events.

<br/>

Request a RewardedAd from AppLovin by calling `load` in the `MARewardedAd` object instance you've created. By default Pollfish Max Adapter will use the configuration as provided on AppLovin's dashboard. If no configuration is provided or if you want to override any of those params please see step 3.

<br/>

<span style="text-decoration:underline">Swift</span>

```swift
class ViewController: UIViewController, MARewardedAdDelegate {

    var rewardedAd: MARewardedAd!

    ...

    func createRewardedAd() {
        rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: "AD_UNIT_ID")
        rewardedAd.delegate = self
        rewardedAd.load()
    }

    func didLoad(_ ad: MAAd) {}

    func didDisplay(_ ad: MAAd) {}

    func didHide(_ ad: MAAd) {}

    func didClick(_ ad: MAAd) {}

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {}

    func didFail(toDisplay ad: MAAd, withError error: MAError) {}

    func didStartRewardedVideo(for ad: MAAd) {}

    func didCompleteRewardedVideo(for ad: MAAd) {}

    func didRewardUser(for ad: MAAd, with reward: MAReward) {}

}
```

<span style="text-decoration:underline">Objective C</span>

```objc
@interface ViewController()<MARewardedAdDelegate>
@property (nonatomic, strong) MARewardedAd *rewardedAd;
@end

@implementation ViewController

...

- (void)createRewardedAd
{
    self.rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier: @"YOUR_AD_UNIT_ID"];
    self.rewardedAd.delegate = self;
    [self.rewardedAd loadAd];
}

#pragma mark - MAAdDelegate Protocol

- (void)didLoadAd:(MAAd *)ad {}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {}

- (void)didDisplayAd:(MAAd *)ad {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didHideAd:(MAAd *)ad {}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}

#pragma mark - MARewardedAdDelegate Protocol

- (void)didStartRewardedVideoForAd:(MAAd *)ad {}

- (void)didCompleteRewardedVideoForAd:(MAAd *)ad {}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {}

@end
```

When the Rewarded Ad is ready, present the ad by invoking `rewardedAd.show()`. Just to be sure, you can combine show with a check to see if the Ad you are about to show is actually ready.

<span style="text-decoration:underline">Swift</span>

```swift
if rewardedAd.isReady {
    rewardedAd.show()
}
```

<span style="text-decoration:underline">Objective C</span>

```objc
if ( [self.rewardedAd isReady] )
{
    [self.rewardedAd showAd];
}
```

<br/>

## Step 3: Use and control Pollfish Max Adapter in your Rewarded Ad Unit (Optional)

Pollfish Max Adapter provides different options that you can use to control the behaviour of Pollfish SDK. This configuration, if applied, will override any configuration done in AppLovin's dashboard.

<br/>


| No  | Configuration  | Description                                                                                                                                      |
| --- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| 3.1 | Dashboard/Code | **`api_key`** <br/> Sets Pollfish SDK API key as provided by Pollfish                                                                            |
| 3.2 | Dashboard/Code | **`request_uuid`** <br/> Sets a unique identifier to identify a user and be passed through to [s2s callbacks](https://www.pollfish.com/docs/s2s) |
| 3.3 | Dashboard/Code | **`release_mode`** <br/> Toggles Pollfish SDK Developer or Release mode                                                                          |
| 3.4 | Code           | **`user_id`** <br/> Sets a unique identifier to identify a user                                                                                  |

<br/>

### 3.1 `api_key`

Pollfish API Key as provided by Pollfish on [Pollfish Dashboard](https://www.pollfish.com/publisher/) after you sign in and create an app. If you have already specified Pollfish API Key on AppLovin's UI, this param will override the one defined on Web UI.

<br/>

### 3.2 `request_uuid`

Sets a unique id to identify a user and be passed through s2s callbacks upon survey completion.

In order to register for such callbacks you can set up your server URL on your app's page on Pollfish Developer Dashboard. On each survey completion you will receive a callback to your server including the `request_uuid` param passed.

If you would like to read more on Pollfish s2s callbacks you can read the documentation [here](https://www.pollfish.com/docs/s2s)

<br/>

### 3.3 `release_mode`

Sets Pollfish SDK to Developer or Release mode.

- **Developer mode** is used to show to the developer how Pollfish surveys will be shown through an app (useful during development and testing).
- **Release mode** is the mode to be used for a released app in any app store (start receiving paid surveys).

Pollfish Max Adapter runs Pollfish SDK in release mode by default. If you would like to test with Test survey, you should set release mode to fasle.

<br/>

### 3.4 `user_id`

An optional id used to identify a user

Setting the `userId` will override the default behaviour and use that instead of the Advertising Id in order to identify a user

<span style="color: red">You can pass the id of a user as identified on your system. Pollfish will use this id to identify the user across sessions instead of an ad id/idfa as advised by the stores. You are solely responsible for aligning with store regulations by providing this id and getting relevant consent by the user when necessary. Pollfish takes no responsibility for the usage of this id. In any request from your users on resetting/deleting this id and/or profile created, you should be solely liable for those requests.</span>

<br/>

Below you can see all the available configuration options for Pollfish Max Adapter.

<br/>

```swift
rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: "AD_UNIT_ID")
rewardedAd.setLocalExtraParameterForKey("api_key", value: "YOUR_API_KEY")
rewardedAd.setLocalExtraParameterForKey("request_uuid", value: "REQUEST_UUID")
rewardedAd.setLocalExtraParameterForKey("release_mode", value: true)
rewardedAd.setLocalExtraParameterForKey("user_id", value: "USER_ID")
```

<br/>

## Step 4: Publish

If you everything worked fine during the previous steps, you should turn Pollfish to release mode and publish your app.

> **Note:** After you take your app live, you should request your account to get verified through Pollfish Dashboard in the App Settings area.

> **Note:** There is an option to show **Standalone Demographic Questions** needed for Pollfish to target users with surveys even when no actually surveys are available. Those surveys do not deliver any revenue to the publisher (but they can increase fill rate) and therefore if you do not want to show such surveys in the Waterfall you should visit your **App Settings** are and disable that option.
