require 'resolv'

class ApplicationSchema < Dry::Validation::Schema
  configure do
    config.messages = :i18n
  end

  def ip?(value)
    value =~ Resolv::IPv4::Regex ? true : false
  end

  def post_exist?(value)
    Post.find_by(id: value) ? true : false
  end
end
