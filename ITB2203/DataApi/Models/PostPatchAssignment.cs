namespace DataApi.Models;

public class PostPatchAssignment
{
    public Int64 category_id { get; set; }
    public Int64 course_id { get; set; }
    public string assignment_name { get; set; }
    public string assignment_comment { get; set; }
    public Int64 assignment_max_points { get; set; }
    public float assignment_weight { get; set; }
}
