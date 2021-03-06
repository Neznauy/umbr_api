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
    service = GetTopPostsService.new(params)
    service.call

    if service.errors.blank?
      render json: service.posts, status: 200
    else
      render json: service.errors, status: 422
    end
  end

  def get_ip_list
    service = GetIpListService.new
    service.call

    render json: service.ips, status: 200
  end
end
