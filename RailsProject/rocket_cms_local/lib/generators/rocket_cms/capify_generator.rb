require 'rails/generators'

module RocketCms
  class CapifyGenerator < Rails::Generators::Base
    argument :kind, type: :string
    argument :port, type: :string
    argument :domain, type: :string

    source_root File.expand_path('../templates', __FILE__)

    def app_name
      Rails.application.class.name.split("::")[0]
    end

    def deploy_to
      if kind == 'data'
        "/data/#{app_name.downcase}/app"
      else
        "/home/#{app_name.downcase}/#{app_name.downcase}"
      end
    end
    def tmp_path
      if kind == 'data'
        "/data/#{app_name.downcase}/tmp_dump"
      else
        "/home/#{app_name.downcase}/tmp_dump"
      end
    end

    desc 'RocketCMS capistrano setup generator'
    def install
      copy_file "Capfile", "Capfile"
      template "unicorn.erb", "config/unicorn/production.rb"
      template "deploy.erb", "config/deploy.rb"
      template "production.erb", "config/deploy/production.rb"
      template "dl.erb", "lib/tasks/dl.thor"
    end
  end
end

