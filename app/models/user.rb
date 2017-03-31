class User < ApplicationRecord

  has_many :documents, through: :signatures
  has_many :signatures

end
