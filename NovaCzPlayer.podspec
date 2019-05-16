Pod::Spec.new do |s|

    s.name             = "NovaCzPlayer"
    s.version          = '0.1.0'
    s.summary          = "NovaCzPlayer video player framework for Zapp iOS."
    s.description      = <<-DESC
                          NovaCzPlayer video player framework for Zapp iOS.
                         DESC
    s.homepage         = "https://github.com/smetanakarel/cmenovaczplugin.git"
    s.license          = 'MIT'
    s.author           = { "Karel Smetana" => "smetana.karel@gmail.com" }
    s.source           = { :git => "https://github.com/smetanakarel/cmenovaczplugin.git", :tag => s.version.to_s }
  
    s.ios.deployment_target  = "9.0"
    s.platform     = :ios, '9.0'
    s.requires_arc = true
    s.swift_version = '4.1'
  
    s.subspec 'Core' do |c|
      s.resources = []
      c.frameworks = 'UIKit'
      c.source_files = 'PluginClasses/*.{swift,h,m}'
      c.dependency 'ZappPlugins'
      c.dependency 'ApplicasterSDK'
    end
                  
    s.xcconfig =  { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
                    'ENABLE_BITCODE' => 'YES',
                    'OTHER_LDFLAGS' => '$(inherited)',
                    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
                    'LIBRARY_SEARCH_PATHS' => '$(inherited) "${PODS_ROOT}"/**',
                    'SWIFT_VERSION' => '4.1'
                  }
                  
    s.default_subspec = 'Core'
                  
  end
  
