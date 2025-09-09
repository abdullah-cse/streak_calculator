## [1.0.0] - 2024-01-15

### Added
- Initial release of the Streak Calculator package
- Support for daily streak calculations with consecutive day counting
- Support for weekly streak calculations with configurable week start days and streak targets
- Support for monthly streak calculations with configurable streak targets
- **New: Streak Target System**
  - Weekly streaks: configurable target of 1-7 days per week required
  - Monthly streaks: configurable target of 1-28 days per month required
  - Daily streaks: streak target parameter ignored (always 1 per day)
- **New: Advanced Data Processing**
  - Automatic duplicate date removal (same day with different times)
  - Automatic data sorting (handles unsorted input datasets)
  - Time component normalization (focuses on dates only)
  - Comprehensive input validation with clear error messages
- `StreakCalculator` class as the main API entry point with enhanced functionality
- `StreakResult` class to encapsulate calculation results
- `StreakType` enum for different streak calculation types
- `WeekStartDay` enum for customizable week boundaries
- High-performance algorithms optimized for large, messy datasets
- Comprehensive documentation and examples with real-world scenarios
- Current streak calculation (including today and yesterday)
- Best streak calculation (longest streak in dataset that meets target requirements)
- O(1) date lookup using HashSet data structure with sorted processing
- Single responsibility principle architecture
- Extensive code documentation with examples

### Features
- **Daily Streaks**: Calculate consecutive days with activity
- **Weekly Streaks**: Calculate consecutive weeks with at least N active days (1-7 configurable)
- **Monthly Streaks**: Calculate consecutive months with at least N active days (1-28 configurable)
- **Configurable Week Start**: Support for all 7 days as week start options
- **Data Cleaning**: Automatically handles unsorted dates, duplicates, and time normalization
- **Streak Target Validation**: Comprehensive validation with helpful error messages
- **Performance Optimized**: Efficient handling of large, messy date datasets
- **Clean API**: Simple, intuitive method signatures with optional parameters
- **Null Safety**: Full null safety support
- **Error Handling**: Proper validation and error messages for all edge cases

### Performance Characteristics
- O(n log n) time complexity for initial data cleaning and sorting
- O(1) average time complexity for date lookups during streak calculation
- Memory efficient date normalization and duplicate removal
- Optimized for datasets with 10,000+ entries including duplicates and random order
- Smart filtering for streak target calculations

### Data Processing Features
- **Automatic Deduplication**: Removes dates that fall on the same day regardless of time
- **Time Normalization**: Strips hours, minutes, seconds - focuses on date only
- **Intelligent Sorting**: Handles completely unsorted input data
- **Validation**: Comprehensive parameter validation with clear error messages

### Documentation
- Comprehensive README with usage examples and real-world scenarios
- API documentation for all public classes and methods
- Performance guidelines and benchmarks
- Multiple usage scenarios including habit tracking, goal setting, and analytics
- Complete examples showing data processing capabilities
