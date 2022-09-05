using System.Globalization;
using DataApi.Models;
using Microsoft.AspNetCore.Mvc;

namespace DataApi.Controllers;


[ApiController]
[Route("[controller]")]
public class AssignmentController : ExtendedControllerBase
{
    
    
    
[HttpGet("GetAllSimple")]
public 
ActionResult<object> 
GetAllSimple()
{
    Console.WriteLine("AssignmentController GetAllSimple");
    var assignments = new List<SimpleAssignmentResult>();

    using var rdr = SQL.Instance.e($"SELECT * from fun_get_all_assignments_simple()");
    while (rdr.Read())
    { assignments.Add(SimpleAssignmentResult.Read(rdr)); }

    return assignments;
}

[HttpPost]
public
ActionResult<object>
AddAssignment(PostPatchAssignment model)
{
    Console.WriteLine("AssignmentController AddAssignment");

    const int teacherId = 1;
    return TryRes(() =>
    {
        using var rdr = SQL.Instance.e($"SELECT fun_add_assignment({model.category_id}, {teacherId}, {model.course_id}, '{model.assignment_name}', '{model.assignment_comment}', {model.assignment_max_points}, {model.assignment_weight})");
    });
}




[HttpGet("Info/{assignmentId:int}")]
public 
ActionResult<object> 
GetAssignmentInfo([FromRoute] int assignmentId)
{
    Console.WriteLine("AssignmentController GetAssignmentInfo");

    using var rdr = SQL.Instance.e($"SELECT * from fun_get_assignment_info({assignmentId})");
    rdr.Read(); // read 1st row
    return SimpleAssignmentResult.Read(rdr);
}


[HttpPatch("{assignmentId:int}")]
public
ActionResult<object>
UpdateAssignment([FromRoute] int assignmentId, PostPatchAssignment model)
{
    Console.WriteLine("AssignmentController UpdateAssignment");
    return TryRes(() =>
    {
        var q =
            $"SELECT fun_update_assignment({assignmentId}, {model.category_id}, {model.course_id}, '{model.assignment_name}', '{model.assignment_comment}', {model.assignment_max_points}, {model.assignment_weight.ToString(CultureInfo.InvariantCulture)})";
        using var rdr = SQL.Instance.e(q);
    });
}




[HttpGet("GetSimpleByCourse/{courseId:int}")]
public
ActionResult<object>
GetSimpleByCourse([FromRoute] int courseId)
{
    Console.WriteLine("AssignmentController GetSimpleByCourse");
    var assignments = new List<SimpleAssignmentResult>();

    using var rdr = SQL.Instance.e($"SELECT * FROM fun_get_assignments_simple_by_course({courseId})");
    while (rdr.Read())
    { assignments.Add(SimpleAssignmentResult.Read(rdr)); }

    return assignments;
}



}
