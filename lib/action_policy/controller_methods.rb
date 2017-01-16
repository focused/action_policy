require "active_support/concern"

module ActionPolicy::ControllerMethods
  extend ActiveSupport::Concern

  included do
    helper_method :policy_user
    helper_method :policy
  end

  def policy_user
    current_user
  end

  def authorize(resource = nil, *args)
    resource ||= instance_variable_get("@#{controller_name.singularize}")

    policy =
      resolve_policy("#{controller_name.classify}Policy", resource, *args)
    policy.send("#{action_name}?") ? policy.resource : nil
  end

  def authorize!(resource = nil, *args)
    resource ||= instance_variable_get("@#{controller_name.singularize}")

    policy =
      resolve_policy("#{controller_name.classify}Policy", resource, *args)
    policy.send("#{action_name}?") or raise Errors::Unauthorized

    policy.resource
  end

  def policy(resource = nil, *args)
    @policy ||= {}
    name = if resource
      (resource.is_a?(Class) ? resource : resource.class).name
    else
      controller_name.classify
    end

    index = args.first&.respond_to?(:id) ? args.first.id : 0
    @policy.fetch(name, {})["id_#{index}"] ||=
      resolve_policy("#{name}Policy", resource, *args)
  end

  private

  def resolve_policy(class_name, *args)
    policy_class = if Rails.env.development? || Rails.env.test?
      class_name.constantize rescue nil
    else
      class_name.constantize if Object.const_defined?(class_name)
    end

    (policy_class || ApplicationPolicy).new(policy_user, *args)
  end
end
