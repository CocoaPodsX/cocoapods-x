module Pod
    module X

        module PodsDSL

            def pod(name = nil, *requirements)
                unless name
                    raise StandardError, 'A development requires a name.'
                end

                pod = Hash::new(nil)
                pod[:name] = name
                pod[:share] = true
                options = requirements.last
                if options && options.is_a?(Hash)
                    pod = pod.merge(options.dup)
                end
            
                @pods[name] = pod
            end

        end
        
        module SourcesDSL

            def source(domain, *requirements)
                @current_domain = domain
                options = requirements.last
                if options && options.is_a?(Hash) && options[:group]
                    @current_group = options[:group]
                end

                yield if block_given? 
                ensure
                @current_domain = nil
                @current_group = nil
            end

            def pod(name = nil, *requirements)
                unless name
                    raise StandardError, 'A development requires a name.'
                end

                return if @current_domain.nil?

                source = Hash::new(nil)
                source[:domain] = @current_domain
                source[:git] = name + '.git'
                source[:name] = name
                if @current_group
                    source[:group] = @current_group
                else 
                    source[:group] = name
                end

                options = requirements.last
                if options && options.is_a?(Hash)
                    source = source.merge(options.dup)
                end

                @sources[name] = source
            end

        end

        module BuilderDSL

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
