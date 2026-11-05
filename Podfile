platform :ios, '15.0'

def devpod(name, path)
  pod name, :path => path
end

target 'Glasswork' do

    pod 'SnapKit'
    pod 'Rebar', :git => 'https://github.com/dbagwell/Rebar'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
