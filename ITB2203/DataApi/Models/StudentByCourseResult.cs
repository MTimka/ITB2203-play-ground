using Npgsql;

namespace DataApi.Models;

public class StudentByCourseResult
{
    public Int64 student_id { get; set; }
    public string student_name { get; set; }
    public string student_code { get; set; }
    public Int64 student_in_course_id { get; set; }
    public double weighted_evaluation { get; set; }
    public List<object> evaluations_list { get; set; }
    
public 
static 
StudentByCourseResult 
Read(NpgsqlDataReader rdr)
{
    var res = new StudentByCourseResult
    {
        student_id = rdr.GetInt64(0),
        student_name = rdr.GetString(1),
        student_code = rdr.GetString(2),
        student_in_course_id = rdr.GetInt64(3),
        weighted_evaluation = rdr.IsDBNull(4) ? 0 : rdr.GetDouble(4),
        evaluations_list = new List<object>()
    };
    
    if (rdr.IsDBNull(4) == false)
    {
        var evaluation_ids = rdr.GetFieldValue<Int64[]>(5);
        var assignment_ids = rdr.GetFieldValue<Int64[]>(6);
        var evaluation_points = rdr.GetFieldValue<Int64[]>(7);
        var assignment_max_points = rdr.GetFieldValue<Int64[]>(8);
        var assignment_weights = rdr.GetFieldValue<double[]>(9);
        var assignment_names = rdr.GetFieldValue<string[]>(10);
        
        for (var i = 0; i < evaluation_ids.Length; i++)
        {
            res.evaluations_list.Add(new
            {
                evaluation_id = evaluation_ids[i],
                assignment_id = assignment_ids[i],
                evaluation_points = evaluation_points[i],
                assignment_max_points = assignment_max_points[i],
                assignment_weight = assignment_weights[i],
                assignment_name = assignment_names[i],
            });
        }
    }

    return res;
}



}
