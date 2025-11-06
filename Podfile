# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DBA Fitness' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for DBA Fitness
  
#  post_install do |installer|
#    installer.pods_project.build_configurations.each do |config|
#      if config.name != 'Release'
#        config.build_settings['VALID_ARCHS'] = 'arm64, arm64e, x86_64'
#      end
#    end
#  end
#

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end


  pod 'MGSwipeTableCell'
  pod 'SDWebImage'
  #pod 'GoogleSignIn', '~> 4.0'
  pod 'NVActivityIndicatorView'
  pod 'Alamofire', '~> 4.0'
  pod 'FacebookLogin'
  pod 'FacebookCore'
  pod 'GooglePlaces'
  pod 'STRatingControl'
  #pod 'Stripe'
  #pod 'Stripe', '21.4.0'
  pod 'Stripe', '22.8.3'
  #pod 'collection-view-layouts/PinterestLayout'
  pod 'PinterestLayout'
  pod 'IQKeyboardManagerSwift'
  pod 'lottie-ios'
  pod 'JMMaskTextField-Swift'

  target 'DBA FitnessTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'DBA FitnessUITests' do
    # Pods for testing
  end
  
end
