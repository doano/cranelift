# TODO colocar permissões
class Projects::RepositoriesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :update

  before_filter :authenticate!, :except => :update
  before_filter :verify_local_access, :only => :update

  helper_method :current_project

  def index
    @repositories = current_project.repositories
  end

  def show
    @repository = current_project.repositories.find(params[:id])
    @repository.auth(params[:login], params[:pass]) or redirect_to action: :login
  end

  def update
    @repository = current_project.repositories.find(params[:id])
    @repository.version = params[:repository][:version]
    @repository.save
    redirect_to @repository.project, :notice => 'Repositorio atualizado com sucsso'
  end

  private
  def current_project
    @current_project ||= Project.find(params[:project_id])
  end

  def verify_local_access
    authenticate! unless local_access? 
  end

  # TODO
  def local_access?
    true
  end
end
