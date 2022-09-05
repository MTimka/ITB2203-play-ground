import httpClient from "@/http-client";
import type {ISimpleCourseResult} from "@/domain/ISimpleCourseResult";
import type {AxiosError} from "axios";

export default class CourseService {

  async getAllSimple()
  : Promise<ISimpleCourseResult[]> {
    try {
      let response = await httpClient.get("/Course/GetAllSimple",{});
      return response.data as ISimpleCourseResult[]
    } catch (e) {
      let response = {
        status: (e as AxiosError).response!.status,
        errorMsg: (e as AxiosError).response!.data.error,
      }

      console.log(response);
      console.log((e as AxiosError).response);

      return [];
    }
  }

  async deleteCourse(courseId: number)
  : Promise<boolean> {
    try {
      let response = await httpClient.delete("/Course/"+courseId,{});
      return true
    } catch (e) {
      let response = {
        status: (e as AxiosError).response!.status,
        errorMsg: (e as AxiosError).response!.data.error,
      }

      console.log(response);
      console.log((e as AxiosError).response);

      return false;
    }
  }

  async addCourse(courseName: string, courseCode: string)
  : Promise<boolean> {
    try {
      let response = await httpClient.post("/Course",{
        course_name: courseName,
        course_code: courseCode
      });
      return true
    } catch (e) {
      let response = {
        status: (e as AxiosError).response!.status,
        errorMsg: (e as AxiosError).response!.data.error,
      }

      console.log(response);
      console.log((e as AxiosError).response);

      return false;
    }
  }

  async getInfo(courseId: number)
  : Promise<ISimpleCourseResult | null> {
    try {
      let response = await httpClient.get("/Course/Info/"+courseId,{});
      return response.data as ISimpleCourseResult
    } catch (e) {
      let response = {
        status: (e as AxiosError).response!.status,
        errorMsg: (e as AxiosError).response!.data.error,
      }

      console.log(response);
      console.log((e as AxiosError).response);

      return null;
    }
  }

  async updateCourse(courseId: number, courseName: string, courseCode: string)
  : Promise<boolean> {
    try {
      let response = await httpClient.patch("/Course/"+courseId,{
        course_name: courseName,
        course_code: courseCode
      });
      return true
    } catch (e) {
      let response = {
        status: (e as AxiosError).response!.status,
        errorMsg: (e as AxiosError).response!.data.error,
      }

      console.log(response);
      console.log((e as AxiosError).response);

      return false;
    }
  }

  async addStudentToCourse(courseId: number, studentId: number)
  : Promise<boolean> {
    try {
      let response = await httpClient.post("/Course/addStudent/"+courseId,{
        student_id: studentId
      });
      return true
    } catch (e) {
      let response = {
        status: (e as AxiosError).response!.status,
        errorMsg: (e as AxiosError).response!.data.error,
      }

      console.log(response);
      console.log((e as AxiosError).response);

      return false;
    }
  }

  async removeStudentFromCourse(courseId: number, studentId: number)
    : Promise<boolean> {
    try {
      let response = await httpClient.delete("/Course/removeStudent/"+courseId+"/"+studentId,{});
      return true
    } catch (e) {
      let response = {
        status: (e as AxiosError).response!.status,
        errorMsg: (e as AxiosError).response!.data.error,
      }

      console.log(response);
      console.log((e as AxiosError).response);

      return false;
    }
  }
}
