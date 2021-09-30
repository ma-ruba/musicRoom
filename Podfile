use_frameworks!
platform :ios, '11.0'

target 'MusicRoom' do

   pod 'Firebase/Database'
   pod 'Firebase/Auth'
   pod 'SnapKit'
   pod 'GoogleSignIn'
   pod 'FBSDKCoreKit'
   pod 'FBSDKLoginKit'
   pod 'Firebase/Core'

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
  end
 end
end
