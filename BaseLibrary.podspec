Pod::Spec.new do |s|
  s.name             = 'BaseLibrary'
  s.version          = '0.3.0'
  s.summary          = 'Reusable iOS base utilities and UIKit extensions.'
  s.description      = <<-DESC
BaseLibrary contains shared UIKit/Foundation helpers, app constants, image/file utilities,
and view-controller conveniences for reuse across iOS projects.
  DESC

  s.homepage         = 'https://github.com/NgVuongQuoc/BaseLibrary'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NgVuongQuoc' => 'ngvuongquoc@gmail.com' }
  s.source           = { :git => 'https://github.com/NgVuongQuoc/BaseLibrary.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = '{Components,Config,Extensions,Manager}/**/*.swift'
  s.frameworks = 'UIKit', 'Photos', 'ImageIO', 'SwiftUI'

  s.dependency 'ProgressHUD', '13.8.3'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*.swift'
  end
end
