Feature: Memory Information Validation
    As a system validation engineer  
    I want to accurately collect memory usage metrics
    So that I can ensure test environments have sufficient resources

Background:
  Given the Linux System Validator is properly installed
  And all required dependencies are available
  And the system has active memory allocation

Scenario: Complete memory information output in both modes
    Given the system has allocated memory resources
    And the user has access to memory information
    When I run "sysval" command
    Then the output should contain complete memory information including:
      | section    | expected_content                         |
      | Total RAM  | total physical RAM size                  |
      | Used RAM   | used physical RAM with percentage        |
      | Free RAM   | available physical RAM                   |
      | Swap       | total swap size and usage percentage     |
    And memory indicators should reflect current usage levels