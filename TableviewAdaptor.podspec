Pod::Spec.new do |spec|
  spec.name = "TableViewAdaptor"
  spec.version = "0.0.1"
  spec.summary = "Another UITableView Adaptor makes tableview easy to use"
  spec.homepage = "https://github.com/dengcqw/Another-Yoga-Wrapper"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "dengjinlong" => 'dengcqw@qiyi.com' }
  spec.social_media_url = ""

  spec.platform = :ios, "9.0"
  spec.source = { git: "https://github.com/dengcqw/Another-UITableView-Adaptor.git" }
  spec.source_files = "{Sources}/*.{swift}"
  spec.frameworks = 'UIKit'
end
