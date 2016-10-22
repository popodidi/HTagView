#
# Be sure to run `pod lib lint HTagView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HTagView"
  s.version          = "2.0.1"
  s.summary          = "A customized tag view sublassing UIView"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "A customized tag view sublassing UIView where tag could be either with cancel button or multiseletable."

  s.homepage         = "https://github.com/popodidi/HTagView"
  s.license          = 'MIT'
  s.author           = { "Hao" => "changhao@haostudio.cc" }
  s.source           = { :git => "https://github.com/popodidi/HTagView.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HTagView/Classes/**/*'
  s.resources = ['HTagView/Assets/*.{xcassets,png,jpeg,jpg,storyboard,xib}']

  s.frameworks = 'UIKit'
end
