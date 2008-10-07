ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

begin require 'redgreen'; rescue LoadError; nil end

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :users, :goals, :updates, :nudges
end

require 'mocha'
require 'test/spec/rails'

Test::Spec::Should.send    :alias_method, :have, :be
Test::Spec::ShouldNot.send :alias_method, :have, :be

Test::Spec::Should.class_eval do
  # Article.should.differ(:count).by(2) { blah } 
  def differ(method)
    @initial_value = @object.send(@method = method)
    self
  end

  def by(value)
    yield
    assert_equal @initial_value + value, @object.send(@method)
  end
end
