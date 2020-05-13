require 'cocoapods-x/extension/sandbox'
require 'cocoapods-x/extension/environment'

module Pod
    class Command
        class X < Command
            class Edit < X

                self.summary = 'Cocoapods X Edit.'
                self.description = 'Cocoapods X Edit.'

                def self.options
                    [
                        ['--pods', 'Edit source.rb file.'],
                        ['--source', 'Edit source.rb file.'],
                        ['--podfile', 'Edit Podfile file.']
                    ].concat(super)
                end

                def initialize(argv)
                    @wipe_pods = argv.flag?('pods')
                    @wipe_source = argv.flag?('source')
                    @wipe_podfile = argv.flag?('podfile')
                    super
                end

                def run
                    begin
                        if @wipe_pods
                            open_pods!
                        end
    
                        if @wipe_source
                            open_source!
                        end
    
                        if @wipe_podfile
                            open_podfile!
                        end
                    rescue => exception
                        UI.puts "[!] Pod::X #{exception}".red
                    end

                end

                private

                extend Executable
                executable :open

                def open_pods!
                    project = Pod::X::Environment::init!
                    open! ['-a', 'Xcode', project.pods_file]
                end

                def open_source!
                    workspace = Pod::X::Environment::install!
                    open! ['-a', 'Xcode', workspace.source_file]
                end

                def open_podfile!
                    project_url = Pathname(Dir.pwd) 
                    podfile = Pod::X::Sandbox::podfile_exists! project_url
                    open! ['-a', 'Xcode', podfile]
                end

            end
        end
    end
end