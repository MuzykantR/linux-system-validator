Feature: Storage Information Validation
    As a system validation engineer
    I want to accurately collect storage information and monitor storage load
    So that I can ensure test environments meet performance requirements

Background:
  Given the Linux System Validator is properly installed
  And all required dependencies are available
  And the system has mounted storage devices

Scenario: Complete storage information output in basic mode
    Given the system has working storage devices
    And storage devices are properly mounted
    When I run "sysval" command
    Then the output should contain complete storage information including:
      | section               | expected_content                      |
      | Root partition        | root filesystem device (e.g., /dev/sdd) |
      | Total space           | total storage capacity                |
      | Used space            | used storage with percentage          |
      | Free space            | available storage space               |
      | Mounted on            | root mount point (/)                  |
      | All mounted partitions| list of all mounted filesystems       |

Scenario: Complete storage information output in detailed mode
    Given the system has working storage devices
    And storage devices are properly mounted
    When I run "sysval -d" command
    Then the output should contain complete storage information including:
      | section               | expected_content                      |
      | Root partition        | root filesystem device (e.g., /dev/sdd) |
      | Total space           | total storage capacity                |
      | Used space            | used storage with percentage          |
      | Free space            | available storage space               |
      | Mounted on            | root mount point (/)                  |
      | All mounted partitions| list of all mounted filesystems       |
      | Write speed           | storage write performance in GB/s     |
      | Read speed            | storage read performance in GB/s      |