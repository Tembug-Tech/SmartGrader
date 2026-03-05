package service 
import model.Student
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import java.io.File
import java.io.FileInputStream

fun readStudentsFromExcel(path: String): List<Student> {
    val file = File(path)
    if (!file.exists()) {
        println("File does not exist.")
        return emptyList()
    }
    
    XSSFWorkbook(FileInputStream(file)).use { workbook ->
        val sheet = workbook.getSheetAt(0)
        val rowIterator = sheet.iterator()
        rowIterator.next()
        
        return rowIterator.asSequence()
            .map { row -> Student(
                row.getCell(0)?.stringCellValue ?: "Unknown",
                row.getCell(1)?.numericCellValue?.toInt()
            )}
            .toList()
    }
}