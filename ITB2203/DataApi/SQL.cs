using Npgsql;

namespace DataApi;

public class SQL
{
    private static string m_connectString = "Host=localhost;Username=smush;Password=;Database=test01";
    public static readonly SQL Instance = new SQL();
    

    private readonly NpgsqlConnection connection;

    private SQL()
    {
        connection = new NpgsqlConnection(m_connectString);
        connection.Open();
    }
    
    public NpgsqlDataReader e(string query)
    {
        using var cmd = new NpgsqlCommand(query, connection);
        return cmd.ExecuteReader();
    }
}