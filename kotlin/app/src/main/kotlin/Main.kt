import model.Student
import service.calculateGrade
import service.readStudentsFromExcel

fun main(args: Array<String>) {
    println("==================================================")
    println("     STUDENT GRADE CALCULATOR PROGRAM")
    println("==================================================")
    println()
    println("This program reads student grades from an Excel file")
    println("and calculates the letter grade for each student.")
    println()
    println("==================================================")
    
    val path = args.firstOrNull() ?: readLine()?.takeIf { it.isNotEmpty() } ?: ""
    
    if (path.isEmpty()) {
        println("No path entered. Exiting.")
        return
    }
    
    val students = readStudentsFromExcel(path)
    if (students.isEmpty()) {
        println("No students found.")
        return
    }
    
    println("\nProcessing grades...\n")
    
    students
        .filter { (it.grade ?: -1) in 0..100 }
        .forEach { student ->
            println("${student.name}: ${calculateGrade(student.grade!!)}")
        }
    
    students
        .filter { (it.grade ?: -1) !in 0..100 }
        .forEach { student ->
            println("${student.name} has an invalid grade.")
        }
}
