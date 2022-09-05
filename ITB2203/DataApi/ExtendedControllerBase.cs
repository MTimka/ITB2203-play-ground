using Microsoft.AspNetCore.Mvc;

namespace DataApi;

public class ExtendedControllerBase : ControllerBase
{

    protected static object TryRes(Action action)
    {
        try
        {
            action.Invoke();
            return new
            {
                status = "success"
            };
        }
        catch (Exception e)
        {
            return new
            {
                status = "failed",
                message = e.Message
            };
        }
    }
    
}