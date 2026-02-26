import 'dart:io';
import 'lib/student.dart';
import 'lib/excel_service.dart';

/// Test script to verify all test scenarios
void main() {
  print('=' * 70);
  print('STUDENT GRADE CALCULATOR - TEST SCRIPT');
  print('=' * 70);
  print('');

  // Test Scenario 1: Normal valid data (Alice Johnson - 85, 90, 78, 92, 88)
  print('=' * 70);
  print('TEST 1: Valid name with valid scores (Alice Johnson: 85, 90, 78, 92, 88)');
  print('=' * 70);
  var students = ExcelService.readStudentData('test_data/input_normal.xlsx');
  if (students.isNotEmpty) {
    var student = students[0];
    var avg = student.calculateAverage();
    var grade = student.getLetterGrade();
    print('Name: ${student.displayName}');
    print('Scores: ${student.scores?.join(", ")}');
    print('Average: ${avg?.toStringAsFixed(2)}');
    print('Grade: $grade');
    print('Expected: Average = 86.60, Grade = B');
    print('Result: ${(avg! - 86.60).abs() < 0.01 && grade == 'B' ? "PASSED" : "FAILED"}');
  }
  print('');

  // Test Scenario 2: Empty Excel file
  print('=' * 70);
  print('TEST 2: Empty Excel file with no data');
  print('=' * 70);
  students = ExcelService.readStudentData('test_data/input_empty.xlsx');
  print('Students found: ${students.length}');
  print('Expected: 0 students');
  print('Result: ${students.length == 0 ? "PASSED" : "FAILED"}');
  print('');

  // Test Scenario 3: Invalid scores (David Lee: 85, 105, 78, -5)
  print('=' * 70);
  print('TEST 3: Invalid scores (-5 and 105 should be skipped)');
  print('=' * 70);
  students = ExcelService.readStudentData('test_data/input_invalid.xlsx');
  if (students.isNotEmpty) {
    var student = students[0];
    var avg = student.calculateAverage();
    var grade = student.getLetterGrade();
    print('Name: ${student.displayName}');
    print('Original scores: 85, 105, 78, -5');
    print('Invalid scores: ${student.invalidScores.join(", ")}');
    print('Average (should exclude 105 and -5): ${avg?.toStringAsFixed(2)}');
    print('Expected: Average = 81.50, Grade = B');
    print('Result: ${(avg! - 81.50).abs() < 0.01 && grade == 'B' ? "PASSED" : "FAILED"}');
  }
  print('');

  // Test Scenario 4: Missing/empty names
  print('=' * 70);
  print('TEST 4: Empty student name should default to "Unknown Student"');
  print('=' * 70);
  students = ExcelService.readStudentData('test_data/input_nullname.xlsx');
  if (students.isNotEmpty) {
    var student = students[0];
    print('Name read: "${student.name}"');
    print('Display name: "${student.displayName}"');
    print('Expected: "Unknown Student"');
    print('Result: ${student.displayName == 'Unknown Student' ? "PASSED" : "FAILED"}');
  }
  print('');

  // Additional Test: Multiple students in normal file
  print('=' * 70);
  print('TEST 5: Multiple students in Excel file');
  print('=' * 70);
  students = ExcelService.readStudentData('test_data/input_normal.xlsx');
  print('Students found: ${students.length}');
  print('Expected: 3 students');
  print('Result: ${students.length == 3 ? "PASSED" : "FAILED"}');
  for (var i = 0; i < students.length; i++) {
    var s = students[i];
    var avg = s.calculateAverage();
    var grade = s.getLetterGrade();
    print('  ${i + 1}. ${s.displayName}: Avg=${avg?.toStringAsFixed(2) ?? "N/A"}, Grade=${grade ?? "N/A"}');
  }
  print('');

  // Additional Test: All invalid scores
  print('=' * 70);
  print('TEST 6: All scores invalid should return null average');
  print('=' * 70);
  var testStudent = Student(name: 'Test', scores: [-10, 150, 200]);
  var avg2 = testStudent.calculateAverage();
  var grade2 = testStudent.getLetterGrade();
  print('Scores: -10, 150, 200');
  print('Invalid scores found: ${testStudent.invalidScores.join(", ")}');
  print('Average: ${avg2 ?? "null"}');
  print('Grade: ${grade2 ?? "null"}');
  print('Expected: Average = null, Grade = null');
  print('Result: ${avg2 == null && grade2 == null ? "PASSED" : "FAILED"}');
  print('');

  // Additional Test: Empty scores list
  print('=' * 70);
  print('TEST 7: Empty scores list');
  print('=' * 70);
  var testStudent2 = Student(name: 'Test', scores: []);
  var avg3 = testStudent2.calculateAverage();
  var grade3 = testStudent2.getLetterGrade();
  print('Scores: []');
  print('Average: ${avg3 ?? "null"}');
  print('Grade: ${grade3 ?? "null"}');
  print('Expected: Average = null, Grade = null');
  print('Result: ${avg3 == null && grade3 == null ? "PASSED" : "FAILED"}');
  print('');

  // ========================================
  // CONSOLE INPUT TESTING SCENARIOS
  // ========================================
  
  // Test Scenario 1: Valid name with valid scores (John Doe, 85, 90, 78)
  print('=' * 70);
  print('CONSOLE TEST 1: Valid student name with valid scores (John Doe, 85, 90, 78)');
  print('=' * 70);
  var consoleStudent1 = Student(name: 'John Doe', scores: [85, 90, 78]);
  var consoleAvg1 = consoleStudent1.calculateAverage();
  var consoleGrade1 = consoleStudent1.getLetterGrade();
  print('Input: Name="John Doe", Scores=[85, 90, 78]');
  print('Calculated Average: ${consoleAvg1?.toStringAsFixed(2)}');
  print('Letter Grade: $consoleGrade1');
  print('Expected: Average = 84.33, Grade = B');
  var passed1 = (consoleAvg1! - 84.33).abs() < 0.01 && consoleGrade1 == 'B';
  print('Result: ${passed1 ? "PASSED" : "FAILED"}');
  print('');

  // Test Scenario 2: Valid name but empty scores
  print('=' * 70);
  print('CONSOLE TEST 2: Valid student name but empty scores');
  print('=' * 70);
  var consoleStudent2 = Student(name: 'John Doe', scores: []);
  var consoleAvg2 = consoleStudent2.calculateAverage();
  var consoleGrade2 = consoleStudent2.getLetterGrade();
  var hasNoScores = consoleStudent2.scores == null || consoleStudent2.scores!.isEmpty;
  print('Input: Name="John Doe", Scores=[]');
  print('Average: ${consoleAvg2 ?? "null"}');
  print('Letter Grade: ${consoleGrade2 ?? "null"}');
  print('Expected: Average = null, Grade = null, Shows "No scores to process"');
  var passed2 = consoleAvg2 == null && consoleGrade2 == null && hasNoScores;
  print('Result: ${passed2 ? "PASSED" : "FAILED"}');
  print('');

  // Test Scenario 3: Invalid scores (-5 or 150)
  print('=' * 70);
  print('CONSOLE TEST 3: Invalid scores (-5 and 150 should be skipped)');
  print('=' * 70);
  var consoleStudent3 = Student(name: 'John Doe', scores: [85, -5, 150, 78]);
  var consoleAvg3 = consoleStudent3.calculateAverage();
  var consoleGrade3 = consoleStudent3.getLetterGrade();
  print('Input: Name="John Doe", Scores=[85, -5, 150, 78]');
  print('Invalid scores found: ${consoleStudent3.invalidScores.join(", ")}');
  print('Average (should exclude -5 and 150): ${consoleAvg3?.toStringAsFixed(2)}');
  print('Letter Grade: $consoleGrade3');
  print('Expected: Average = 81.50, Grade = B');
  var passed3 = (consoleAvg3! - 81.50).abs() < 0.01 && consoleGrade3 == 'B';
  print('Result: ${passed3 ? "PASSED" : "FAILED"}');
  print('');

  // Test Scenario 4: Empty student name (should default to 'Unknown Student')
  print('=' * 70);
  print('CONSOLE TEST 4: Empty student name should default to "Unknown Student"');
  print('=' * 70);
  var consoleStudent4 = Student(name: '', scores: [85, 90, 78]);
  print('Input: Name="", Scores=[85, 90, 78]');
  print('Display Name: "${consoleStudent4.displayName}"');
  print('Expected: "Unknown Student"');
  var passed4 = consoleStudent4.displayName == 'Unknown Student';
  print('Result: ${passed4 ? "PASSED" : "FAILED"}');
  print('');

  // Test Scenario 4b: Null student name
  print('=' * 70);
  print('CONSOLE TEST 4b: Null student name should default to "Unknown Student"');
  print('=' * 70);
  var consoleStudent4b = Student(name: null, scores: [85, 90, 78]);
  print('Input: Name=null, Scores=[85, 90, 78]');
  print('Display Name: "${consoleStudent4b.displayName}"');
  print('Expected: "Unknown Student"');
  var passed4b = consoleStudent4b.displayName == 'Unknown Student';
  print('Result: ${passed4b ? "PASSED" : "FAILED"}');
  print('');

  print('=' * 70);
  print('ALL TESTS COMPLETED');
  print('=' * 70);
}
