export interface ISimpleCategoryResult {
  category_id: number,
  category_name: string,
  category_parent_id: number | null,
  category_parent_name: string | null,
  course_id: number;
  course_name: string;
  course_code: string;
}
