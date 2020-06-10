class ApplicationJob < ActiveJob::Base
  include HttpRequest
  include CheckAuth
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked
end
