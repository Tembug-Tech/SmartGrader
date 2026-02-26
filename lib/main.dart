import 'dart:io';
import 'student.dart';
import 'excel_service.dart';

/// Main entry point for the Student Grade Calculator program.
/// 
/// Demonstrates all test scenarios:
/// 1. Normal case with valid student data from a populated Excel file
/// 2. Empty Excel file with no data
/// 3. Case where some scores are invalid (below 0 or above 100)
/// 4. Student with a null or missing name
void main() {
  print('=' * 70);
  print('STUDENT GRADE CALCULATOR - DART IMPLEMENTATION');
  print('=' * 70);
  print('');
  
  // Create test directories
  final testDir = Directory('test_data');
  if (!testDir.existsSync()) {
    testDir.createSync();
  }
  
  // ========================================
  // SCENARIO 1: Normal case with valid data
  // ========================================
  print('=' * 70);
  print('SCENARIO 1: Normal Case with Valid Student Data');
  print('=' * 70);
  
  ExcelService.createSampleInputFile('test_data/input_normal.xlsx', SampleType.normal);
  print('Created input file: test_data/input_normal.xlsx');
  print('');
  
  final students1 = ExcelService.readStudentData('test_data/input_normal.xlsx');
  
  if (students1.isEmpty) {
    print('No students to process.');
  } else {
    print('Processing ${students1.length} student(s)...');
    print('');
    
    for (final student in students1) {
      _printStudentResult(student);
    }
  }
  
  // Write results to output file
  ExcelService.writeResults('test_data/output_normal.xlsx', students1);
  print('');
  
  // ========================================
  // SCENARIO 2: Empty Excel file
  // ========================================
  print('=' * 70);
  print('SCENARIO 2: Empty Excel File with No Data');
  print('=' * 70);
  
  ExcelService.createSampleInputFile('test_data/input_empty.xlsx', SampleType.empty);
  print('Created input file: test_data/input_empty.xlsx');
  print('');
  
  final students2 = ExcelService.readStudentData('test_data/input_empty.xlsx');
  
  if (students2.isEmpty) {
    print('No students found to process.');
    print('Message: The Excel file has no data rows (only headers or empty).');
  } else {
    print('Processing ${students2.length} student(s)...');
    for (final student in students2) {
      _printStudentResult(student);
    }
  }
  
  ExcelService.writeResults('test_data/output_empty.xlsx', students2);
  print('');
  
  // ========================================
  // SCENARIO 3: Invalid scores
  // ========================================
  print('=' * 70);
  print('SCENARIO 3: Invalid Scores (Below 0 or Above 100)');
  print('=' * 70);
  
  ExcelService.createSampleInputFile('test_data/input_invalid.xlsx', SampleType.invalidScores);
  print('Created input file: test_data/input_invalid.xlsx');
  print('');
  
  final students3 = ExcelService.readStudentData('test_data/input_invalid.xlsx');
  
  if (students3.isEmpty) {
    print('No students to process.');
  } else {
    print('Processing ${students3.length} student(s)...');
    print('');
    
    for (final student in students3) {
      _printStudentResult(student);
    }
  }
  
  ExcelService.writeResults('test_data/output_invalid.xlsx', students3);
  print('');
  
  // ========================================
  // SCENARIO 4: Null/Missing Name
  // ========================================
  print('=' * 70);
  print('SCENARIO 4: Student with Null or Missing Name');
  print('=' * 70);
  
  ExcelService.createSampleInputFile('test_data/input_nullname.xlsx', SampleType.nullName);
  print('Created input file: test_data/input_nullname.xlsx');
  print('');
  
  final students4 = ExcelService.readStudentData('test_data/input_nullname.xlsx');
  
  if (students4.isEmpty) {
    print('No students to process.');
  } else {
    print('Processing ${students4.length} student(s)...');
    print('');
    
    for (final student in students4) {
      _printStudentResult(student);
    }
  }
  
  ExcelService.writeResults('test_data/output_nullname.xlsx', students4);
  print('');
  
  // ========================================
  // Summary
  // ========================================
  print('=' * 70);
  print('SUMMARY');
  print('=' * 70);
  print('');
  print('Test scenarios completed successfully!');
  print('');
  print('Input files created:');
  print('  - test_data/input_normal.xlsx (Normal valid data)');
  print('  - test_data/input_empty.xlsx (Empty file)');
  print('  - test_data/input_invalid.xlsx (Invalid scores)');
  print('  - test_data/input_nullname.xlsx (Null/missing names)');
  print('');
  print('Output files created:');
  print('  - test_data/output_normal.xlsx');
  print('  - test_data/output_empty.xlsx');
  print('  - test_data/output_invalid.xlsx');
  print('  - test_data/output_nullname.xlsx');
  print('');
  print('=' * 70);
  print('PROGRAM COMPLETED');
  print('=' * 70);
  
  // Keep terminal open to view output
  stdin.readLineSync();
}

/// Prints a detailed result for a student.
/// 
/// Shows:
/// - Student name (or default if null/empty)
/// - Average score (or message if no valid scores)
/// - Letter grade (or message if no grade can be assigned)
/// - Any warnings about invalid scores
void _printStudentResult(Student student) {
  print('-----------------------------------');
  print('Student Name: ${student.displayName}');
  
  if (student.scores == null || student.scores!.isEmpty) {
    print('Status: No scores to process');
    print('Average: N/A');
    print('Letter Grade: N/A');
    print('Note: Score list is null or empty');
  } else {
    final average = student.calculateAverage();
    final grade = student.getLetterGrade();
    
    if (average == null) {
      print('Status: No valid scores to calculate');
      print('Average: N/A (all scores were invalid)');
      print('Letter Grade: N/A');
    } else {
      print('Average Score: ${average.toStringAsFixed(2)}');
      print('Letter Grade: $grade');
    }
    
    // Show invalid scores warning
    if (student.invalidScores.isNotEmpty) {
      print('Warning: Invalid scores found: ${student.invalidScores.join(', ')}');
      print('(Scores below 0 or above 100 were skipped in calculations)');
    }
  }
  
  print('');
}
