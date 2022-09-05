import httpClient from "@/http-client";
import type { AxiosError } from "axios";
import type { ISimpleCategoryResult } from "@/domain/ISimpleCategoryResult";

export default class CategoryService {
    async getAllSimple()
    : Promise<ISimpleCategoryResult[]> {
        try {
            let response = await httpClient.get("/category/GetAllSimple",{});
            return response.data as ISimpleCategoryResult[]
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

    async getSimpleByCourse(courseId: number)
    : Promise<ISimpleCategoryResult[]> {
        try {
            let response = await httpClient.get("/category/GetSimpleByCourse/"+courseId,{});
            return response.data as ISimpleCategoryResult[]
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

    async getInfo(categoryId: number)
    : Promise<ISimpleCategoryResult | null> {
        try {
            let response = await httpClient.get("/category/Info/"+categoryId,{});
            return response.data as ISimpleCategoryResult
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

    async updateCategory(categoryId: number, courseId: number, parentCategoryId: number | null, categoryName: string)
    : Promise<boolean> {
        try {
            let response = await httpClient.patch("/category/"+categoryId,{
                course_id: courseId,
                parent_category_id: parentCategoryId,
                category_name: categoryName,
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

    async addCategory(courseId: number, parentCategoryId: number | null, categoryName: string)
    : Promise<boolean> {
        try {
            let response = await httpClient.post("/category",{
                course_id: courseId,
                parent_category_id: parentCategoryId,
                category_name: categoryName
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
