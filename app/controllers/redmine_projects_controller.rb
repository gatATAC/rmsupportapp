class RedmineProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => [:new, :create, :index]

end
