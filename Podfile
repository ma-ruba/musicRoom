use_frameworks!
platform :ios, '11.0'

target 'MusicRoom' do

  # Pods for musicRoom
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  pod 'SnapKit', '~> 5.0.0'
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
  end
 end
end
