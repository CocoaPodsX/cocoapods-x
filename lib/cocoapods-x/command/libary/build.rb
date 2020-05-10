module Pod
    class Command
        class X < Command
            class Lib < X
                class Build < Lib

                    self.abstract_command = true
                    self.summary = 'Cocoapods X Lib Build.'

                end
            end
        end
    end
end