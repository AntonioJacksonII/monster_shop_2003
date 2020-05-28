
class User < ApplicationRecord
  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
  validates_uniqueness_of :email
  validates_presence_of :password, require: true

  has_secure_password

  enum role: %w(user merchant admin)
end
