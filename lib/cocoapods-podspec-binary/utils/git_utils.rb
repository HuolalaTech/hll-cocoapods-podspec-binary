# frozen_string_literal: true

require 'git'

# git utils
class GitUtils
  # git utils
  def initialize(repository_path)
    @repository = open_git_repository(repository_path)
  end

  def open_git_repository(repository_path)
    Git.open(repository_path)
  end

  def clone(remote_url, destination_path)
    Git.clone(remote_url, destination_path)
  end

  def pull
    @repository.pull
  end

  def commit(message)
    @repository.add(all: true)
    @repository.commit(message)
  end

  def push(remote_name = 'origin', branch_name = 'master')
    @repository.push(remote_name, branch_name)
  end

  def status
    @repository.status
  end
end
