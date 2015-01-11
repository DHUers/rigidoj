class ApplicationController < ActionController::Base
  include Pundit
  include SessionsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def serialize_data(obj, serializer, opts={})
    # If it's an array, apply the serializer as an each_serializer to the elements
    serializer_opts = opts
    if obj.respond_to?(:to_ary)
      serializer_opts[:each_serializer] = serializer
      ActiveModel::ArraySerializer.new(obj.to_ary, serializer_opts).as_json
    else
      serializer.new(obj, serializer_opts).as_json
    end
  end

  # This is odd, but it seems that in Rails `render json: obj` is about
  # 20% slower than calling MultiJSON.dump ourselves. I'm not sure why
  # Rails doesn't call MultiJson.dump when you pass it json: obj but
  # it seems we don't need whatever Rails is doing.
  def render_serialized(obj, serializer, opts={})
    render_json_dump(serialize_data(obj, serializer, opts))
  end

  def render_json_dump(obj)
    render json: MultiJson.dump(obj)
  end

  private

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
