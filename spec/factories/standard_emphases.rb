FactoryGirl.define do
  factory :standard_emphasis do
    emphasis { %w(a plus m s).sample }
    standard
  end
end
