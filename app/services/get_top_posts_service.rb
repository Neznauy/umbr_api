class GetTopPostsService
  attr_reader :params, :errors, :posts

  PERMITTED_ATTRIBUTES = [
    :quantity
  ].freeze

  def initialize(params)
    @params = params.permit(*PERMITTED_ATTRIBUTES).to_h
  end

  def call
    sanitize_params
    @errors = schema.call(params).messages

    if errors.blank?
      @posts = Post.order(avg_rating: :desc).limit(params[:quantity])
    end
  end

  private

  def schema
    Dry::Validation.Schema do
      required(:quantity).filled(:int?, gt?: 0)
    end
  end

  def sanitize_params
    params[:quantity] = params[:quantity].to_i if params[:quantity]
  end
end