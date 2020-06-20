#
#  Be sure to run `pod spec lint SortedJSONCoder.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "SortedJSONCoder"
  spec.version      = "0.0.1"
  spec.summary      = "Sorted JSON Coder library"

  spec.description  = <<-DESC 
                      Helps serialize objects to JSON data in sorted way you'd like.
                   DESC

  spec.homepage     = "https://github.com/mikehouse/SortedJSONCoder"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Mikhail Demidov" => "mike.house.nsk@gmail.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/mikehouse/SortedJSONCoder.git", :tag => "#{spec.version}" }
  spec.framework    = "Foundation"
  spec.requires_arc = true
  spec.source_files = "SortedJSONCoder/External/**/*.{h,m}", "SortedJSONCoder/Sources/**/*.{h,m}"
  spec.xcconfig     = { 'OTHER_LDFLAGS' => '-lObjC' }

  spec.public_header_files = "SortedJSONCoder/Sources/SortedJSONEncoder.h"
  spec.dependency "M13OrderedDictionary", "1.1.0"

end
