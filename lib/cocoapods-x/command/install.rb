module Pod
    class Command
        class X < Command
            class Install < X

                self.summary = Pod::Command::Install::summary

                self.description = Pod::Command::Install::description

                def self.options
                    Pod::Command::Install::options
                end

                def initialize(argv)
                    @install = Pod::Command::Install::new(argv)
                    super
                end

                def run 
                    @install::run
                end

            end
        end
    end
end