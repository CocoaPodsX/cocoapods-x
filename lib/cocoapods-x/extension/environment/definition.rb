module Pod
    module X
        class Source
            class Definition

                attr_reader :domain
                attr_reader :parent
                attr_reader :children
                attr_reader :map

                def initialize(domain, parent)
                    @domain = domain
                    @parent = parent
                    @children = []
                    @map = Hash::new(nil)
                    if parent.is_a?(Pod::X::Source::Definition)
                        parent.children << self
                    end
                end

                def list
                    hash = Hash::new(nil)
                    hash = hash.merge(@map)
                    for source in children do
                        hash = hash.merge(source.map)
                    end
                    hash
                end

                def store_pod(name = nil, *requirements)
                    options = requirements.last
                    options ||= Hash::new(nil)
                    options = options.is_a?(Hash) ? options : Hash::new(nil)

                    group = options[:group] || name
                    git = options[:git] || "#{name}.git"

                    if domain.start_with? "git@"
                        store_pod_git(name, group, git)
                    elsif domain.size > 0
                        store_pod_http(name, group, git)
                    end
                end

                def store_pod_git(name, group, git)
                    source = "#{domain}:#{group}/#{git}"
                    map[name] = source
                end

                def store_pod_http(name, group, git)
                    source = Pathname(domain)
                    source += group
                    source += git
                    map[name] = source.to_s
                end

            end
        end
    end
end

module Pod
    module X
        class Pods
            class Definition

                attr_reader :map

                def initialize
                    @map = Hash::new(nil)
                end
    
                def list 
                    @map
                end
    
                def store_pod(name = nil, *requirements)
                    options = requirements.last
                    options ||= Hash::new(nil)
                    options = options.is_a?(Hash) ? options : Hash::new(nil)
                    value = options[:share]
                    value  = value.nil? ? true : value
                    value = (value.is_a?(TrueClass) || value.is_a?(FalseClass)) ? value : true
                    @map[name] = value
                end

            end
        end
    end
end
