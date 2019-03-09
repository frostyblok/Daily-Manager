class User < ApplicationRecord

  has_secure_password   # encrypt password

  has_many :todos, foreign_key: :created_by

  validates_presence_of :name, :email, :password_digest
end
