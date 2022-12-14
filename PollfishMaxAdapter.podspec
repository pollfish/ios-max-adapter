Pod::Spec.new do |s|

    s.name                  = 'PollfishMaxAdapter'
    s.version               = '6.3.1.0'
    s.summary               = 'Pollfish iOS Adapter for AppLovin Max Mediation'
    s.module_name           = 'PollfishMaxAdapter'
    s.description           = 'Adapter for publishers looking to use AppLovin Max mediation to load and show Rewarded Surveys from Pollfish in the same waterfall with other Rewarded Ads.'
    s.homepage              = 'https://www.pollfish.com/publisher'
    s.documentation_url     = "https://pollfish.com/docs/ios-max-adapter"
    s.license               = { :type => 'Commercial', :text => 'See https://www.pollfish.com/terms/publisher' }
    s.authors               = { 'Pollfish Inc.' => 'support@pollfish.com' }

    s.source                = { :git => 'https://github.com/pollfish/ios-max-adapter.git', :tag => s.version.to_s }
    s.platform              = :ios, '11.0'
    s.requires_arc          = true
    s.swift_versions        = ['5.3']

    s.vendored_frameworks   = 'PollfishMaxAdapter.xcframework'

    s.dependency 'Pollfish', '= 6.3.1'
    s.dependency 'AppLovinSDK'

    s.pod_target_xcconfig =
    {
        'VALID_ARCHS' => 'arm64 arm64e armv7 armv7s x86_64'
    }
    
end
