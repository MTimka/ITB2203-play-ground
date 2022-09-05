using DataApi.Models;
using Microsoft.AspNetCore.Mvc;

namespace DataApi.Controllers;

[ApiController]
[Route("[controller]")]
public class StudentController : ExtendedControllerBase
{




[HttpGet("GetAllSimple")]
public 
ActionResult<object> 
GetAllStudentsSimple()
{
    Console.WriteLine("StudentController GetAllStudentsSimple");
    
    var courses = new List<SimpleStudentResult>();
    using var rdr = SQL.Instance.e("SELECT * from fun_get_all_students_simple()");
    while (rdr.Read())
    { courses.Add(SimpleStudentResult.Read(rdr)); }

    return courses;
}

[HttpGet("Info/{studentId:int}")]
public 
ActionResult<object> 
GetStudentInfo([FromRoute] int studentId)
{
    Console.WriteLine("GetStudentInfo " + studentId);
    
    using var rdr = SQL.Instance.e($"SELECT * from fun_get_student_info({studentId})");
    rdr.Read(); // read 1st row
    return  SimpleStudentResult.Read(rdr);
}



[HttpGet("GetByCourse/{courseId:int}")]
public 
ActionResult<object> 
GetByCourse([FromRoute] int courseId)
{
    var courses = new List<StudentByCourseResult>();
    using var rdr = SQL.Instance.e($"SELECT * from fun_get_students_by_course({courseId})");
    while (rdr.Read())
    { courses.Add(StudentByCourseResult.Read(rdr)); }

    return courses;
}


[HttpPatch("{studentId:int}")]
public 
ActionResult<object> 
UpdateStudent([FromRoute] int studentId, PostPatchStudent model)
{
    Console.WriteLine("UpdateStudent " + studentId);
    return TryRes(() =>
    {
        using var rdr = SQL.Instance.e($"SELECT fun_update_student({studentId}, '{model.student_name}', '{model.student_code}')");
    });
}


[HttpPost]
public 
ActionResult<object> 
AddStudent(PostPatchStudent model)
{
    Console.WriteLine("StudentController AddStudent");
    return TryRes(() =>
    {
        var q = $"SELECT fun_add_student('{model.student_name}', '{model.student_code}')";
        Console.WriteLine(q);
        using var rdr = SQL.Instance.e(q);
    });
}







}
