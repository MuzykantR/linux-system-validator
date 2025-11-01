Feature: CPU and System Information Validation
    As a system validation engineer
    I want to accurately collect CPU metrics and monitor system load
    So that I can ensure test environments meet performance requirements

Background:
  Given the Linux System Validator is properly installed
  And all required dependencies are available
  And the system is in a stable state
  
Scenario: Complete CPU information output in basic mode
    Given the system has a working CPU
    And the user has read access to /proc/cpuinfo
    When I run "sysval" command
    Then the output should contain complete CPU information including:
      | section                   | expected_content                      |
      | Model                     | proccessor model name                 |
      | Architecture              | x86_64, ARM, etc                      |
      | Sockets                   | number of sockets                     |
      | Cores per socket          | number of cores per socket            |
      | Threads per core          | number of threads per core            |
      | Total                     | number of physical cores, all threads |
      | Frequency                 | current frequency in Mhz/Ghz          |
   
Scenario: Complete CPU information output in detailed mode
    Given the system has a working CPU
    And the user has read access to /proc/cpuinfo
    When I run "sysval -d" command
    Then the output should contain complete CPU information including:
      | section                   | expected_content                      |
      | Model                     | proccessor model name                 |
      | Architecture              | x86_64, ARM, etc                      |
      | Sockets                   | number of sockets                     |
      | Cores per socket          | number of cores per socket            |
      | Threads per core          | number of threads per core            |
      | Total                     | number of physical cores, all threads |
      | Frequency                 | current frequency in Mhz/Ghz          |
      | CPU Family                | CPU family number                     |
      | Model                     | CPU model number                      |
      | Stepping                  | CPU stepping                          |
      | L1d                       | L1 data cache size in KiB/MiB         |
      | L1i                       | L1 instruction cache size in KiB/MiB  |
      | L2                        | L2 cache size in KiB/MiB              |
      | L3                        | L3 cache size in KiB/MiB              |
      | Vector Extesions          | AVX, SSE, etc                         |
      | Frequency Range           | frequency range OR "not available"    |

Scenario: Complete Process/System information output in basic mode
    Given the system is running processes
    When I run "sysval" command
    Then the output should contain system load information including:
      | section                   | expected_content                  |
      | Current CPU usage  | total CPU usage percentage               |
      | User               | CPU usage by user processes              |
      | System             | CPU usage by system processes            |
      | Idle               | idle CPU percentage                      |
Scenario: Complete Process/System information output in detailed mode
    Given the system has a working CPU
    When I run "sysval -d" command
    Then the output should contain system load information including:
      | section            | expected_content                         |
      | Current CPU usage  | total CPU usage percentage               |
      | User               | CPU usage by user processes              |
      | System             | CPU usage by system processes            |
      | Idle               | idle CPU percentage                      |
      | Uptime             | system uptime in hours/minutes           |
      | Running processes  | number of running processes              |
      | Blocked processes  | number of blocked processes              |
      | Top processes      | top 5 processes by CPU usage             |

     