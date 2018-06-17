class CreatePostService
  attr_reader :params, :errors, :post

  def initialize(params)
    @params = params.to_h
  end

  def call
    @errors = validated_params_errors

    if errors.blank?
      ActiveRecord::Base.transaction do 
        user = User.where(login: validated_params_output[:user][:login])
          .first_or_create(validated_params_output[:user])

        @post = user.posts.create(validated_params_output[:post])
        post.update_ips(validated_params_output[:post][:author_ip], validated_params_output[:user][:login])
      end
    end
  end

  private

  def validated_params
    @validated_params ||= CreatePostValidator.new(params).call
  end

  def validated_params_errors
    validated_params.errors
  end

  def validated_params_output
    validated_params.output
  end
end
