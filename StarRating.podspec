#
# Be sure to run `pod lib lint StarRating.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "StarRating"
  s.version          = "0.1.0"
  s.summary          = "A short description of StarRating."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
	A Simple star rating controller for tvOS written in swift
                       DESC

  s.homepage         = "https://github.com/arsonik/StarRating"
  s.license          = 'MIT'
  s.author           = { "Florian Morello" => "arsonik@me.com" }
  s.source           = { :git => "https://github.com/arsonik/StarRating.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/arsoniks'

  s.tvos.deployment_target = '9.0'

  s.source_files = 'StarRating/**/*'

  s.dependency 'PureLayout', '~> 3.0.1'
end
