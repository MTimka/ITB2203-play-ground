
<template>
  <h1>Add Student(s) to course</h1>

  <h4>{{ courseInfo.course_name }}</h4>

<!--  <p>-->
<!--    <RouterLink to="/course/create">Create new</RouterLink>-->
<!--  </p>-->
  <table class="table">
    <thead>
    <tr>
      <th>Student Name</th>
      <th>Student Code</th>
      <th class="w-10"></th>
    </tr>
    </thead>
    <tbody>
    <tr v-for="item of students" :key="item.student_id">
      <td>{{ item.student_name }}</td>
      <td>{{ item.student_code }}</td>
      <td class="w-10">
        <a href="#" @click="addClicked(item.student_id)">Add</a>
      </td>
    </tr>
    </tbody>
  </table>

  <div>
    <a href="#" @click="$router.go(-1)">Back to Course Details</a>
  </div>
</template>

<script lang="ts">
import CourseService from "@/services/CourseService";
import StudentService from "@/services/StudentService";
import { Options, Vue } from "vue-class-component";
import type { ISimpleCourseResult } from "@/domain/ISimpleCourseResult";
import type { ISimpleStudentResult } from "@/domain/ISimpleStudentResult";


@Options({
  components: {
  },
  props: {
    id: String
  },
  emits: [],
})
export default class CourseAddStudent extends Vue {
  id!: string

  courseService = new CourseService()
  studentService = new StudentService()

  students: ISimpleStudentResult[] = []
  courseInfo: ISimpleCourseResult = {}


  async mounted()
  : Promise<void> {
    console.log("mounted", "CourseAddStudent");
    await this.updateInfo()
  }

  async updateInfo()
  : Promise<void> {
    this.courseInfo = await this.courseService.getInfo(Number(this.id))
    let studentsInCourse = await this.studentService.getByCourse(Number(this.id))
    let students = await this.studentService.getAllSimple()

    console.log("studentsInCourse", studentsInCourse)
    // this.students = students

    this.students = students.filter((it) => {
      for (let sic of studentsInCourse) {
        if (sic.student_id === it.student_id) {
          return false;
        }
      }
      return true;
    })

    console.log("this.students", this.students)

  }


  async addClicked(studentId: number)
  : Promise<void> {
    console.log('addClicked', studentId)
    await this.courseService.addStudentToCourse(this.courseInfo.course_id, studentId)
    await this.updateInfo()
    // this.courses = await this.courseService.getAllSimple()
  }

}

</script>

