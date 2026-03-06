package service

import model.Student

interface StudentReader {
    fun readStudentsFromExcel(path: String): List<Student>
}
