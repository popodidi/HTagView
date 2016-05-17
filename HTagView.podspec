#
# Be sure to run `pod lib lint HTagView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HTagView"
  s.version          = "1.0.0"
  s.summary          = "A customized tag view sublassing UIScrollView"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "A customized tag view sublassing UIScrollView"

  s.homepage         = "https://github.com/popodidi/HTagView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Hao" => "popodidi@livemail.tw" }
  s.source           = { :git => "https://github.com/popodidi/HTagView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HTagView/Classes/**/*'
  
  s.resource_bundles = {
    'HTagView' => ['HTagView/Assets/**/*.{png,jpeg,jpg,storyboard,xib}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
