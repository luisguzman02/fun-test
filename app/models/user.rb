class User < ApplicationRecord

  has_many :documents, through: :signatures
  has_many :signatures

  validates_presence_of :name, :email, :tax_id

end
