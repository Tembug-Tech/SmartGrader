import model.Student
import service.calculateGrade
import service.readStudentsFromExcel

fun main(args: Array<String>){
    println("==================================================")
    println("     STUDENT GRADE CALCULATOR PROGRAM")
    println("==================================================")
    println()
    println("This program reads student grades from an Excel file")
    println("and calculates the letter grade for each student.")
    println()
    println("==================================================")
    
    val path = if (args.isNotEmpty()) {
        args[0]
    } else {
        print("Enter the path to your Excel file: ")
        readLine() ?: ""
    }
    
    if (path.isEmpty()) {
        println("No path entered. Exiting.")
        return
    }
    
    val students = readStudentsFromExcel(path)
     if (students.isEmpty()){
        println("No students found.")
        return
     }
     println("\nProccessing grades...\n")
      for (student in students){
        val score =student.grade ?: -1
         if (score !in 0..100){
            println("${student.name} has an invalid grade.")
            continue
         }
         val letter = calculateGrade(score)
         println("${student.name}: $letter")
      }
}
