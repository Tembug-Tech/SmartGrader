package service

class GradeCalculatorImpl : GradeCalculator {
    override fun calculateGrade(score: Int): String {
        return when (score) {
            in 90..100 -> "A"
            in 80..89 -> "B"
            in 70..79 -> "C"
            in 60..69 -> "D"
            in 0..59 -> "F"
            else -> "Invalid grade"
        }
    }
}

// Backward-compatible top-level function
fun calculateGrade(score: Int): String = GradeCalculatorImpl().calculateGrade(score)