require 'cocoapods-x/extension/sandbox'
require 'cocoapods-x/extension/configure'
require 'cocoapods-x/extension/environment/dsl'
require 'cocoapods-x/extension/environment/pod'
require 'cocoapods-x/extension/environment/source'
require 'cocoapods-x/extension/environment/podfile'
require 'cocoapods-x/extension/environment/definition'

module Pod
    module X
        class Environment

            Podinfo = Struct::new(:name, :version, :share, :repo_url)

            def initialize
                @pods = Pod::X::Pods::new
                @source = Pod::X::Source::new

                @runing = false
                @project = nil
                @workspace = nil
                @pods_list = nil
                @source_list = nil
                run
            end

            def runing?
                @runing
            end

            def podinfo? name, version
                return nil if name.nil?
                share = @pods_list[name]
                return nil if share.nil?
                repo_url = @source_list[name]
                Podinfo::new(name, version, share, repo_url)
            end

            def pod_path? info
                unless info.share 
                    repos = @project::repos
                else
                    repos = @workspace::repos
                end
                path = repos.pod_path!(info.name, info.version, info.share, info.repo_url)
                if !path.exist? || path.empty?
                    path = repos.pod_path_clone!(info.name, info.version, info.share, info.repo_url)
                end
                path
            end

            def self.environment 
                @@shared ||= Pod::X::Environment::new
                @@shared
            end

            def self.install!
                Pod::X::Sandbox::install!
                Pod::X::Sandbox::workspace
            end

            def self.update!
                Pod::X::Sandbox::update!
                Pod::X::Sandbox::workspace
            end

            def self.init!
                project_url = Pathname(Dir.pwd) 
                Pod::X::Sandbox::install!
                Pod::X::Sandbox::podfile_exists! project_url
                conf = Pod::X::Configurator::find_conf? project_url
                conf ||= Pod::X::Configurator::create_conf! project_url
                project = Pod::X::Sandbox::Project::new conf
                project.install!
                project
            end

            private

            def run
                project_url = Dir.pwd
                conf = Pod::X::Configurator::find_conf? project_url
                return nil if conf.nil?

                @project = Pod::X::Sandbox::Project::new conf
                @project.install!
                pods_file = @project.pods_file
                return nil unless pods_file.exist?

                @workspace = Pod::X::Sandbox::workspace
                source_file = @workspace.source_file
                return nil unless source_file.exist?

                @pods::build pods_file
                @pods_list = @pods.list
                @pods_list ||= Hash::new
                @pods_list = @pods_list.is_a?(Hash) ? @pods_list : Hash.new;

                @source::build source_file
                @source_list = @source.list
                @source_list ||= Hash::new
                @source_list = @source_list.is_a?(Hash) ? @source_list : Hash.new;

                if @pods_list.size > 0 && @source_list.size > 0
                    @runing = true
                    UI.puts 'Pod::X Working...'.green
                end
            end

        end
    end
end