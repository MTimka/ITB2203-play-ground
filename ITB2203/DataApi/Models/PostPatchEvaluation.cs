namespace DataApi.Models;

public class PostPatchEvaluation
{
    public Int64 assignment_id { get; set; }
    public Int64 student_in_course_id { get; set; }
    public Int64 points { get; set; }
}
