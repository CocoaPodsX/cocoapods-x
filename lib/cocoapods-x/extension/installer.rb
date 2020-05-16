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

            attr_accessor :repos
            attr_accessor :use_repos

            extend Executable
            executable :rm
            executable :git

            def initialize 
                @project = nil
                @workspace = nil
                @pods_builder = Pod::X::PodsBuilder::new
                @sources_builder = Pod::X::SourcesBuilder::new
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
                @repos = build_repos()
                @use_repos = Array::new
                UI.puts 'Pod::X '.magenta + 'Working...'.green
            end

            def monitor_initialize_end(defined_in_file = nil, internal_hash = {}, &block)
                return nil if @repos.nil?
                return nil if @use_repos.nil?

                @use_repos.each do |name|
                    repo = @repos[name]
                    repo_url = repo.repo_url
                    location_url = repo.location_url
                    if repo_url.nil? || location_url.nil?
                        UI.puts 'Pod::X '.magenta + "You must specify a repository to clone for '#{name}'.".yellow
                    elsif !Dir::exist?(location_url) || Dir::empty?(location_url)
                        UI.section('Pod::X '.magenta + "Cloning into '#{name}'...".green) do 
                            UI.puts 'Pod::X '.magenta + "'#{name}' from: #{repo_url}".magenta
                            UI.puts 'Pod::X '.magenta + "'#{name}' to: #{location_url}".magenta
                            rm! ['-rf', location_url]
                            git! ['clone', repo_url, location_url]
                        end
                    end
                end
            end

            def monitor_target_begin(name, options = nil, &block)

            end
            
            def monitor_target_end(name, options = nil, &block)

            end

            def monitor_pod_begin(name, *requirements)
                return nil if @repos.nil?
                return nil if @repos[name].nil?
                return nil if @use_repos.nil?
                unless @use_repos.include?(name)
                    @use_repos << name
                end
                @repos[name].location_url
            end

            def monitor_pod_end(name, *requirements)
                nil
            end

            def monitor_print_post_install_message_begin
                return nil if @repos.nil?
                return nil if @use_repos.nil?
                return nil if @use_repos.size <= 0

                @use_repos.each do |name|
                    repo = @repos[name]
                    location_url = repo.location_url
                    unless location_url.nil?
                        Dir.chdir(location_url) do
                            begin
                                branch = git! ['rev-parse', '--abbrev-ref', 'HEAD']
                                branch = branch.chomp
                                UI.puts 'Pod::X '.magenta + "Installing #{name} (#{branch.red})".green
                            rescue => exception
                                UI.puts 'Pod::X '.magenta + "Installing #{name}".green
                            end
                        end
                    end
                end
                UI.puts 'Pod::X '.magenta + "installation complete!".green
            end

            def monitor_print_post_install_message_end

            end

            private

            def build_repos
                return nil if @pods_builder.nil?
                return nil if @sources_builder.nil?

                repos = Hash::new(nil)
                @pods_builder.pods.each do | name, pod_argv |
                    source_argv = @sources_builder.sources[name]
                    repo = Pod::X::Sandbox::Repos::Repo(name, pod_argv, source_argv, @workspace, @project)
                    unless repo.nil?
                        repos[name] = repo
                    end
                end
                repos
            end

        end
    end
end