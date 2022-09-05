import type { IJWTResponse } from "@/domain/IJWTResponse";
import httpClient from "@/http-client";
import { useIdentityStore } from "@/stores/identity";
import type { AxiosError } from "axios";
import type {ISimpleStudentResult} from "@/domain/ISimpleStudentResult";
import type {IStudentByCourseResult} from "@/domain/IStudentByCourseResult";


export default class StudentService {

  async getAllSimple()
    : Promise<ISimpleStudentResult[]> {
    try {
      let response = await httpClient.get("/student/GetAllSimple",{});
      return response.data as ISimpleStudentResult[]
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

  async getInfo(studentId: number)
  : Promise<ISimpleStudentResult | null> {
    try {
      let response = await httpClient.get("/Student/Info/"+studentId,{});
      return response.data as ISimpleStudentResult
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

  async getByCourse(courseId: number)
  : Promise<IStudentByCourseResult[]> {
    try {
      let response = await httpClient.get("/student/GetByCourse/"+courseId,{});
      return response.data as IStudentByCourseResult[]
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

  async updateStudent(studentId: number, studentName: string, studentCode: string)
  : Promise<boolean> {
    try {
      let response = await httpClient.patch("/Student/"+studentId,{
        student_name: studentName,
        student_code: studentCode
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


  async addStudent(studentName: string, studentCode: string)
  : Promise<boolean> {
    try {
      let response = await httpClient.post("/Student",{
        student_name: studentName,
        student_code: studentCode
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
}
