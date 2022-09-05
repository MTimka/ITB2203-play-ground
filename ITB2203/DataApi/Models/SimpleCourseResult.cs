using Npgsql;

namespace DataApi.Models;

public class SimpleCourseResult
{
    public Int64 course_id { get; set; }
    public string course_name { get; set; }
    public string course_code { get; set; }
    public Int64 course_creator_id { get; set; }
    public string course_creator_name { get; set; }
    public Int64 course_max_points { get; set; }
    public double course_max_points_weighted { get; set; }

public
static
SimpleCourseResult 
Read(NpgsqlDataReader rdr)
{
    return new SimpleCourseResult
    {
        course_id = rdr.GetInt64(0),
        course_name = rdr.GetString(1),
        course_code = rdr.GetString(2),
        course_creator_id = rdr.GetInt64(3),
        course_creator_name = rdr.GetString(4),
        course_max_points = rdr.IsDBNull(5) ? 0 : rdr.GetInt64(5),
        course_max_points_weighted = rdr.IsDBNull(6) ? 0 : rdr.GetDouble(6)
    };
}




}
