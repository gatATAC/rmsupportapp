class RedmineUsersController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => [:new, :create, :index]
  auto_actions_for :redmine_server, [:new, :create]

end
