export interface ISimpleAssignmentResult {
  assignment_id: number,
  assignment_name: string,
  assignment_comment: string | null,
  assignment_max_points: number,
  assignment_weight: number;
  category_id_list: number[];
  category_name_list: string[];
  course_id: number;
  course_name: string;
  course_code: string;
  creator_teacher_in_course_id: number;
  creator_teacher_name: string;
  in_group_max_points_weighted: number;
}
