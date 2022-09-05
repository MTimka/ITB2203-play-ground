using DataApi.Models;
using Microsoft.AspNetCore.Mvc;

namespace DataApi.Controllers;


[ApiController]
[Route("[controller]")]
public class EvaluationController : ExtendedControllerBase
{



[HttpPost]
public 
ActionResult<object> 
AddEvaluation(PostPatchEvaluation model)
{
    Console.WriteLine("EvaluationController AddEvaluation");
    
    const int teacherId = 1;
    return TryRes(() =>
    {
        var q = $"SELECT fun_add_or_update_evaluation({model.assignment_id}, {model.student_in_course_id}, {teacherId}, {model.points})";
        Console.WriteLine(q);
        using var rdr = SQL.Instance.e(q);
    });
}



}
