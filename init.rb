Redmine::Plugin.register :pull_request do
  name 'Pull Request plugin'
  author 'Manoj parmar'
  description 'This is a plugin for displaying pull requests'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

end

Redmine::Plugin.register :redmine_pull_requests do
  permission :pull_requests, { :pull_requests => [:index] }, :public => true
  menu :project_menu, :pull_requests, { :controller => 'pull_requests', :action => 'index' }, :caption => 'Pull Requests', :after => :activity, :param => :project_id
end
