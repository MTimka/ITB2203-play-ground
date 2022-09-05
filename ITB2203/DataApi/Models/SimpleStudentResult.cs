using Npgsql;

namespace DataApi.Models;

public class SimpleStudentResult
{
    public Int64 student_id { get; set; }
    public string student_name { get; set; }
    public string student_code { get; set; }
    public Int64[]? in_courses_id_list { get; set; }
    public string[]? in_courses_name_list { get; set; }

    
    
    
public 
static 
SimpleStudentResult 
Read(NpgsqlDataReader rdr)
{
    if (rdr.IsDBNull(3))
    {
        Console.WriteLine("yeah null and should make new empty array");
    }
    return new SimpleStudentResult
    {
        student_id = rdr.GetInt64(0),
        student_name = rdr.GetString(1),
        student_code = rdr.GetString(2),
        in_courses_id_list = rdr.IsDBNull(3) ? Array.Empty<Int64>() : rdr.GetFieldValue<Int64[]>(3),
        in_courses_name_list = rdr.IsDBNull(4) ? Array.Empty<string>() : rdr.GetFieldValue<string[]>(4)
    };
}
    
}
