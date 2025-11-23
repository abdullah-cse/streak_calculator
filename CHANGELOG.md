## [0.2.2] - 2025-11-24
- **chore(readme)**: Add Streak Calculator Screenshot

## [0.2.1] - 2025-10-01
- **doc(readme)**: Simplified readme.

## [0.2.0] - 2025-09-20

- **doc(readme)**: Add readme with proper documentation.
- **test(monthly_streak_calculator)**: Write monthly streak calculator from scratch.
- Remove unused month_key_generator.

## [0.1.5] - 2025-09-19

- **doc(readme)**: Add readme with proper documentation.
- **test(benchmark)**: Add benchmark test to see performance.
- **chore(pubspec)**: Downgrade Dart SDK from `>=3.0.0 <4.0.0` to `>=2.19.0 <4.0.0` for broader compatibility.

## [0.1.4] - 2025-09-19

- **Refactor(streak_calculator_base)**: Enhance validation logic and remove redundant streak validator class
- **test(streak_calculator_base)**: Add unit test.
- **doc(streak_calculator_base)**: Add doc comment with example

## [0.1.3] - 2025-09-18

- **Refactor(streak calculator)**: Simplify streak calculation logic

## [0.1.1] - 2025-09-16

- **Refactor(weekly streak calculator)** : Weekly streak calculation based on weekStart date and streakTarget.
- **test(weeklyStreakCalculator)**: Rewrite the Unit test covering real case scenario.
- Removed unused test files related to streak result and utilities.

## [0.1.0] - 2025-09-12

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
- `WeekStartDay` for customizable week boundaries
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

