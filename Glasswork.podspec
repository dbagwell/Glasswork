Pod::Spec.new do |s|
  s.name             = 'Glasswork'
  s.version          = '8.1.2'
  s.license          = 'MIT'
  s.summary          = 'Glasswork'
  s.homepage         = 'https://github.com/dbagwell/Glasswork'
  s.author           = 'David Bagwell'
  s.source           = { :git => 'https://github.com/dbagwell/Glasswork.git', :tag => '8.1.2' }

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'

  s.source_files     = 'Source/**/*'
  
  s.dependency 'SnapKit'
  s.dependency 'Rebar', '> 3'

end
