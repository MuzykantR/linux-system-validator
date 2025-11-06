Feature: Threshold Indicators Validation
    As a system validation engineer
    I want to ensure that resource usage indicators correctly reflect threshold levels
    So that users can quickly identify system state

Background:
    Given the output.sh module is properly sourced
    And threshold values in percent are loaded from config.sh with defaults:
        | resource_type       | warning_threshold | critical_threshold |
        | CPU                 | 70                | 85                 |
        | Memory              | 80                | 90                 |
        | Storage             | 80                | 90                 |
        | Swap                | 20                | 50                 |

Scenario Outline: Resource threshold indicators display correct symbols and colors
    Given the <resource_type> usage is <usage_percentage>%
    When the indicator logic processes the usage data
    Then the displayed symbol should be <expected_symbol>
    And the displayed color should be <expected_color>

Examples: CPU threshold equivalence classes
    | resource_type | usage_percentage | expected_symbol | expected_color |
    | CPU           | 50               | (✓)             | green          |
    | CPU           | 69               | (✓)             | green          |
    | CPU           | 70               | /!\             | yellow         |
    | CPU           | 80               | /!\             | yellow         |
    | CPU           | 84               | /!\             | yellow         |
    | CPU           | 85               | (X)             | red            |
    | CPU           | 90               | (X)             | red            |

Examples: Memory threshold equivalence classes
    | resource_type | usage_percentage | expected_symbol | expected_color |
    | Memory        | 50               | (✓)             | green          |
    | Memory        | 79               | (✓)             | green          |
    | Memory        | 80               | /!\             | yellow         |
    | Memory        | 85               | /!\             | yellow         |
    | Memory        | 89               | /!\             | yellow         |
    | Memory        | 90               | (X)             | red            |
    | Memory        | 95               | (X)             | red            |

Examples: Storage threshold equivalence classes
    | resource_type | usage_percentage | expected_symbol | expected_color |
    | Storage        | 50               | (✓)             | green          |
    | Storage        | 79               | (✓)             | green          |
    | Storage        | 80               | /!\             | yellow         |
    | Storage        | 85               | /!\             | yellow         |
    | Storage        | 89               | /!\             | yellow         |
    | Storage        | 90               | (X)             | red            |
    | Storage        | 95               | (X)             | red            |

Examples: Swap threshold equivalence classes
    | resource_type | usage_percentage | expected_symbol | expected_color |
    | Swap        | 10               | (✓)             | green          |
    | Swap        | 19               | (✓)             | green          |
    | Swap        | 20               | /!\             | yellow         |
    | Swap        | 30               | /!\             | yellow         |
    | Swap        | 49               | /!\             | yellow         |
    | Swap        | 50               | (X)             | red            |
    | Swap        | 70               | (X)             | red            |