class CreateRatingService
  attr_reader :params, :errors, :avg_rating

  def initialize(params)
    @params = params.to_h
  end

  def call
    sanitize_params
    @errors = validated_params_errors

    if errors.blank?
      ActiveRecord::Base.transaction do 
        post = Post.lock.find(validated_params_output[:post_id])
        Rating.create(validated_params_output)
        post.update(avg_rating: post.new_avg_rating(validated_params_output[:rating_value]), rating_quantity: post.rating_quantity+1)
        @avg_rating = {avg_rating: post.avg_rating}
      end
    end
  end

  private

  def validated_params
    @validated_params ||= CreateRatingValidator.new(params).call
  end

  def validated_params_errors
    validated_params.errors
  end

  def validated_params_output
    validated_params.output
  end

  def sanitize_params
    params[:post_id] = params[:post_id].to_i if params[:post_id]
    params[:rating_value] = params[:rating_value].to_i if params[:rating_value]
  end
end
