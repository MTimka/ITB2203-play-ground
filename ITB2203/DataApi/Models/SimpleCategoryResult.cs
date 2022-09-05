using Npgsql;

namespace DataApi.Models;

public class SimpleCategoryResult
{
    
    public Int64 category_id { get; set; }
    public string category_name { get; set; }
    public Int64? category_parent_id { get; set; }
    public string? category_parent_name { get; set; }
    public Int64 course_id { get; set; }
    public string course_name { get; set; }
    public string course_code { get; set; }

public 
static 
SimpleCategoryResult 
Read(NpgsqlDataReader rdr)
{
    return new SimpleCategoryResult
    {
        category_id = rdr.GetInt64(0),
        category_name = rdr.GetString(1),
        category_parent_id = rdr.IsDBNull(2) ? null : rdr.GetInt64(2),
        category_parent_name = rdr.IsDBNull(3) ? null : rdr.GetString(3),
        course_id = rdr.GetInt64(4),
        course_name = rdr.GetString(5),
        course_code = rdr.GetString(6)
    };
}


}
