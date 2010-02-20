SPEC = Gem::Specification.new do |spec| 
  spec.name = "bcms_yandex_server_search"
  spec.rubyforge_project = spec.name
  spec.version = "1.0.0"
  spec.summary = "A Yandex Server Search Module for BrowserCMS"
  spec.author = "ALX" 
  spec.email = "alx@anadyr.org" 
  spec.homepage = "http://www.browsercms.ru" 
  spec.files += Dir["app/**/*"]  
  spec.files += Dir["lib/bcms_yandex_server_search.rb"]
  spec.files += Dir["lib/bcms_yandex_server_search/*"]
  spec.files += Dir["rails/init.rb"]
  spec.has_rdoc = true
  spec.extra_rdoc_files = ["README.markdown"]
end
