Pod::Spec.new do |spec|
    spec.name                   = 'CEFoundation'
    spec.version                = '0.0.1'
    spec.license                = { :type => 'MIT', :file => 'LICENSE' }
    spec.author                 = { 'panghu' => 'panghu.lee@gmail.com' }
    spec.summary                = 'A short description of CEFoundation.'
    spec.homepage               = 'https://github.com/panghu/CEFoundation'
    spec.source                 = { :git => 'https://github.com/panghu/CEFoundation.git', :tag => spec.version.to_s }
    
    spec.platform               = :ios
    spec.ios.deployment_target  = '9.0'
    spec.static_framework       = true
    spec.prefix_header_file     = false
    spec.module_map             = 'Sources/CEFoundation.modulemap'
    
    spec.source_files           = 'Sources/**/*.{h,m,swift}'
    spec.public_header_files    = 'Sources/CEFoundation.h'

#    spec.libraries              = 'sqlite3'
#    spec.framework              = 'Foundation'
#    spec.resources              = ['Bundles/CEFoundation.bundle']

#    spec.dependency 'Alamofire'

end
