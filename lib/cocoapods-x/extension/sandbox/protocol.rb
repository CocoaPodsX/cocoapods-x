module Pod
    module X
        class Sandbox
            module Protocol

                extend Executable
                executable :rm
                executable :cp
                executable :ln
                executable :git
                executable :open

                def install!

                end

                def update!
                    
                end

            end
        end
    end
end