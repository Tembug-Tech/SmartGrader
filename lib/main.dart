import 'dart:io';
import 'student.dart';
import 'excel_service.dart';

/// Main entry point for the Student Grade Calculator program.
/// 
/// Supports two modes:
/// 1. Interactive mode: Prompts user for Excel file path
/// 2. Command line mode: Accepts file path as argument
/// 
/// Usage:
///   dart run lib\main.dart
///   or
///   dart run lib\main.dart test_data/input_normal.xlsx
void main(List<String> args) {
  print('=' * 70);
  print('STUDENT GRADE CALCULATOR');
  print('=' * 70);
  print('');

  String? inputPath;

  // Check if file path was provided as command line argument
  if (args.isNotEmpty) {
    inputPath = args[0].trim();
    print('Using command line argument: $inputPath');
  } else {
    // Ask user for Excel file path
    print('Please enter the path to your Excel file (.xlsx):');
    print('Example: test_data/input_normal.xlsx');
    print('');
    stdout.write('File path: ');
    
    try {
      inputPath = stdin.readLineSync()?.trim();
    } catch (e) {
      // If stdin doesn't work (non-interactive terminal), show usage
      print('');
      print('Note: Running in non-interactive mode.');
      print('Please provide the Excel file path as a command line argument:');
      print('  dart run lib\\main.dart <path_to_excel_file>');
      print('');
      print('Example:');
      print('  dart run lib\\main.dart test_data/input_normal.xlsx');
      return;
    }
  }

  // Check if user entered a path
  if (inputPath == null || inputPath.isEmpty) {
    print('');
    print('Error: No file path entered. Please provide a valid Excel file path.');
    _keepTerminalOpen();
    return;
  }

  print('');

  // Check if file exists
  final file = File(inputPath);
  if (!file.existsSync()) {
    print('Error: File not found - "$inputPath"');
    print('Please check the file path and try again.');
    _keepTerminalOpen();
    return;
  }

  // Read student data from Excel file
  print('Reading Excel file: $inputPath');
  print('');

  final students = ExcelService.readStudentData(inputPath);

  // Handle empty file case
  if (students.isEmpty) {
    print('Error: There is no data to process.');
    print('The Excel file may be empty or contain only headers.');
    _keepTerminalOpen();
    return;
  }

  // Process and display results
  print('=' * 70);
  print('RESULTS');
  print('=' * 70);
  print('');
  print('Processing ${students.length} student(s)...');
  print('');

  for (final student in students) {
    _printStudentResult(student);
  }

  // Generate output file path
  final outputPath = _generateOutputPath(inputPath);

  // Write results to output Excel file
  print('=' * 70);
  print('Saving results to: $outputPath');
  print('=' * 70);
  print('');

  ExcelService.writeResults(outputPath, students);

  print('Results saved successfully!');
  print('');

  _keepTerminalOpen();
}

/// Generates output file path by adding "_output" before the extension.
String _generateOutputPath(String inputPath) {
  final lastDot = inputPath.lastIndexOf('.');
  if (lastDot == -1) {
    return '${inputPath}_output.xlsx';
  }
  final basePath = inputPath.substring(0, lastDot);
  final extension = inputPath.substring(lastDot);
  return '${basePath}_output$extension';
}

/// Prints a detailed result for a student.
void _printStudentResult(Student student) {
  print('-----------------------------------');
  print('Student Name: ${student.displayName}');

  if (student.scores == null || student.scores!.isEmpty) {
    print('Status: No scores to process');
    print('Average: N/A');
    print('Letter Grade: N/A');
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
      print('Note: Invalid scores found and skipped: ${student.invalidScores.join(', ')}');
    }
  }

  print('');
}

/// Keeps the terminal open until user presses Enter.
void _keepTerminalOpen() {
  print('');
  print('=' * 70);
  print('Press Enter to exit...');
  print('=' * 70);
  try {
    stdin.readLineSync();
  } catch (e) {
    // Ignore errors in non-interactive mode
  }
}
