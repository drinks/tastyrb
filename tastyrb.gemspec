Gem::Specification.new do |s|
  s.name = "tastyrb"
  s.version = File.open('VERSION').gets
  s.date = "2011-07-18"
  s.summary = "Generic client for self-describing APIs built with django-tastypie."
  s.description = "Generic client for self-describing APIs built with django-tastypie."
  s.email = "dan.drinkard@gmail.com"
  s.homepage = "http://github.com/drinks/tastyrb/"
  s.authors = ["Dan Drinkard"]
  s.files = ['lib/tastyrb.rb', 'README.md', 'LICENSE']

  s.add_dependency 'hashie', ['>= 0.2.0']
  s.add_dependency 'httparty', ['>= 0.5.2']
  s.add_dependency 'json', ['>= 1.1.3']
end
