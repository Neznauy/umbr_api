class GetTopPostsService
  attr_reader :params, :errors, :posts

  def initialize(params)
    @params = params.to_h
  end

  def call
    sanitize_params
    @errors = validated_params_errors

    if errors.blank?
      @posts = Post.order(avg_rating: :desc).limit(validated_params_output[:quantity])
    end
  end

  private

  def validated_params
    @validated_params ||= GetTopPostsValidator.new(params).call
  end

  def validated_params_errors
    validated_params.errors
  end

  def validated_params_output
    validated_params.output
  end

  def sanitize_params
    params[:quantity] = params[:quantity].to_i if params[:quantity]
  end
end
