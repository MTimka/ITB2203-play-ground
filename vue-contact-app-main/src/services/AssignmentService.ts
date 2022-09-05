import type { IJWTResponse } from "@/domain/IJWTResponse";
import httpClient from "@/http-client";
import { useIdentityStore } from "@/stores/identity";
import type { AxiosError } from "axios";
import type {ISimpleAssignmentResult} from "@/domain/ISimpleAssignmentResult";


export default class AssignmentService {


  async getAllSimple()
  : Promise<ISimpleAssignmentResult[]> {
    try {
      let response = await httpClient.get("/Assignment/GetAllSimple",{});
      return response.data as ISimpleAssignmentResult[]
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

  async addAssignment(categoryId: number,
                      courseId: number,
                      assignmentName: string,
                      assignmentComment: string,
                      assignmentMaxPoints: number,
                      assignmentWeight: number)
  : Promise<boolean> {
    try {
      let response = await httpClient.post("/Assignment",{
        category_id: categoryId,
        course_id: courseId,
        assignment_name: assignmentName,
        assignment_comment: assignmentComment,
        assignment_max_points: assignmentMaxPoints,
        assignment_weight: assignmentWeight,
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

  async getInfo(assignmentId: number)
  : Promise<ISimpleAssignmentResult | null> {
    try {
      let response = await httpClient.get("/Assignment/Info/"+assignmentId,{});
      return response.data as ISimpleAssignmentResult
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

  async updateAssignment(assignmentId: number,
                         categoryId: number,
                         courseId: number,
                         assignmentName: string,
                         assignmentComment: string,
                         assignmentMaxPoints: number,
                         assignmentWeight: number)
  : Promise<boolean> {
    try {
      let response = await httpClient.patch("/Assignment/"+assignmentId,{
        category_id: categoryId,
        course_id: courseId,
        assignment_name: assignmentName,
        assignment_comment: assignmentComment,
        assignment_max_points: assignmentMaxPoints,
        assignment_weight: assignmentWeight,
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

  async getSimpleByCourse(courseId: number)
  : Promise<ISimpleAssignmentResult[]> {
    try {
      let response = await httpClient.get("/Assignment/GetSimpleByCourse/"+courseId,{});
      return response.data as ISimpleAssignmentResult[]
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
}
