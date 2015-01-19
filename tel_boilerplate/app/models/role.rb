class Role < ActiveRecord::Base

  acts_as_paranoid
  has_paper_trail

  has_and_belongs_to_many :users
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
end
