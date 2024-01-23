# frozen_string_literal: true

module RuboCop
  module Cop
    module Rake
      # Detects class or module definition in a namespace,
      # because it is defined to the top level.
      # It is confusing because the scope looks in the namespace,
      # but actually it is defined to the top level.
      #
      # @example
      #   # good
      #   task :foo do
      #     class C
      #     end
      #   end
      #
      #   # bad
      #   namespace :foo do
      #     module M
      #     end
      #   end
      #
      #   # good - It is also defined to the top level,
      #   #        but it looks expected behavior.
      #   class C
      #   end
      #   task :foo do
      #   end
      #
      class ClassDefinitionInNamespace < Base
        MSG = 'Do not define a %<type>s in a rake namespace, because it will be defined to the top level.'

        def on_class(node)
          return if Helper::ClassDefinition.in_class_definition?(node)
          return if Helper::TaskDefinition.in_task?(node)

          return unless Helper::TaskDefinition.in_namespace?(node)

          add_offense(node, message: format(MSG, type: node.type))
        end

        alias on_module on_class
      end
    end
  end
end
