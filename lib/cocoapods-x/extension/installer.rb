require 'cocoapods-x/extension/sandbox'
require 'cocoapods-x/extension/configure'
require 'cocoapods-x/extension/installer/dsl'
require 'cocoapods-x/extension/installer/podfile'
require 'cocoapods-x/extension/installer/builder'

module Pod
    module X
        class Installer

            attr_accessor :init_self, :target_self, :pod_self, :print_post_install_message_self
            attr_accessor :init_method, :target_method, :pod_method, :print_post_install_message_method

            attr_accessor :pods_builder, :sources_builder
            attr_accessor :project, :workspace

            attr_accessor :pods

            def initialize 
                @project = nil
                @workspace = nil
                @pods_builder = Pod::X::PodsBuilder::new
                @sources_builder = Pod::X::SourcesBuilder::new
                @repos = Array::new
            end

            def self.installer
                @@shared ||= Pod::X::Installer::new
                @@shared
            end

            # monitor

            def monitor_initialize_begin(defined_in_file = nil, internal_hash = {}, &block)
                workspace = Pod::X::Sandbox::workspace
                return unless workspace.source_file.exist?

                conf = Pod::X::Configurator::find_conf?(Dir.pwd)
                return if conf.nil?
                project = Pod::X::Sandbox::Project::new(conf)
                return unless project.pods_file.exist?

                @project = project
                @workspace = workspace
                @pods_builder::build(project.pods_file)
                @sources_builder::build(workspace.source_file)
                UI.puts 'Pod::X Working...'.green
            end

            def monitor_initialize_end(defined_in_file = nil, internal_hash = {}, &block)
                @repos.each do |repo|
                    unless repo.share
                        path = @project::repos::pod_path(repo)
                    else
                        path = @workspace::repos::pod_path(repo)
                    end
                    if !path.exist? || path.empty? 
                        unless repo.share
                            @project::repos::pod_clone!(repo)
                        else
                            @workspace::repos::pod_clone!(repo)
                        end
                    end
                end
            end

            def monitor_target_begin(name, options = nil, &block)

            end
            
            def monitor_target_end(name, options = nil, &block)
                
            end

            def monitor_pod_begin(name, *requirements)
                return nil if @pods_builder.nil?
                return nil if @pods_builder.pods[name].nil?
                return nil if @sources_builder.nil?
                return nil if @sources_builder.sources[name].nil?

                return nil if @project.nil?
                return nil if @workspace.nil?

                argv = requirements.dup
                pod = @pods_builder.pods[name]
                source = @sources_builder.sources[name]
                repo = Pod::X::Sandbox::Repos::repo(name, argv, pod, source)
                @repos << repo
                unless repo.share 
                    path = @project::repos::pod_path(repo)
                else
                    path = @workspace::repos::pod_path(repo)
                end
                path
            end

            def monitor_pod_end(name, *requirements)
                nil
            end

            def monitor_print_post_install_message_begin
                
            end

            def monitor_print_post_install_message_end
                UI.puts "Pod::X installation complete! There are #{@repos.size} dependencies from the `pods` file and #{@repos.size} total pods installed.".green
            end

        end
    end
end