require 'resolv'

class CreatePostService
  attr_reader :params, :errors, :post

  PERMITTED_ATTRIBUTES = [
    post: [:title, :content, :author_ip],
    user: [:login]
  ].freeze

  def initialize(params)
    @params = params.permit(*PERMITTED_ATTRIBUTES).to_h
  end

  def call
    @errors = schema.call(params).messages

    if errors.blank?
      ActiveRecord::Base.transaction do 
        user = User.where(login: params[:user][:login]).first_or_create(params[:user])
        @post = user.posts.create(params[:post])
      end
    end
  end

  private

  def schema
    Dry::Validation.Schema do
      configure do
        config.messages = :i18n
        
        def ip?(value)
          value =~ Resolv::IPv4::Regex ? true : false
        end
      end

      required(:post).schema do
        required(:title).filled
        required(:content).filled
        required(:author_ip).filled(:ip?)
      end
      required(:user).schema do
        required(:login).filled
      end
    end
  end
end
