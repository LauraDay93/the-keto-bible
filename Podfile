# Updated for Xcode 15+ / Swift 5.9+
platform :ios, '14.0'
inhibit_all_warnings!
use_frameworks! :linkage => :dynamic

target 'The Keto Bible' do
  # UI & Layout
  pod 'SnapKit'
  pod 'Kingfisher'
  pod 'Lottie'           # (was lottie-ios)

  # Firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'  # remove if not needed

  # UX & Animations
  pod 'SwiftMessages'
  pod 'ViewAnimator'
  pod 'Hero'

  # Utilities
  pod 'DefaultsKit'
  pod 'SwiftyJSON'
  pod 'FAPanels'

  # IAP
  pod 'SwiftyStoreKit'

  # Login SDKs
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'GoogleSignIn'
end

post_install do |installer|
  installer.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
