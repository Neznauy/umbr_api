class CreateRatingService
  attr_reader :params, :errors, :avg_rating

  PERMITTED_ATTRIBUTES = [
    :post_id, :rating_value
  ].freeze

  def initialize(params)
    @params = params.permit(*PERMITTED_ATTRIBUTES).to_h
  end

  def call
    sanitize_params
    @errors = schema.call(params).messages

    if errors.blank?
      ActiveRecord::Base.transaction do 
        post = Post.lock.find(params[:post_id])
        Rating.create(params)
        post.update(avg_rating: post.new_avg_rating(params[:rating_value]), rating_quantity: post.rating_quantity+1)
        @avg_rating = {avg_rating: post.avg_rating}
      end
    end
  end

  private

  def schema
    Dry::Validation.Schema do
      configure do
        config.messages = :i18n
        
        def post_exist?(value)
          Post.find_by(id: value) ? true : false
        end
      end

      required(:post_id).filled(:int?, :post_exist?)
      required(:rating_value).filled(included_in?: [1,2,3,4,5])
    end
  end

  def sanitize_params
    params[:post_id] = params[:post_id].to_i if params[:post_id]
    params[:rating_value] = params[:rating_value].to_i if params[:rating_value]
  end
end
