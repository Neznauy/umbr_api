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
        Post.lock.find(params[:post_id])
        Rating.create(params)
        @avg_rating = {avg_rating: Rating.where(post_id: params[:post_id]).average(:rating_value)}
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