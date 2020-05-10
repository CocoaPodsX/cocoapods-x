require 'cocoapods-x/extension/environment/dsl'
require 'cocoapods-x/extension/environment/definition'

module Pod
    module X
        class Pods

            include Pod::X::Pods::DSL
            include Pod::X::DSLBuilder

            attr_reader :current_pods_definition

            def initialize
                @current_pods_definition = Pod::X::Pods::Definition::new
            end

            def list 
                @current_pods_definition::list
            end

        end
    end
end