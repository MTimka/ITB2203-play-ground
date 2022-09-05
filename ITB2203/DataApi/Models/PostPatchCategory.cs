namespace DataApi.Models;

public class PostPatchCategory
{
    public Int64 course_id { get; set; }
    public Int64? parent_category_id { get; set; }
    public string category_name { get; set; }
}
