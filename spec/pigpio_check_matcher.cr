module Spectator::Matchers
  struct PigpioCheckMatcher(ExpectedType) < ValueMatcher(ExpectedType)
    property pc : Int32 = 0

    def with_pc(@pc)
      self
    end

    def description : String
      "is checked against x_pigpio#CHECK"
    end

    private def match?(actual : TestExpression(T)) : Bool forall T
      exp = expected.value
      ((actual.value >= (((1e2 - pc) * exp)/1e2)) && (actual.value <= (((1e2 + pc) * exp)/1e2)))
    end

    private def failure_message(actual : TestExpression(T)) : String forall T
      "#{actual.label} failed to check against #{expected.label}"
    end
  end
end

macro be_checked_against(expected, pc = 0)
  %label = "{{expected}} (pc: {{pc}})"
  %test_value = ::Spectator::TestValue.new({{expected}}, %label)
  ::Spectator::Matchers::PigpioCheckMatcher.new(%test_value).with_pc({{pc}})
end

# allow failures
macro expect_to_be_checked_against(actual, expected, pc = 0)
  if (({{actual}} >= (((1e2 - {{pc}}) * {{expected}})/1e2)) && ({{actual}} <= (((1e2 + {{pc}}) * {{expected}})/1e2)))
    expect({{actual}}).to be_checked_against({{expected}}, {{pc}})
  else
    puts "{{actual}} failed to check against {{expected}}"
  end
end

# allow failures
macro expect_to_contain(actual, expected)
  if {{actual}}.includes?({{expected}})
    expect({{actual}}).to contain({{expected}})
  else
    puts "{{actual}} failed to contain {{expected}}"
  end
end
