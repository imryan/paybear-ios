#
# Be sure to run `pod lib lint paybear-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'paybear-ios'
    s.version          = '1.0.1'
    s.summary          = 'Paybear API on iOS'
    
    s.description      = <<-DESC
    Utilize the Paybear cryptocurrency checkout API on iOS.
    DESC
    
    s.homepage         = 'https://github.com/imryan/paybear-ios'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Ryan Cohen' => 'notryancohen@gmail.com' }
    s.source           = { :git => 'https://github.com/imryan/paybear-ios.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    s.source_files = 'paybear-ios/Classes/**/*'
    s.dependency 'Alamofire'
end
