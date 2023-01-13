# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where(secret: 'FALSE') }

  scope :available, lambda { |target_user|
    where(user: target_user).or(published)
  }

  scope :search, lambda { |term|
    where('title LIKE ? OR content LIKE ?', "%#{sanitize_sql_like(term.to_s)}%", "%#{sanitize_sql_like(term.to_s)}%")
  }

  scope :default_order, -> { order(id: :desc) }

  def owned_by?(target_user)
    user == target_user
  end
end
