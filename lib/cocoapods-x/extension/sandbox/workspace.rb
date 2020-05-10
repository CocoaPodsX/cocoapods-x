require 'cocoapods-x/extension/sandbox/protocol'

module Pod
    module X
        class Sandbox
            class Workspace < Pod::Sandbox

                include Pod::X::Sandbox::Protocol

                attr_reader :repos, :template, :projects

                def initialize
                    super File.join(File.expand_path('~'), '.cocoapods/x')
                    @repos = Pod::X::Sandbox::Repos::new root
                    @template = Pod::X::Sandbox::Template::new root
                    @projects = Pod::X::Sandbox::Projects::new root
                end

                def install!
                    @repos.install!
                    @template.install! 
                    @projects.install!

                    unless source_file.exist?
                        cp! [@template::source_file, source_file]
                    end
                end

                def update!
                    @repos.update!
                    @template.update!
                    @projects.update!
                    
                    rm! ['-rf', source_file]
                    cp! [@template::source_file, source_file]
                end

                def source_file
                    root + 'source'
                end
                
            end
        end
    end
end
