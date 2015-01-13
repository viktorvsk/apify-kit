class GithubController < ActionController::Base
  require 'pry'

  def blog
    request.format = :json
    posts = JSON.parse(request.body.read)['posts']
    if posts.present?
      count   = posts.count
      titles  = posts.map{ |p| "'#{p['title']}'" }.join(", ")
      message = "Crawled #{count} posts from Github. Post titles are: #{titles}"
      status  = 1
    else
      status = 0
      message = 'No posts received'
    end
    render json: { status: status, message: message }
  end

end