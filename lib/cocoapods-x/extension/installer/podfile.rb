module Pod
    class Podfile

        xold_podfile_init_method = instance_method(:initialize)
        define_method(:initialize) do |defined_in_file = nil, internal_hash = {}, &block|
            installer = Pod::X::Installer::installer
            installer.init_self = self
            installer.init_method = xold_podfile_init_method

            installer::monitor_initialize_begin(defined_in_file, internal_hash, &block)
            result = xold_podfile_init_method.bind(self).(defined_in_file, internal_hash, &block)
            installer::monitor_initialize_end(defined_in_file, internal_hash, &block)
            result
        end

        module DSL

            xold_target_method = instance_method(:target)
            define_method(:target) do |name, options = nil, &block|
                installer = Pod::X::Installer::installer
                installer.target_self = self
                installer.target_method = xold_target_method

                installer::monitor_target_begin(name, options, &block)
                result = xold_target_method.bind(self).(name, options, &block)
                installer::monitor_target_end(name, options, &block)
                result
            end

            xold_pod_method = instance_method(:pod)
            define_method(:pod) do |name, *requirements|
                installer = Pod::X::Installer::installer
                installer.pod_self = self
                installer.pod_method = xold_pod_method

                path = installer::monitor_pod_begin(name, *requirements)
                if path
                    result = xold_pod_method.bind(self).(name, :path => path)
                else
                    result = xold_pod_method.bind(self).(name, *requirements)
                end
                installer::monitor_pod_end(name, *requirements)
                result
            end

        end
    end
end

module Pod
    class Installer

        xold_print_post_install_message_method = instance_method(:print_post_install_message)
        define_method(:print_post_install_message) do
            installer = Pod::X::Installer::installer
            installer.print_post_install_message_self = self
            installer.print_post_install_message_method = xold_print_post_install_message_method

            installer::monitor_print_post_install_message_begin()
            result = xold_print_post_install_message_method.bind(self).()
            installer::monitor_print_post_install_message_end()
            result
        end

    end
end