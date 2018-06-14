class SeedService
  attr_reader :logins, :ips, :params

  def initialize(params)
    @params = params
    @logins = generate_logins
    @ips = generate_ips
  end

  def create_post
    params[:times].times do |i|
      params = {
        post: {
          title: generate_text(15),
          content: generate_text(50),
          author_ip: ips[rand(50)]
        },
        user: {login: logins[rand(100)]}
      }
      
      service = CreatePostService.new(ActionController::Parameters.new(params))
      service.call

      puts "#{i} post created" if service.errors.blank?
    end
  end

  def create_rating
    first_id = Post.first.id
    last_id = Post.last.id
    params[:times].times do |i|
      params = {
        post_id: rand(first_id..last_id),
        rating_value: rand(1..5)
      }
      service = CreateRatingService.new(ActionController::Parameters.new(params))
      service.call
      
      puts "#{i} rating created" if service.errors.blank?
    end
  end

  private

  def generate_logins
    arr = []
    100.times do |v|
      arr << Faker::Name.name.gsub!(/\W/,'_')
    end
    return arr
  end

  def generate_ips
    arr = []
    50.times do |v|
      arr << IPAddr.new(rand(2**32),Socket::AF_INET).to_s
    end
    return arr
  end

  def generate_text(length)
    (0...length).map { ('a'..'z').to_a[rand(26)] }.join
  end
end

SeedService.new({times: 200000}).create_post
SeedService.new({times: 100000}).create_rating