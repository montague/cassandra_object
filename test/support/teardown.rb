CassandraObject::Base.class_eval do
  class_attribute :created_records
  self.created_records = []

  after_create do
    created_records << self
  end

  def self.delete_after_test
    # created_records.reject(&:destroyed?).each(&:destroy)
    Issue.delete_all
    created_records.clear
  end
end

module ActiveSupport
  class TestCase
    teardown do
      if CassandraObject::Base.created_records.any?
        CassandraObject::Base.delete_after_test
      end
    end
  end
end
