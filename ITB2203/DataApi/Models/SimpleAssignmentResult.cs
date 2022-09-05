using Npgsql;

namespace DataApi.Models;

public class SimpleAssignmentResult
{
    public Int64 assignment_id { get; set; }
    public string assignment_name { get; set; }
    public string? assignment_comment { get; set; }
    public Int64 assignment_max_points { get; set; }
    public double assignment_weight { get; set; }
    public Int64[] category_id_list { get; set; }
    public string[] category_name_list { get; set; }
    public Int64 course_id { get; set; }
    public string course_name { get; set; }
    public string course_code { get; set; }
    public Int64 creator_teacher_in_course_id { get; set; }
    public string creator_teacher_name { get; set; }
    public double in_group_max_points_weighted { get; set; }




public 
static 
SimpleAssignmentResult 
Read(NpgsqlDataReader rdr)
{
    return new SimpleAssignmentResult
    {
        assignment_id = rdr.GetInt64(0),
        assignment_name = rdr.GetString(1),
        assignment_comment = rdr.IsDBNull(2) ? null : rdr.GetString(2),
        assignment_max_points = rdr.GetInt64(3),
        assignment_weight = rdr.GetDouble(4),
        category_id_list = rdr.GetFieldValue<Int64[]>(5),
        category_name_list = rdr.GetFieldValue<string[]>(6),
        course_id = rdr.GetInt64(7),
        course_name = rdr.GetString(8),
        course_code = rdr.GetString(9),
        creator_teacher_in_course_id = rdr.GetInt64(10),
        creator_teacher_name = rdr.GetString(11),
        in_group_max_points_weighted = rdr.GetDouble(12)
    };
}




}
