require "active_support/core_ext/class/attribute"

class ActionPolicy::Base
  attr_reader :user, :resource, :parent, :options

  class_attribute :default_resource

  class << self
    def inherited(subclass)
      subclass.default_resource =
        subclass.name.chomp('Policy').constantize rescue nil
    end
  end

  def initialize(user, resource = nil, options_or_parent = nil, **options)
    @user = user
    @resource = resource || default_resource

    if options_or_parent.is_a?(Hash)
      @options = options_or_parent if options_or_parent.is_a?(Hash)
    else
      @parent = options_or_parent
      @options = options
    end
  end

  %i(index show).each do |name|
    define_method("#{name}?") { true }
  end

  %i(create update destroy).each do |name|
    define_method("#{name}?") { false }
  end

  def new?
    create?
  end

  def edit?
    update?
  end
end
