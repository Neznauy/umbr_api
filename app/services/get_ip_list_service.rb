class GetIpListService
  attr_reader :ips

  def initialize
    @ips = {}
  end

  def call
    ActiveRecord::Base.connection.execute(
      "SELECT ip, logins FROM denormalization_ips WHERE logins_quantity > 1;"
    ).values.each do |v|
      ips[v[0]] = v[1].gsub(/[\{\}]/, '').split(/,/)
    end
  end
end
