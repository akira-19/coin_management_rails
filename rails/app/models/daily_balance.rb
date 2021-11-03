# frozen_string_literal: true

class DailyBalance < ApplicationRecord
  validates :balance, presence: true
  belongs_to :user
end
