import type { IJWTResponse } from "@/domain/IJWTResponse";
import httpClient from "@/http-client";
import { useIdentityStore } from "@/stores/identity";
import type { AxiosError } from "axios";


export default class EvaluationService {

  async addEvaluation(assignmentId: number, studentInCourseId: number, points: number)
  : Promise<boolean> {
    try {
      let response = await httpClient.post("/Evaluation",{
        assignment_id: assignmentId,
        student_in_course_id: studentInCourseId,
        points: points
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
