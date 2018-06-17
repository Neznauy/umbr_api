class CreatePostValidator
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    schema.call(params)
  end

  private

  def schema
    Dry::Validation.Params(ApplicationSchema) do
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
