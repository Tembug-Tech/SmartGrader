# Student Grade Calculator

A Kotlin-based desktop application that reads student grades from an Excel file and calculates letter grades (A, B, C, D, F) for each student.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Building the Project](#building-the-project)
- [Running the Application](#running-the-application)
- [Excel File Format](#excel-file-format)
- [How It Works](#how-it-works)
- [Code Overview](#code-overview)
- [Sample Output](#sample-output)

## Overview

This application provides an interactive command-line interface that:
1. Displays a welcome message
2. Prompts the user to enter the path to an Excel file
3. Reads student data (name and grade) from the Excel file
4. Calculates letter grades based on numeric scores
5. Displays each student's result

## Features

- **Excel File Support**: Reads .xlsx files using Apache POI library
- **Automatic Grade Calculation**: Converts numeric scores to letter grades
- **Input Validation**: Validates that grades are within the 0-100 range
- **User-Friendly Interface**: Clear welcome message and prompts
- **Error Handling**: Handles missing files, invalid data, and empty spreadsheets

## Prerequisites

- **Java Development Kit (JDK) 21** or higher
- **Gradle** (included via Gradle Wrapper)

## Project Structure

```
StudentGradeCalculator/
├── app/
│   ├── build.gradle.kts          # Gradle build configuration
│   └── src/main/kotlin/
│       ├── Main.kt               # Main entry point
│       ├── model/
│       │   └── student.kt        # Student data class
│       └── service/
│           ├── excelservice.kt   # Excel file reading logic
│           └── Gradeservice.kt   # Grade calculation logic
├── gradle/
│   └── wrapper/                   # Gradle wrapper files
├── gradlew                        # Unix Gradle wrapper script
├── gradlew.bat                    # Windows Gradle wrapper script
└── settings.gradle.kts           # Project settings
```

## Building the Project

### Compile the project:

```bash
./gradlew compileKotlin
```

### Build the distribution:

```bash
./gradlew installDist
```

This creates a runnable distribution in `app/build/install/app/`.

## Running the Application

### Option 1: Using the installed distribution (Recommended)

```bash
app\build\install\app\bin\app.bat
```

### Option 2: Using Gradle with command-line argument

```bash
gradle run --args="path/to/your/excel/file.xlsx"
```

### Option 3: Using Gradle (interactive mode)

```bash
gradle run --console=plain
```

## Excel File Format

Your Excel file should follow this format:

| Name     | Grade |
|----------|-------|
| John     | 85    |
| Alice    | 92    |
| Bob      | 78    |
| Charlie  | 65    |

- **Column A**: Student name (text)
- **Column B**: Student grade (number 0-100)
- **Row 1**: Headers (will be skipped)
- **Row 2+**: Student data

## Grade Calculation

The program converts numeric grades to letter grades as follows:

| Score Range | Letter Grade |
|-------------|--------------|
| 90-100      | A            |
| 80-89       | B            |
| 70-79       | C            |
| 60-69       | D            |
| 0-59        | F            |

## How It Works

### 1. Main Entry Point (`Main.kt`)
- Displays welcome message
- Prompts user for Excel file path
- Reads student data
- Processes and displays grades

### 2. Excel Reading Service (`excelservice.kt`)
- Uses Apache POI library to read .xlsx files
- Opens the workbook and reads the first sheet
- Skips the header row
- Parses each row to extract student name and grade
- Returns a list of Student objects

### 3. Grade Calculation Service (`Gradeservice.kt`)
- Takes a numeric score as input
- Returns the corresponding letter grade using Kotlin's `when` expression
- Handles invalid scores gracefully

### 4. Student Model (`student.kt`)
- Data class with two properties: `name` (String) and `grade` (Int?)

## Code Overview

### Main.kt
```kotlin
fun main(args: Array<String>) {
    // Display welcome message
    println("==================================================")
    println("     STUDENT GRADE CALCULATOR PROGRAM")
    println("==================================================")
    println()
    println("This program reads student grades from an Excel file")
    println("and calculates the letter grade for each student.")
    println()
    println("==================================================")
    
    // Get file path from user
    val path = if (args.isNotEmpty()) {
        args[0]
    } else {
        print("Enter the path to your Excel file: ")
        readLine() ?: ""
    }
    
    // Read and process students
    val students = readStudentsFromExcel(path)
    
    // Display results
    for (student in students) {
        val score = student.grade ?: -1
        if (score !in 0..100) {
            println("${student.name} has an invalid grade.")
            continue
        }
        val letter = calculateGrade(score)
        println("${student.name}: $score -> $letter")
    }
}
```

### excelservice.kt (Key Functions)
```kotlin
fun readStudentsFromExcel(path: String): List<Student> {
    // Opens Excel file using Apache POI
    // Reads rows, skips header
    // Returns list of Student objects
}
```

### Gradeservice.kt
```kotlin
fun calculateGrade(score: Int): String {
    return when (score) {
        in 90..100 -> "A"
        in 80..89 -> "B"
        in 70..79 -> "C"
        in 60..69 -> "D"
        in 0..59 -> "F"
        else -> "Invalid grade"
    }
}
```

## Sample Output

```
==================================================
     STUDENT GRADE CALCULATOR PROGRAM
==================================================

This program reads student grades from an Excel file
and calculates the letter grade for each student.

==================================================
Enter the path to your Excel file: C:\Users\finamou\Desktop\StudentGradeCalculator\student.xlsx

Proccessing grades...

Anita: C
John: F
Paul: D
```

## Dependencies

- **Kotlin Standard Library** - Kotlin runtime
- **Apache POI 5.2.5** - Java library for reading/writing Excel files
- **Apache POI-OOXML 5.2.5** - OOXML support for Excel files
- **Log4j Core 2.20.0** - Logging framework

## Troubleshooting

### "File does not exist" error
- Check that the file path is correct
- Use absolute paths (full path from drive letter)
- Example: `C:\Users\YourName\Desktop\StudentGradeCalculator\student.xlsx`

### "No students found" error
- Ensure your Excel file has data starting from row 2
- Check that column A has names and column B has numbers

### Invalid grades
- Grades must be between 0 and 100
- Check your Excel file for typos or extra spaces

## License

This project is for educational purposes.
