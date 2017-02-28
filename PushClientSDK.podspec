Pod::Spec.new do |s|
	s.name         = "PushClientSDK"
	s.version      = "1.1.0"
	s.summary      = "Push Client SDK for iOS"
	s.homepage     = "https://github.com/jeasonyoung/PushClientSDK-iOS"
	s.license      = "MIT"
	s.author       = {"yangyong"=>"jeason1914@qq.com"}
	s.source       = {:git=>"https://github.com/jeasonyoung/PushClientSDK-iOS.git", :tag=>"#{s.version}"}
	s.platform     = :ios
	s.source_files = "PushClientSDK/PushClientSDK/*.{h,m}"
	s.requires_arc = true

	s.dependency "AFNetworking","~>2.0"
	s.dependency "CocoaAsyncSocket"

	s.ios.deployment_target = '7.0' 
end
