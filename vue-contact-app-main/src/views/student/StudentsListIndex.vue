
<template>
  <h1>Students Index</h1>

  <p>
    <RouterLink to="/student/create">Create new</RouterLink>
  </p>
  <table class="table">
    <thead>
    <tr>
      <th>Student Name</th>
      <th>Student Code</th>
      <th>In Course(s)</th>
      <th class="w-20"></th>
    </tr>
    </thead>
    <tbody>
    <tr v-for="item of students" :key="item.student_id">
      <td>{{ item.student_name }}</td>
      <td>{{ item.student_code }}</td>
      <td>{{ item.in_courses_name_list.join(", ") }}</td>
      <td class="w-20">
        <RouterLink :to="{ name: 'student-edit', params: { id: item.student_id } }">Edit</RouterLink> |
        <a href="/Persons/Details/d31d15f4-517c-43b1-a1b8-5dac38c99c01">Details</a> |
        <a href="#" @click="deleteClicked(item.student_id)">Delete</a>
      </td>
    </tr>
    </tbody>
  </table>
</template>

<script lang="ts">
import StudentService from "@/services/StudentService";
// import { usePersonsStore } from "@/stores/persons";
import { Options, Vue } from "vue-class-component";
import type { ISimpleStudentResult } from "@/domain/ISimpleStudentResult";

@Options({
  components: {
  },
  props: {},
  emits: [],
})
export default class StudentsListIndex extends Vue {

  studentService = new StudentService()
  students: ISimpleStudentResult[] = []

  async mounted()
      : Promise<void> {
    console.log("mounted", "StudentsListIndex");
    this.students = await this.studentService.getAllSimple()
    console.log(this.students)
  }

  async deleteClicked(studentId: number)
      : Promise<void> {
    console.log('deleteClicked', studentId)
    // await this.courseService.deleteCourse(course_id)
    // this.courses = await this.courseService.getAllSimple()
  }

}

</script>

