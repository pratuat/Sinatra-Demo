# frozen_string_literal: true

class DataContainer
  attr_reader :users, :recommendations

  def initialize
    @users = []
    @recommendations = []
  end

  def add_user(**user_params)
    unless find_user_by_name(user_params[:name])
      recommendation = find_recommendation_by_recommendee_name(user_params[:name])
      user_params.merge!(recommender_name: recommendation.recommender_name) if recommendation

      user = User.new(**user_params)
      @users << user

      user
    end
  end

  def find_user_by_name(name)
    @users.find { |user| user.name == name }
  end

  def add_recommendation(**recommendation_params)
    recommendation = Recommendation.new(**recommendation_params)
    @recommendations << recommendation

    recommendation
  end

  def find_recommendation_by_recommendee_name(name)
    recommendations = @recommendations.find_all { |el| el.recommendee_name == name }

    return recommendations.min_by(&:created_at) if recommendations
  end

  def get_recommender(object)
    find_user_by_name(object&.recommender_name) if object&.recommender_name
  end

  def add_points_to_user(user, points)
    user.increment_point(points)
  end
  
  def get_users_points
    user_points = @users.each_with_object([]) do |user, user_points|
      user_points << [user.name, user.points] if user.points > 0
    end
    
    Hash[user_points]
  end
end
