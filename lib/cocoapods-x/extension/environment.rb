require 'cocoapods-x/extension/sandbox'
require 'cocoapods-x/extension/configure'

module Pod
    module X
        class Environment

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

        end
    end
end