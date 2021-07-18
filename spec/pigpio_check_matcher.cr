struct PigpioCheckMatcher(ExpectedType) < Spectator::Matchers::ValueMatcher(ExpectedType)
  def description : String
    "is checked against x_pigpio#CHECK"
  end

  private def match?(actual : Spectator::TestExpression(T)) : Bool forall T
    exp, pc = expected.value
    ((actual.value >= (((1e2 - pc) * exp)/1e2)) && (actual.value <= (((1e2 + pc) * exp)/1e2)))
  end

  private def failure_message(actual : Spectator::TestExpression(T)) : String forall T
    "#{actual.label} failed to check against #{expected.label}"
  end
end

macro be_checked_against(expected, pc = 0)
  %tuple = Tuple(Int32, Int32).new({{expected}}, {{pc}})
  %label = "{{expected}} (pc: {{pc}})"
  %test_value = ::Spectator::TestValue(%tuple, %label)
  PigpioCheckMatcher.new(%test_value)
end
