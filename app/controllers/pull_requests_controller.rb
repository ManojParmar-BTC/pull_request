class PullRequestsController < ApplicationController
  unloadable

  def index
    @project = Project.find(params[:project_id])
    @pull_requests = PullRequest.where(project_id: @project.id).order(id: :desc)
  end

  def github_hook
    if params[:pull_request].present?
      pull_request = PullRequest.find_or_create_by(git_id: params[:pull_request][:id], project_id: Project.find_by(identifier: params[:project_id]).id)
      pull_request.update_attributes(no: params[:pull_request][:number],
                                      git_id: params[:pull_request][:id],
                                      html_url: params[:pull_request][:html_url],
                                      difference_url: params[:pull_request][:html_url]+"/files",
                                      state: params[:pull_request][:state],
                                      title: params[:pull_request][:title])
    end

    if params[:issue].present?
      project = Project.find_by(identifier: params[:project_id])
      issue = Issue.find_or_create_by(github_id: params[:issue][:id])
      issue.update_attributes(subject: params[:issue][:title], 
                              description: params[:issue][:body], 
                              priority_id: IssuePriority.where(project_id: project.id).first.id, 
                              tracker_id: project.trackers.first, 
                              project_id: project.id,
                              status_id: IssueStatus.find_or_create_by(name: params[:issue][:state]).id, 
                              author_id: User.where(admin: true).first.id, 
                              start_date: Date.parse(params[:issue][:created_at]));
    end
    render nothing: true, status: :ok
  end
end
