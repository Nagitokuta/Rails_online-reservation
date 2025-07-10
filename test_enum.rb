require "active_record"

class TestModel < ActiveRecord::Base
  self.abstract_class = true

  enum status: { active: 0, archived: 1 }
end

puts TestModel.defined_enums
