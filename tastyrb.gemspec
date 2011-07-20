Gem::Specification.new do |s|
  s.name = "tastyrb"
  s.version = "0.1.0"
  s.date = "2011-18-07"
  s.summary = "Generic client for self-describing APIs built with django-tastypie."
  s.description = "Generic client for self-describing APIs built with django-tastypie."
  s.email = "dan.drinkard@gmail.com"
  s.homepage = "http://github.com/dandrinkard/tastyrb/"
  s.authors = ["Dan Drinkard"]
  s.files = ['lib/tasty.rb', 'README.md', 'LICENSE']

  s.add_dependency 'hashie', ['>= 0.2.0']
  s.add_dependency 'httparty', ['>= 0.5.2']
  s.add_dependency 'json', ['>= 1.5.3']
end
