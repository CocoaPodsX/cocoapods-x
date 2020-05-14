require 'cocoapods-x/extension/xcode/open'

module Pod
    class Command
        class X < Command
            class Install < X

                self.summary = Pod::Command::Install::summary

                self.description = Pod::Command::Install::description

                def self.options
                    options = Pod::Command::Install::options
                    options << ['--open', 'Remove all the cached without asking']
                    options
                end

                def initialize(argv)
                    @wipe_all = argv.flag?('open')
                    @install = Pod::Command::Install::new(argv)
                    super
                end

                def run 
                    @install::run
                    if @wipe_all
                        xcopen = Pod::X::Xcode::Open::new
                        xcopen.run!
                    end
                end

            end
        end
    end
end