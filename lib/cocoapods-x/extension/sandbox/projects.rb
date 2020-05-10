require 'cocoapods-x/extension/sandbox/protocol'

module Pod
    module X
        class Sandbox
            class Projects < Pod::Sandbox

                include Pod::X::Sandbox::Protocol

                def initialize url
                    super File.join(url, 'projects')
                end

                def install!
                    
                end

                def update!

                end

            end
        end
    end
end