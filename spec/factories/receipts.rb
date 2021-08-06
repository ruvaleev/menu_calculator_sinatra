# frozen_string_literal: true

FactoryBot.define do
  factory :receipt do
    transient do
      included_ingridients { [] }
      excluded_ingridients { [] }
    end
    title { FFaker::Lorem.phrase }
    description { FFaker::Lorem.paragraph }
    ingridients do
      compose_ingridients(included_ingridients, excluded_ingridients)
    end
  end
end

def compose_ingridients(included, excluded)
  possible_ingridients = Receipt::POSSIBLE_INGRIDIENTS - included - excluded
  rabdom_ingridients = add_quantity_to_ingridients(possible_ingridients.sample(rand(2..4)))
  included_ingridients = add_quantity_to_ingridients(included)

  (rabdom_ingridients + included_ingridients).to_h
end

def add_quantity_to_ingridients(ingridients)
  ingridients.map { |ingridient| [ingridient, (0..500).step(10).to_a.sample] }
end
