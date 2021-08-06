# frozen_string_literal: true

class Receipt < ActiveRecord::Base
  validates :callorage, :description, :ingridients, :title, presence: true

  before_save :calculate_callorage

  # callorage per 100 gram
  CALLORAGE_DICTIONARY = {
    'butter' => 300,
    'carrot' => 50,
    'meat' => 400,
    'onion' => 50,
    'potato' => 150,
    'sugar' => 500,
    'tomato' => 20
  }.freeze

  POSSIBLE_INGRIDIENTS = %i[
    butter carrot meat onion potato sugar tomato
  ].freeze

  private

  def calculate_callorage
    self.callorage = ingridients.inject(0) do |result, ingridient|
      result + Receipt::CALLORAGE_DICTIONARY[ingridient.first] * ingridient.last / 100.0
    end
  end
end
