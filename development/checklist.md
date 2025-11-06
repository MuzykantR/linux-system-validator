# Smoke Checklist: Linux System Validator

## Basic Execution
- [ ] Script starts without errors: `./sysval`
- [ ] Help displays correctly: `./sysval -h`
- [ ] Basic mode works: `./sysval --basic`
- [ ] Detailed mode works: `./sysval --detailed`
- [ ] Script completes within 30 second

## Core Modules
- [ ] CPU information is displayed
- [ ] Memory usage is shown
- [ ] Storage information appears
- [ ] Color indicators work (green/yellow/red)

## Error Handling
- [ ] Script handles missing dependencies gracefully
- [ ] Error messages are clear and informative
- [ ] Script doesn't crash on permission issues
- [ ] Invalid arguments show proper usage help