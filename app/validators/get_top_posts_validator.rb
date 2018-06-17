class GetTopPostsValidator
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
      required(:quantity).filled(:int?, gt?: 0)
    end
  end
end
