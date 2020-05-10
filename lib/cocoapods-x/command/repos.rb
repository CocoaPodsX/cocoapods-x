require 'cocoapods-x/extension/sandbox'
require 'cocoapods-x/extension/configure'
require 'cocoapods-x/extension/environment'

module Pod
    class Command
        class X < Command
            class Repos < X

                self.summary = 'Opens repos'
                self.description = <<-DESC
                Open a dir of pod named `NAME`.
                DESC

                self.arguments = [
                    CLAide::Argument.new('NAME', true),
                ]

                def initialize(argv)
                    @name = argv.shift_argument
                    super
                end

                def run
                    begin
                        if @name.nil? || @name.size <= 0
                            open_project_repos!
                            open_workspace_repos!
                        else
                            open_repo! @name
                        end
                    rescue => exception
                        puts "[!] Pod::X #{exception}".red
                    end
                end

                private 

                extend Executable
                executable :open

                def open_project_repos!
                    begin
                        project = Pod::X::Environment::init!
                        open! [project.root]
                    rescue => exception
                    end
                end

                def open_workspace_repos!
                    workspace = Pod::X::Environment::install!
                    open! [workspace.root]
                end

                def open_repo! name
                    environment = Pod::X::Environment::environment
                    podinfo = environment.podinfo?(name, '')
                    unless podinfo.nil?
                        path = environment.pod_path? podinfo
                        unless path.nil?
                            open! [path]
                        else
                            raise Informative, "No `#{name}' found in the project directory."
                        end                        
                    else
                        raise Informative, "No `#{name}' found in the project directory."
                    end
                end

            end
        end
    end
end
  