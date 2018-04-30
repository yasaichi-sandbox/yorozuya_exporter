# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yorozuya_exporter/version"

Gem::Specification.new do |spec|
  spec.name          = "yorozuya_exporter"
  spec.version       = YorozuyaExporter::VERSION
  spec.authors       = ["yasaichi"]
  spec.email         = ["yasaichi@users.noreply.github.com"]

  spec.summary       = %q{Yorozuya-Ikka Data Exporter}
  spec.description   = %q{YorozuyaExporter enables you to export data of Yorozuya-Ikka to CSV.}
  spec.homepage      = "https://github.com/yasaichi-sandbox/yorozuya-exporter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara"
  spec.add_dependency "nokogiri"
  spec.add_dependency "selenium-webdriver"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry"
end
