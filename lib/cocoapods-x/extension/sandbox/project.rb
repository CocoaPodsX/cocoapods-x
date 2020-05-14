require 'cocoapods-x/extension/sandbox/protocol'

module Pod
    module X
        class Sandbox
            class Project < Pod::Sandbox

                include Pod::X::Sandbox::Protocol

                attr_reader :repos, :conf

                def initialize conf
                    @conf = conf
                    super conf.project_debug_url
                    @repos = Pod::X::Sandbox::Repos::new conf::project_debug_url
                end

                def install!
                    @conf.sync
                    @conf.save!

                    unless pods_file.exist?
                        cp! [Pod::X::Sandbox::workspace::template::pods_file, pods_file]
                    end

                    unless source_file.exist?
                        ln! ['-s', Pod::X::Sandbox::workspace::source_file, source_file]
                    end

                end

                def update!
                    install!
                end

                def pods_file
                    root + 'pods'
                end

                def source_file
                    root + 'sources'
                end

                def project_name 
                    File.basename(@conf.project_url)
                end

            end
        end
    end
end