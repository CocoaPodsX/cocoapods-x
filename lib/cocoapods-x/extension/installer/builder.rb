require 'cocoapods-x/extension/installer/dsl'

module Pod
    module X
        class PodsBuilder

            include Pod::X::PodsDSL
            include Pod::X::BuilderDSL

            attr_accessor :pods

            def initialize
                @pods = Hash::new(nil)
            end

        end

        class SourcesBuilder

            include Pod::X::SourcesDSL
            include Pod::X::BuilderDSL

            attr_accessor :current_domain, :current_group
            attr_accessor :sources

            def initialize
                 @current_domain = nil
                 @current_group = nil
                 @sources = Hash::new(nil)
            end

        end

    end
end

