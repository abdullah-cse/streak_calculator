## [0.2.5] - 2025-12-17
- **feat(test)**: Add streak result test.
- **feat(test)**: Add date normalizer test.
- **feat(CD)**: Add auto publishing to pub.dev with GitHub Action. 

## [0.2.4] - 2025-12-14
- **fix(readme)**: Fixed a typo in CodeCoverage badge so, badge are showing code coverage.
  
## [0.2.3] - 2025-12-14
- **feat(codecov)**: Add Code Coverage Metrics to **Build Trust** in **Code Quality**.
- **feat(test)**: Add `FakeDateNormalizer`, so we can control "today".
- **feat(ci)**: Add Dart CI to test on push Main | pull Main.
- **fix(test)**: Fix some test to use improved `FakeDateNormalizer` instead of `referencedate`.
- **fix(readme)**: Add Code Coverage badge.
- **chore (core)**: Full path import in every file to eliminate ambiguity.


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
