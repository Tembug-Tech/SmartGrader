/// Represents a student with a name and list of scores.
/// 
/// The [name] field is nullable - if null or empty, defaults to 'Unknown Student'.
/// The [scores] field is nullable - if null or empty, no calculations are performed.
class Student {
  /// The student's name (nullable).
  String? name;
  
  /// The list of student's scores (nullable).
  List<double>? scores;
  
  /// List of invalid scores encountered during processing.
  final List<double> invalidScores = [];
  
  /// Constructor for Student class.
  Student({this.name, this.scores});
  
  /// Returns the student's name, defaulting to 'Unknown Student' if null or empty.
  String get displayName {
    if (name == null || name!.trim().isEmpty) {
      return 'Unknown Student';
    }
    return name!;
  }
  
  /// Checks if the student has valid scores to process.
  bool get hasValidScores {
    if (scores == null || scores!.isEmpty) {
      return false;
    }
    // Filter for valid scores (0-100)
    final validScores = _getValidScores();
    return validScores.isNotEmpty;
  }
  
  /// Returns a list of valid scores (between 0 and 100 inclusive).
  List<double> _getValidScores() {
    if (scores == null || scores!.isEmpty) {
      return [];
    }
    
    invalidScores.clear();
    final validScores = <double>[];
    
    for (final score in scores!) {
      if (score < 0 || score > 100) {
        invalidScores.add(score);
      } else {
        validScores.add(score);
      }
    }
    
    return validScores;
  }
  
  /// Calculates and returns the average of valid scores.
  /// 
  /// Returns null if there are no valid scores to process.
  /// Invalid scores (below 0 or above 100) are skipped.
  double? calculateAverage() {
    if (scores == null || scores!.isEmpty) {
      return null;
    }
    
    final validScores = _getValidScores();
    
    if (validScores.isEmpty) {
      return null;
    }
    
    final sum = validScores.reduce((a, b) => a + b);
    return sum / validScores.length;
  }
  
  /// Assigns and returns a letter grade based on the average score.
  /// 
  /// Grade logic:
  /// - A: 90 and above
  /// - B: 80-89
  /// - C: 70-79
  /// - D: 60-69
  /// - F: below 60
  /// 
  /// Returns null if there are no valid scores to calculate a grade.
  String? getLetterGrade() {
    final average = calculateAverage();
    
    if (average == null) {
      return null;
    }
    
    if (average >= 90) {
      return 'A';
    } else if (average >= 80) {
      return 'B';
    } else if (average >= 70) {
      return 'C';
    } else if (average >= 60) {
      return 'D';
    } else {
      return 'F';
    }
  }
  
  /// Creates a Student from a map of data (e.g., from Excel row).
  /// 
  /// The map should have 'name' key for student name and 'scores' key for scores.
  factory Student.fromMap(Map<String, dynamic> data) {
    String? name;
    List<double>? scores;
    
    if (data.containsKey('name') && data['name'] != null) {
      name = data['name'].toString();
    }
    
    if (data.containsKey('scores') && data['scores'] != null) {
      if (data['scores'] is List) {
        scores = (data['scores'] as List)
            .map((e) => double.tryParse(e.toString()) ?? 0.0)
            .toList();
      }
    }
    
    return Student(name: name, scores: scores);
  }
  
  /// Returns a string representation of the student.
  @override
  String toString() {
    final avg = calculateAverage();
    final grade = getLetterGrade();
    return 'Student: $displayName, Average: ${avg?.toStringAsFixed(2) ?? 'N/A'}, Grade: ${grade ?? 'N/A'}';
  }
}
