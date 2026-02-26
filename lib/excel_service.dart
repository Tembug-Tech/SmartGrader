import 'dart:io';
import 'package:excel/excel.dart';
import 'student.dart';

/// Service class for handling Excel file operations.
/// 
/// Handles reading student data from input Excel files and
/// writing grade results to output Excel files.
class ExcelService {
  
  /// Reads student data from an Excel file.
  /// 
  /// Expected Excel format:
  /// - First row: Headers (Name, Score1, Score2, ..., ScoreN)
  /// - Subsequent rows: Student data
  /// 
  /// Returns a list of Student objects.
  /// Returns an empty list if the file is empty or has no data.
  static List<Student> readStudentData(String filePath) {
    final students = <Student>[];
    
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        print('Error: File not found at $filePath');
        return students;
      }
      
      final bytes = file.readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      
      // Get the first sheet - prefer 'Students' sheet if it exists
      if (excel.tables.isEmpty) {
        print('Error: No sheets found in the Excel file');
        return students;
      }
      
      // Try to get 'Students' sheet first, otherwise use first available
      String? sheetName;
      if (excel.tables.containsKey('Students')) {
        sheetName = 'Students';
      } else {
        sheetName = excel.tables.keys.first;
      }
      
      final sheet = excel.tables[sheetName];
      
      if (sheet == null) {
        print('Error: Sheet is null');
        return students;
      }
      
      final rows = sheet.rows;
      
      if (rows.length <= 1) {
        print('Error: Excel file is empty or has no data');
        return students;
      }
      
      // Process data rows (starting from index 1, assuming row 0 is header)
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        
        // Skip if row is empty
        if (row.isEmpty) {
          continue;
        }
        
        // Get first cell
        final firstCell = row[0];
        if (firstCell == null || firstCell.value == null) {
          continue;
        }
        
        // Get student name from first column
        String? name = _extractCellValue(firstCell.value);
        if (name != null && name.trim().isEmpty) {
          name = null;
        }
        
        // Get scores from remaining columns
        final scores = <double>[];
        for (int j = 1; j < row.length; j++) {
          final cell = row[j];
          if (cell != null && cell.value != null) {
            final scoreStr = _extractCellValue(cell.value);
            if (scoreStr != null) {
              final score = double.tryParse(scoreStr);
              if (score != null) {
                scores.add(score);
              }
            }
          }
        }
        
        students.add(Student(name: name, scores: scores));
      }
      
      if (students.isEmpty) {
        print('Warning: No student data found in the Excel file');
      }
      
    } catch (e) {
      print('Error reading Excel file: $e');
    }
    
    return students;
  }
  
  /// Extracts string value from various Excel cell value types.
  static String? _extractCellValue(dynamic value) {
    if (value == null) return null;
    
    if (value is TextCellValue) {
      // TextCellValue has a value property that returns TextSpan
      // We need to extract the text from it
      return value.value.toString();
    } else if (value is IntCellValue) {
      return value.value.toString();
    } else if (value is DoubleCellValue) {
      return value.value.toString();
    } else if (value is String) {
      return value;
    }
    
    return value.toString();
  }
  
  /// Writes student grade results to an Excel file.
  /// 
  /// Output format:
  /// - Headers: Name, Average, Grade, Invalid Scores, Notes
  /// - Data rows: Student results
  static bool writeResults(String filePath, List<Student> students) {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['Grades'];
      
      // Write headers
      sheet.appendRow([
        TextCellValue('Name'),
        TextCellValue('Average'),
        TextCellValue('Grade'),
        TextCellValue('Invalid Scores'),
        TextCellValue('Notes')
      ]);
      
      // Write student results
      for (final student in students) {
        final average = student.calculateAverage();
        final grade = student.getLetterGrade();
        
        // Format invalid scores
        String invalidScoresStr = '';
        if (student.invalidScores.isNotEmpty) {
          invalidScoresStr = student.invalidScores.map((s) => s.toString()).join(', ');
        }
        
        // Generate notes
        String notes = '';
        if (student.scores == null || student.scores!.isEmpty) {
          notes = 'No scores to process';
        } else if (student.invalidScores.isNotEmpty) {
          notes = '${student.invalidScores.length} invalid score(s) skipped';
        }
        
        sheet.appendRow([
          TextCellValue(student.displayName),
          average != null ? TextCellValue(average.toStringAsFixed(2)) : TextCellValue('N/A'),
          grade != null ? TextCellValue(grade) : TextCellValue('N/A'),
          TextCellValue(invalidScoresStr),
          TextCellValue(notes)
        ]);
      }
      
      // Save the file
      final file = File(filePath);
      final bytes = excel.encode();
      if (bytes != null) {
        file.writeAsBytesSync(bytes);
        print('Results successfully written to $filePath');
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error writing Excel file: $e');
      return false;
    }
  }
  
  /// Creates a sample Excel file with test data for demonstration.
  static void createSampleInputFile(String filePath, SampleType type) {
    final excel = Excel.createExcel();
    
    // Get or create a sheet named 'Students'
    var sheet = excel['Students'];
    
    switch (type) {
      case SampleType.normal:
        // Normal case with valid data
        sheet.appendRow([
          TextCellValue('Name'),
          TextCellValue('Score1'),
          TextCellValue('Score2'),
          TextCellValue('Score3'),
          TextCellValue('Score4'),
          TextCellValue('Score5')
        ]);
        sheet.appendRow([
          TextCellValue('Alice Johnson'),
          TextCellValue('85'),
          TextCellValue('90'),
          TextCellValue('78'),
          TextCellValue('92'),
          TextCellValue('88')
        ]);
        sheet.appendRow([
          TextCellValue('Bob Smith'),
          TextCellValue('72'),
          TextCellValue('75'),
          TextCellValue('68'),
          TextCellValue('80'),
          TextCellValue('70')
        ]);
        sheet.appendRow([
          TextCellValue('Charlie Brown'),
          TextCellValue('95'),
          TextCellValue('88'),
          TextCellValue('92'),
          TextCellValue('90'),
          TextCellValue('85')
        ]);
        break;
        
      case SampleType.empty:
        // Empty file with only headers
        sheet.appendRow([
          TextCellValue('Name'),
          TextCellValue('Score1'),
          TextCellValue('Score2')
        ]);
        break;
        
      case SampleType.invalidScores:
        // Case with invalid scores
        sheet.appendRow([
          TextCellValue('Name'),
          TextCellValue('Score1'),
          TextCellValue('Score2'),
          TextCellValue('Score3'),
          TextCellValue('Score4')
        ]);
        sheet.appendRow([
          TextCellValue('David Lee'),
          TextCellValue('85'),
          TextCellValue('105'),  // Invalid: above 100
          TextCellValue('78'),
          TextCellValue('-5')    // Invalid: below 0
        ]);
        sheet.appendRow([
          TextCellValue('Emma Wilson'),
          TextCellValue('90'),
          TextCellValue('110'), // Invalid: above 100
          TextCellValue('95'),
          TextCellValue('-10')  // Invalid: below 0
        ]);
        break;
        
      case SampleType.nullName:
        // Case with null/missing names
        sheet.appendRow([
          TextCellValue('Name'),
          TextCellValue('Score1'),
          TextCellValue('Score2'),
          TextCellValue('Score3')
        ]);
        sheet.appendRow([
          TextCellValue(''),  // Empty name
          TextCellValue('80'),
          TextCellValue('85'),
          TextCellValue('90')
        ]);
        sheet.appendRow([
          TextCellValue('Frank Miller'),
          TextCellValue('70'),
          TextCellValue('75'),
          TextCellValue('72')
        ]);
        // Row with whitespace only name
        sheet.appendRow([
          TextCellValue('   '),  // Whitespace only
          TextCellValue('88'),
          TextCellValue('92'),
          TextCellValue('85')
        ]);
        break;
    }
    
    // Save the file
    final file = File(filePath);
    final bytes = excel.encode();
    if (bytes != null) {
      file.writeAsBytesSync(bytes);
    }
  }
}

/// Enum for sample file types
enum SampleType {
  normal,
  empty,
  invalidScores,
  nullName
}
