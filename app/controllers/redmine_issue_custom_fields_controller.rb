class RedmineIssueCustomFieldsController < ApplicationController

  hobo_model_controller

  auto_actions :read_only, :except => [:index]

end
