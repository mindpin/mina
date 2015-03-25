module Mina
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      class_option :worker_processes, desc: 'worker processes number?(default: 3)'
      class_option :domain, desc: 'server domain or ip?(example: 4ye.me or 127.0.0.1)'
      class_option :deploy_to_path, desc: 'deploy_to deploy_to_path on server?(example: /web/mindpin)'
      class_option :repository, desc: 'git repository?(example: git://github.com/mindpin/mina.git)'
      class_option :branch, desc: 'git repository branch?(default: master)'

      def copy_config
        deploy_to_path = options[:deploy_to_path]
        repository = options[:repository]
        domain = options[:domain]
        branch = options[:branch]

        raise 'deploy to path must be not nil' if deploy_to_path.blank?
        raise 'deploy_to_path to path must be not nil' if deploy_to_path.blank?
        raise 'repository to path must be not nil' if repository.blank?
        #template "deploy/sh/function.sh"
        #template "deploy/sh/unicorn.sh"

        append_file '.gitignore' do <<-FILE
# Ignore mina deploy configuration
/config/deploy.rb
FILE
        end

        directory 'deploy/sh'
        directory 'config'

        worker_processes = options[:worker_processes]
        worker_processes = '3' if worker_processes.to_i == 0
        gsub_file 'config/unicorn.rb', /worker_processes 3/, 'worker_processes ' + worker_processes

        gsub_file 'config/deploy.rb', /DOMAIN/, domain
        gsub_file 'config/deploy.rb', /DEPLOY_PATH/, deploy_to_path
        gsub_file 'config/deploy.rb', /REPOSITORY/, repository
        gsub_file 'config/deploy.rb', /master/, branch if !branch.blank?
        end
      end
    end
  end
end
