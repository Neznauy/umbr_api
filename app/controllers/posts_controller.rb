class PostsController < ApplicationController
  def create_post
    service = CreatePostService.new(params)
    service.call

    if service.errors.blank?
      render json: service.post, status: 200
    else
      render json: service.errors, status: 422
    end
  end

  def create_rating
    service = CreateRatingService.new(params)
    service.call

    if service.errors.blank?
      render json: service.avg_rating, status: 200
    else
      render json: service.errors, status: 422
    end
  end

  def get_top_posts
  end

  def get_ip_list
  end
end
