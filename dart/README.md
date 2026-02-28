# Student Grade Calculator - Dart Implementation

A Dart program that reads student data from Excel files, calculates average scores and letter grades, and writes results to output Excel files.

## Project Structure

```
SmartGrader/
├── pubspec.yaml
├── lib/
│   ├── main.dart          # Main entry point with test scenarios
│   ├── student.dart       # Student class with nullable fields
│   └── excel_service.dart # Excel file read/write operations
└── test_data/             # Generated test files (created on run)
```

## Requirements

- Dart SDK 3.0+ or Flutter SDK
- Microsoft Excel (for viewing input/output files)

## How to Run

### Option 1: Using Flutter (Recommended)

1. Navigate to the project directory:
   ```bash
   cd c:/Users/PFI/Desktop/SmartGrader
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the program:
   ```bash
   flutter run lib/main.dart
   ```

### Option 2: Using Dart Directly

1. Navigate to the project directory:
   ```bash
   cd c:/Users/PFI/Desktop/SmartGrader
   ```

2. Get dependencies:
   ```bash
   dart pub get
   ```

3. Run the program:
   ```bash
   dart run lib/main.dart
   ```

### Option 3: Using Full Path (if Flutter/Dart not in PATH)

```bash
C:\flutter\bin\flutter pub get
C:\flutter\bin\flutter run lib/main.dart
```

## Test Scenarios

The program demonstrates 4 test scenarios:

1. **Normal Case** - Students with valid scores (85, 90, 78, 92, 88)
2. **Empty File** - Excel file with only headers, no data
3. **Invalid Scores** - Scores below 0 or above 100 (105, -5, 110, -10)
4. **Null/Missing Names** - Empty or whitespace-only name fields

## Output

- Console output showing student results for each scenario
- Excel files in `test_data/` folder:
  - `input_normal.xlsx`, `input_empty.xlsx`, `input_invalid.xlsx`, `input_nullname.xlsx`
  - `output_normal.xlsx`, `output_empty.xlsx`, `output_invalid.xlsx`, `output_nullname.xlsx`

## Features

- Nullable name field (defaults to "Unknown Student")
- Nullable scores list (handles null/empty gracefully)
- Invalid score detection (< 0 or > 100)
- Letter grade calculation: A (≥90), B (80-89), C (70-79), D (60-69), F (<60)
- Excel file read/write using `excel` package
