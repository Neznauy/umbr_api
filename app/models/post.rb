class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings

  def new_avg_rating(new_rating)
    (avg_rating*rating_quantity+new_rating)/(rating_quantity+1)
  end

  def update_ips(ip, login)
    ActiveRecord::Base.connection.execute(
      "INSERT INTO denormalization_ips(ip, logins) VALUES ('#{ip}', ARRAY['#{login}'])
      ON CONFLICT (ip) DO UPDATE
        SET logins = array_undup(array_cat(denormalization_ips.logins, ARRAY['#{login}']));
      UPDATE denormalization_ips SET logins_quantity = array_length(logins, 1) WHERE ip='#{ip}';"
    )
  end
end
