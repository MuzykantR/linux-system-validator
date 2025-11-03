Feature: System Validator Dependency Error Handling
    As a system user
    I want all validator modules to handle missing dependencies gracefully
    So that I get meaningful warnings when system utilities are unavailable

Background:
    Given the Linux System Validator is properly installed

Scenario Outline: Missing <command> dependency in <mode> mode
    Given the "<command>" command is not available
    When I run "sysval" in <mode> mode
    Then the output should contain a warning about <command>
    And the output should suggest installing <package>
    And the script should complete successfully

Examples: Command dependencies by mode and module
    | command | mode     | package    | module  |
    | lscpu   | basic    | util-linux | cpu     |
    | lscpu   | detailed | util-linux | cpu     |
    | mpstat  | basic    | sysstat    | cpu     |
    | free    | basic    | procps     | memory  |
    | free    | detailed | procps     | memory  |
    | bc      | basic    | bc         | cpu     |
    | bc      | basic    | bc         | memory  |
    | bc      | detailed | bc         | cpu     |
    | bc      | detailed | bc         | memory  |
    | uptime  | detailed | procps     | cpu     |
    | vmstat  | detailed | procps     | cpu     |
    | ps      | detailed | procps     | cpu     |
    | dd      | detailed | coreutils  | storage |