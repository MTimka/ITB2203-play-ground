
<template>
  <h1>Assignments Index</h1>

  <p>
    <RouterLink to="/assignment/create">Create new</RouterLink>
  </p>
  <table class="table">
    <thead>
    <tr>
      <th>Assignment Name</th>
      <th>Max Points</th>
      <th>In Category</th>
      <th>In Course</th>
      <th>Creator Name</th>
      <th class="w-20"></th>
    </tr>
    </thead>
    <tbody>
    <tr v-for="item of assignments" :key="item.assignment_id">
      <td>{{ item.assignment_name }}</td>
      <td>{{ item.assignment_max_points }} 「 {{ item.assignment_weight }} 」</td>
      <td><div v-for="cat of item.category_name_list">{{cat}}</div></td>
      <td>{{ item.course_name }} 「 {{ item.course_code }} 」</td>
      <td>{{ item.creator_teacher_name }}</td>
      <td class="w-20">
        <RouterLink :to="{ name: 'assignment-edit', params: { id: item.assignment_id } }">Edit</RouterLink> |
        <a href="/Persons/Details/d31d15f4-517c-43b1-a1b8-5dac38c99c01">Details</a> |
        <a href="#" @click="deleteClicked(item.assignment_id)">Delete</a>
      </td>
    </tr>
    </tbody>
  </table>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import AssignmentService from "@/services/AssignmentService";

@Options({
    components: {
    },
    props: {},
    emits: [],
})
export default class AssignmentsListIndex extends Vue {

  assignmentService = new AssignmentService()
  assignments = []


  async mounted()
  : Promise<void> {
    console.log("mounted", "AssignmentsListIndex");
    this.assignments = await this.assignmentService.getAllSimple()
    console.log(this.assignments)
  }

  async deleteClicked(assignmentId: number)
  : Promise<void> {
    console.log('deleteClicked', assignmentId)
    // await this.courseService.deleteCourse(course_id)
    // this.assignments = await this.assignmentService.getAllSimple()
  }


}
</script>

