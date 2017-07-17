class CppFeedbackHook < Mumukit::Hook
  def run!(request, results)
    content = request.content
    test_results = results.test_results[0]

    CppExplainer.new.explain(content, test_results)
  end

  class CppExplainer < Mumukit::Explainer
    def explain_has_no_member_named(_, result)
      (/error: '(.*)' has no member named '(.*)'/.match result).try do |it|
        {type: it[1], target: it[2]}
      end
    end

    def explain_was_not_declared_in_this_scope(_, result)
      (/error: '(.*)' was not declared in this scope/.match result).try do |it|
        {target: it[1]}
      end
    end

    def explain_does_not_a_type(_, result)
      (/error: '(.*)' does not name a type/.match result).try do |it|
        {type: it[1]}
      end
    end
  end
end
