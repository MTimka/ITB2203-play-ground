<template>
  <h1>Details</h1>

<!--  https://getbootstrap.com/docs/5.0/content/typography/ -->
  <figure class="text-center">
    <blockquote class="blockquote">
      <p>{{ courseInfo.course_name }}</p>
    </blockquote>
    <figcaption class="blockquote-footer">
      {{ courseInfo.course_code }}
    </figcaption>
  </figure>

  <hr />
  <div class="row">
    <div class="col-md-12">

      <h3>Students</h3>
      <p>
<!--        luckily buggy vue will have this class member 'id' property signed and CourseAddStudent will use it-->
        <RouterLink :to="{ name: 'course-add-student' }">
          Add Student(s) To Course
        </RouterLink>
      </p>
      <table class="table" id="students-table">
        <thead>
          <tr>
            <th>Student Name</th>
            <th>Student Code</th>
            <th>Collected Points</th>
            <th>Max Points</th>
            <th class="w-20"></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="it of studentsTableElements">
            <td v-if="it.type==='STUDENT'">{{ it.value.student_name }}</td>
            <td v-if="it.type==='STUDENT'">{{ it.value.student_code }}</td>
            <td v-if="it.type==='STUDENT'">{{ it.value.weighted_evaluation }}</td>
            <td v-if="it.type==='STUDENT'">{{ courseInfo.course_max_points_weighted }}</td>
            <td v-if="it.type==='STUDENT'" class="w-20">
              <a href="#" @click="expandToggleClicked(it.value.student_id, $event.target)">Expand</a> |
              <a href="#" @click="removeClicked(it.value.student_id)">Remove</a>
            </td>

            <td v-if="it.type==='ASSIGNMENTS'" colspan="5" style="display: none" :data-id="it.value.student_id">
              <RCategories v-bind="{
                assignmentsInCategory: assignmentsInCategory,
                studentByCourseInfo: it.value,
                detailsView: this
              }" />
            </td>
          </tr>
        </tbody>
      </table>

    </div>
  </div>

  <div>
    <RouterLink :to="{ name: 'courses' }">Back to List</RouterLink>
  </div>

  <!-- Modal -->
  <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" @click="closeModal()">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label class="control-label" for="grade-points">Give Points</label>
            <input class="form-control" type="text" id="grade-points" />
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal" @click="closeModal()">Close</button>
          <button type="button" class="btn btn-primary">Save changes</button>
        </div>
      </div>
    </div>
  </div>
</template>


<script lang="ts">
import 'bootstrap/dist/js/bootstrap.min.js';
import * as $ from 'jquery';

import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import type { IStudentByCourseResult } from "@/domain/IStudentByCourseResult";
import type { ISimpleAssignmentResult } from "@/domain/ISimpleAssignmentResult";
import CourseService from "@/services/CourseService";
import StudentService from "@/services/StudentService";
import AssignmentService from "@/services/AssignmentService";
import EvaluationService from "@/services/EvaluationService";
import List from "@/List";
import RCategories from "@/views/course/RCategories.vue";


@Options({
  components: {
    RCategories: RCategories
  },
  props: {
    id: String
  },
  emits: [],
})
export default class CourseDetails extends Vue {
  id!: string

  courseService = new CourseService()
  studentService = new StudentService()
  assignmentService = new AssignmentService()
  evaluationService = new EvaluationService()

  courseInfo: ISimpleCourseResult = {}
  students: IStudentByCourseResult[] = []
  studentsTableElements: [] = []
  assignments: ISimpleAssignmentResult[] = []

  assignmentsInCategory: {} = {}

  comments = [
    {
      value: "hellou"
    }
  ]

  async mounted()
  : Promise<void> {
    console.log("mounted", "CourseEdit");
    await this.updateData()
  }

  async updateData()
  : Promise<void> {
    this.studentsTableElements = []
    this.assignmentsInCategory = {}

    this.courseInfo = await this.courseService.getInfo(Number(this.id))
    this.students = await this.studentService.getByCourse(this.courseInfo.course_id)
    this.assignments = await this.assignmentService.getSimpleByCourse(this.courseInfo.course_id)

    console.log("students", this.students)

    for (let s of this.students) {
      this.studentsTableElements.push({
        type: "STUDENT",
        value: s
      })
      this.studentsTableElements.push({
        type: "ASSIGNMENTS",
        value: s
      })
    }

    // build assignments to categories
    for (let a of this.assignments) {
      let tmp = this.assignmentsInCategory

      for (let i = 0; i < a.category_id_list.length; i++) {
        let categoryId = a.category_id_list[i]
        let categoryName = a.category_name_list[i]

        if (!tmp.hasOwnProperty("categories")) { tmp["categories"] = [] }
        if (!tmp.hasOwnProperty("assignments")) { tmp["assignments"] = [] }

        let found = false;
        for (let cat of tmp["categories"]) {
          if (cat["id"] === categoryId) {
            tmp = cat
            found = true
            break;
          }
        }

        if (!found) {
          let obj = { "id": categoryId, "name": categoryName, "assignments": [], "categories": [] }
          tmp["categories"].push(obj)
          tmp = obj
        }

        // if last
        if (i == a.category_id_list.length - 1) {
          tmp["assignments"].push(a)
          tmp["in_group_max_points_weighted"] = a.in_group_max_points_weighted
        }

      }
    }
  }

  async expandToggleClicked(studentId: number, elem: HTMLElement)
  : Promise<void> {
    console.log('expandToggleClicked', studentId)

    let td = document.querySelector("td[data-id='"+studentId+"']")
    if (td.style.display == "none") {
      td.style.display = "table-cell";
      elem.innerHTML = "Collapse"
    }
    else {
      td.style.display = "none";
      elem.innerHTML = "Expand"
    }

  }

  async removeClicked(studentId: number)
  : Promise<void> {
    console.log('removeClicked', studentId)
    await this.courseService.removeStudentFromCourse(this.courseInfo.course_id, studentId)
    await this.updateData()
  }

  async showModal()
  : Promise<void> {
    let modal = document.querySelector("#exampleModal")
    modal.style.display = "block"
    modal.className += " show"
  }

  async closeModal()
  : Promise<void> {
    let modal = document.querySelector("#exampleModal")
    modal.style.display = "none"
    modal.classList.remove("show");
  }

}
</script>

