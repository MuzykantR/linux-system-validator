Feature: Error Handling and Input Validation
    As a system user
    I want the validator to handle invalid inputs and edge cases gracefully
    So that I get clear error messages and can fix issues

Background:
    Given the Linux System Validator is properly installed
    And all core dependencies are available

Scenario: Help information display
    When I run "sysval --help" command
    Then the output should contain usage information
    And the output should list available options

Scenario: Help information display with short option
    When I run "sysval -h" command
    Then the output should contain usage information

Scenario: Unknown option handling
    When I run "sysval --invalid-option" command
    Then the output should contain "Unknown option: --invalid-option"
    And the output should suggest using --help
    And the exit code should be 1

Scenario: Unknown short option handling
    When I run "sysval -x" command
    Then the output should contain "Unknown option: -x"
    And the output should suggest using --help
    And the exit code should be 1

Scenario: Basic mode by default
    When I run "sysval" command without options
    Then the script should execute in basic mode
    And the output should contain "Mode: basic"
    And the exit code should be 0

Scenario: Explicit basic mode
    When I run "sysval --basic" command
    Then the script should execute in basic mode
    And the output should contain "Mode: basic"
    And the exit code should be 0

Scenario: Short basic mode
    When I run "sysval -b" command
    Then the script should execute in basic mode
    And the output should contain "Mode: basic"
    And the exit code should be 0

Scenario: Detailed mode
    When I run "sysval --detailed" command
    Then the script should execute in detailed mode
    And the output should contain "Mode: detailed"
    And the exit code should be 0

Scenario: Short detailed mode
    When I run "sysval -d" command
    Then the script should execute in detailed mode
    And the output should contain "Mode: detailed"
    And the exit code should be 0

Scenario: Multiple valid options (last one wins)
    When I run "sysval --basic --detailed" command
    Then the script should execute in detailed mode
    And the output should contain "Mode: detailed"
    And the exit code should be 0

Scenario: Mixed valid and invalid options
    When I run "sysval --basic --invalid --detailed" command
    Then the output should contain "Unknown option: --invalid"
    And the output should suggest using --help
    And the exit code should be 1