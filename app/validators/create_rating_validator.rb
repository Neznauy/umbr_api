class CreateRatingValidator
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
      required(:post_id).filled(:int?, :post_exist?)
      required(:rating_value).filled(included_in?: [1,2,3,4,5])
    end
  end
end
