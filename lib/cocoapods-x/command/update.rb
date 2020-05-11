module Pod
    class Command
        class X < Command
            class Update < X

                self.summary = Pod::Command::Update::summary

                self.description = Pod::Command::Update::description

                self.arguments = Pod::Command::Update::arguments

                def self.options
                    Pod::Command::Update::options
                end

                def initialize(argv)
                    @update = Pod::Command::Update::new(argv)
                    super
                end

                def run
                    @update::run
                end

            end
        end
    end
end