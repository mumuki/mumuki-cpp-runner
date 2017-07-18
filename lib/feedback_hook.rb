class CppFeedbackHook < Mumukit::Hook
  def run!(request, results)
    content = request.content
    test_results = results.test_results[0]

    CppExplainer.new.explain(content, test_results)
  end

  class CppExplainer < Mumukit::Explainer

    def near_regex()
      '.*[\t \n]* *(.*)\n[ \t]+\^'
    end

    def explain_has_no_member_named(_, result)
      (/error: '(.*)' has no member named '(.*)'#{near_regex}/.match result).try do |it|
        {type: it[1], target: it[2], near: it[3]}
      end
    end

    def explain_was_not_declared_in_this_scope(_, result)
      (/error: '(.*)' was not declared in this scope#{near_regex}/.match result).try do |it|
        {target: it[1], near: it[2]}
      end
    end

    def explain_does_not_a_type(_, result)
      (/error: '(.*)' does not name a type#{near_regex}/.match result).try do |it|
        {type: it[1], near: it[2]}
      end
    end

    def explain_has_incomplete_type_and_cannot_be_defined(_, result)
      (/error: aggregate '(.*)' has incomplete type and cannot be defined#{near_regex}/.match result).try do |it|
        {type: it[1], near: it[2]}
      end
    end

    def explain_invalid_suffix(_, result)
      (/error: invalid suffix "(.*)" on integer constant#{near_regex}/.match result).try do |it|
        {suffix: it[1], near: it[2]}
      end
    end

    def explain_expected_comma_before_token(_, result)
      (/error: expected ',' or '.{3}' before '\.' token#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end

    def explain_expected_initializer_before_token(_, result)
      (/error: expected initializer before '.' token#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end

    def explain_too_many_arguments_to_function(_, result)
      (/error: too many arguments to function '(.*)'#{near_regex}/.match result).try do |it|
        {target: it[1], near: it[2]}
      end
    end

    def explain_too_few_arguments_to_function(_, result)
      (/error: too few arguments to function '(.*)'#{near_regex}/.match result).try do |it|
        {target: it[1], near: it[2]}
      end
    end

    def explain_call_of_overloaded_is_ambiguous(_, result)
      (/error: call of overloaded '(.*)' is ambiguous#{near_regex}/.match result).try do |it|
        {target: it[1], near: it[2]}
      end
    end

    def explain_invalid_conversion_from_to(_, result)
      (/error: invalid conversion from '(.*)' to '(.*)'#{near_regex}/.match result).try do |it|
        {expected: it[1], actual: it[2], near: it[3]}
      end
    end

    def explain_expected_after_struct_definition(_, result)
      (/error: expected ';' after struct definition#{near_regex}/.match result).try do |it|
        {near: it[1]}
      end
    end

    def explain_expected_initializer_before(_, result)
      (/error: expected initializer before '(.*)'#{near_regex}/.match result).try do |it|
        {near: it[2]}
      end
    end

  end
end
