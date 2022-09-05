using DataApi.Models;
using Microsoft.AspNetCore.Mvc;

namespace DataApi.Controllers;

[ApiController]
[Route("[controller]")]
public class CategoryController : ExtendedControllerBase
{



[HttpGet("GetAllSimple")]
public 
ActionResult<object> 
GetAllSimple()
{
    Console.WriteLine("CategoryController GetAllSimple");
    var assignments = new List<SimpleCategoryResult>();

    using var rdr = SQL.Instance.e($"SELECT * from fun_get_all_categories_simple()");
    while (rdr.Read())
    { assignments.Add(SimpleCategoryResult.Read(rdr)); }

    return assignments;
}


[HttpGet("GetSimpleByCourse/{courseId:int}")]
public 
ActionResult<object> 
GetSimpleByCourse([FromRoute] int courseId)
{
    Console.WriteLine("CategoryController GetSimpleByCourse");
    var assignments = new List<SimpleCategoryResult>();

    var q = $"SELECT * from fun_get_categories_simple_by_course({courseId})";
    
    using var rdr = SQL.Instance.e(q);
    while (rdr.Read())
    { assignments.Add(SimpleCategoryResult.Read(rdr)); }
    
    return assignments;
}

[HttpGet("Info/{categoryId:int}")]
public 
ActionResult<object> 
GetCategoryInfo([FromRoute] int categoryId)
{
    Console.WriteLine("AssignmentController GetCategoryInfo");

    using var rdr = SQL.Instance.e($"SELECT * from fun_get_category_info({categoryId})");
    rdr.Read(); // read 1st row
    return SimpleCategoryResult.Read(rdr);
}





[HttpPatch("{categoryId:int}")]
public 
ActionResult<object> 
UpdateCategory([FromRoute] int categoryId, PostPatchCategory model)
{
    Console.WriteLine("CategoryController UpdateCategory");
    return TryRes(() =>
    {
        var q = model.parent_category_id == null 
            ? $"SELECT fun_update_category({categoryId}, {model.course_id}, null, '{model.category_name}')" 
            : $"SELECT fun_update_category({categoryId}, {model.course_id}, {model.parent_category_id}, '{model.category_name}')";
        using var rdr = SQL.Instance.e(q);
    });
}


[HttpPost]
public
ActionResult<object>
AddCategory(PostPatchCategory model)
{
    Console.WriteLine("CategoryController AddCategory");
    return TryRes(() =>
    {
        var q = model.parent_category_id == null 
            ? $"SELECT fun_add_category({model.course_id}, null, '{model.category_name}')" 
            : $"SELECT fun_add_category({model.course_id}, {model.parent_category_id}, '{model.category_name}')";
        using var rdr = SQL.Instance.e(q);
    });
}







}
