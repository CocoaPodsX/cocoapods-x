Pod::Spec.new do |spec|
    spec.name                   = 'CEUIKitCore'
    spec.version                = '0.0.1'
    spec.license                = { :type => 'MIT', :file => 'LICENSE' }
    spec.author                 = { 'panghu' => 'panghu.lee@gmail.com' }
    spec.summary                = 'A short description of CEUIKitCore.'
    spec.homepage               = 'https://github.com/panghu/CEUIKitCore'
    spec.source                 = { :git => 'https://github.com/panghu/CEUIKitCore.git', :tag => spec.version.to_s }
    
    spec.platform               = :ios
    spec.ios.deployment_target  = '9.0'
    spec.static_framework       = true
    spec.prefix_header_file     = false
    spec.module_map             = 'Sources/CEUIKitCore.modulemap'
    
    spec.source_files           = 'Sources/**/*.{h,m,swift}'
    spec.public_header_files    = 'Sources/CEUIKitCore.h'

#    spec.libraries              = 'sqlite3'
#    spec.framework              = 'Foundation'
#    spec.resources              = ['Bundles/CEUIKitCore.bundle']

#    spec.dependency 'Alamofire'

end
