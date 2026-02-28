package service 
import model.Student
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.File
import java.io.FileInputStream

fun readStudentsFromExcel(path: String):List<Student>{
    val file = File(path)

    if (!file.exists()) {
        println("File does not exist.")
        return emptyList()
    }
    val workbook = XSSFWorkbook(FileInputStream(file))
    val sheet = workbook.getSheetAt(0)
    val students = mutableListOf<Student>()


    val rowIterator = sheet.iterator()
    if (rowIterator.hasNext()) rowIterator.next()
    while (rowIterator.hasNext()){
        val row = rowIterator.next()

        val name=row.getCell(0)?.stringCellValue ?: "Unknown"
        val grade = row.getCell(1)?.numericCellValue?.toInt()
        students.add(Student(name, grade))  
    }
    workbook.close()
    return students
}