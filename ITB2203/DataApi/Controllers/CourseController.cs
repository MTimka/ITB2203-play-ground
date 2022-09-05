using DataApi.Models;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Npgsql;

namespace DataApi.Controllers;

// lol c style rocks

[ApiController]
[Route("[controller]")]
public class CourseController : ExtendedControllerBase
{






[HttpGet("GetAllSimple")]
public 
ActionResult<object> 
GetAllCoursesSimple()
{
    // Console.WriteLine("GetAllSimple");
    var courses = new List<SimpleCourseResult>();
    using var rdr = SQL.Instance.e("SELECT * from fun_get_all_courses_simple()");
    while (rdr.Read())
    { courses.Add(SimpleCourseResult.Read(rdr)); }

    return courses;
}

// [HttpGet("GetStudentsInCourse/{courseId:int}")]
// public 
// ActionResult<object> 
// GetAllCoursesSimple([FromRoute] int courseId)
// {
//     var courses = new List<StudentInCourseResult>();
//     using var rdr = SQL.Instance.e($"SELECT * from fun_get_all_students_in_course({courseId})");
//     while (rdr.Read())
//     {
//         courses.Add(new StudentInCourseResult
//         {
//             student_id = rdr.GetInt64(0),
//             student_code = rdr.GetString(1),
//             student_name = rdr.GetString(2)
//         });
//     }
//
//     return courses;
// }

[HttpPost]
public 
ActionResult<object> 
AddNewCourse(PostPatchCourse model)
{
    Console.WriteLine("AddNewCourse " + model.course_name);
    const int teacher_id = 1;
    return TryRes(() =>
    {
        using var rdr = SQL.Instance.e($"SELECT fun_add_course({teacher_id}, '{model.course_name}', '{model.course_code}')");
    });
}

[HttpDelete("{courseId:int}")]
public 
ActionResult<object> 
DeleteCourse([FromRoute] int courseId)
{
    Console.WriteLine("DeleteCourse " + courseId);
    return TryRes(() =>
    {
        using var rdr = SQL.Instance.e($"SELECT fun_delete_course({courseId})");
    });
}

[HttpGet("Info/{courseId:int}")]
public 
ActionResult<object> 
GetCourseInfo([FromRoute] int courseId)
{
    Console.WriteLine("GetCourseInfo " + courseId);
    
    using var rdr = SQL.Instance.e($"SELECT * from fun_get_course_info({courseId})");
    rdr.Read();
    return  SimpleCourseResult.Read(rdr);
}

[HttpPatch("{courseId:int}")]
public 
ActionResult<object> 
UpdateCourse([FromRoute] int courseId, PostPatchCourse model)
{
    Console.WriteLine("UpdateCourse " + courseId);
    return TryRes(() =>
    {
        using var rdr = SQL.Instance.e($"SELECT fun_update_course({courseId}, '{model.course_name}', '{model.course_code}')");
    });
}


[HttpPost("addStudent/{courseId:int}")]
public 
ActionResult<object> 
AddStudentToCourse([FromRoute] int courseId, PostPatchStudentToCourse model)
{
    Console.WriteLine("AddStudentToCourse " + courseId);
    return TryRes(() =>
    {
        var q = $"SELECT fun_add_student_to_course({model.student_id}, {courseId})";
        Console.WriteLine(q);
        using var rdr = SQL.Instance.e(q);
    });
}


[HttpDelete("removeStudent/{courseId:int}/{studentId:int}")]
public 
ActionResult<object> 
RemoveStudentFromCourse([FromRoute] int courseId, [FromRoute] int studentId)
{
    Console.WriteLine("RemoveStudentFromCourse " + courseId);
    return TryRes(() =>
    {
        var q = $"SELECT fun_remove_student_from_course({studentId}, {courseId})";
        Console.WriteLine(q);
        using var rdr = SQL.Instance.e(q);
    });
}



}
