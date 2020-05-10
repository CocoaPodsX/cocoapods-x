
module Pod
    module X
        module DSLBuilder

            def build url
                contents = File.exist?(url) ? File.open(url, 'r:utf-8', &:read) : nil
                # Work around for Rubinius incomplete encoding in 1.9 mode
                if !contents.nil? && contents.respond_to?(:encoding) && contents.encoding.name != 'UTF-8'
                    contents.encode!('UTF-8')
                end
                if !contents.nil? && contents.tr!('“”‘’‛', %(""'''))
                    # Changes have been made
                    CoreUI.warn "Smart quotes were detected and ignored in your #{File.basename(url)}. " \
                                'To avoid issues in the future, you should not use ' \
                                'TextEdit for editing it. If you are not using TextEdit, ' \
                                'you should turn off smart quotes in your editor of choice.'
                end
                unless contents.nil?
                    begin
                        eval(contents, nil, url.to_s)
                    rescue Exception => e
                        message = "Invalid `#{File.basename(url)}` file: #{e.message}"
                        raise DSLError.new(message, url, e, contents)
                    end
                end
            end

        end
    end
end

module Pod
    module X
        class Pods
            module DSL

                def pod(name = nil, *requirements)
                    unless name
                        raise StandardError, 'A development requires a name.'
                    end
                    @current_pods_definition.store_pod(name, *requirements)
                end

            end
        end
    end
end

module Pod
    module X
        class Source
            module DSL

                def source(domain, options = nil)
                    if options
                        raise Informative, "Unsupported options `#{options}` for domain `#{domain}`."
                    end
    
                    @current_domain_definition = Pod::X::Source::Definition::new(domain, @parent)
                    yield if block_given?
                ensure
                    @current_domain_definition = nil
                end
    
                def pod(name = nil, *requirements)
                    unless name
                        raise StandardError, 'A development requires a name.'
                    end
                    @current_domain_definition.store_pod(name, *requirements)
                end

            end
        end
    end
end