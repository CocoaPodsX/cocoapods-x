require 'cocoapods-x/extension/environment/dsl'
require 'cocoapods-x/extension/environment/definition'

module Pod
    module X
        class Source

            include Pod::X::Source::DSL
            include Pod::X::DSLBuilder

            attr_reader :parent
            attr_reader :current_domain_definition

            def initialize
                @parent = Pod::X::Source::Definition::new('', nil)
            end

            def list 
                @parent::list
            end

        end
    end
end