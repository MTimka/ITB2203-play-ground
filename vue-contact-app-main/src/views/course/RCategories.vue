<template>
  <ul v-for="cat of assignmentsInCategory['categories']">
    <li>
      <table class="table">
        <thead>
          <th>{{ cat["name"] }}</th>
          <th v-if="cat.hasOwnProperty('in_group_max_points_weighted')" class="w-20">Achieved Points「 {{ getAchievedWeightedPointsByCategory(cat) }} 」</th>
          <th v-if="cat.hasOwnProperty('in_group_max_points_weighted')" class="w-20">Max Points 「 {{ getWeightedPointsByCategory(cat) }} 」</th>
          <th v-if="cat.hasOwnProperty('in_group_max_points_weighted')" class="w-10">Weight</th>
          <th v-if="cat.hasOwnProperty('in_group_max_points_weighted')" class="w-20"></th>
        </thead>
        <tbody>
          <tr v-for="a of cat['assignments']">
            <td>{{ a.assignment_name }}</td>
            <td v-if="cat.hasOwnProperty('in_group_max_points_weighted')" class="w-20">
              {{ getWeightedPointsByAssignmentId(a.assignment_id) }}
            </td>
            <td v-if="cat.hasOwnProperty('in_group_max_points_weighted')" class="w-20">
              {{ a.assignment_max_points }}
            </td>
            <td v-if="cat.hasOwnProperty('in_group_max_points_weighted')" class="w-10">
              {{ a.assignment_weight }}
            </td>
            <td v-if="cat.hasOwnProperty('in_group_max_points_weighted')" class="w-20">
              <a href="#" @click="addEvaluationClicked(a.assignment_id, a.assignment_max_points)">Give Max Points</a> |
              <!-- Button trigger modal -->
              <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" @click="detailsView.showModal()">
                Grade
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      <RCategories v-bind="{
        assignmentsInCategory: cat,
        studentByCourseInfo: studentByCourseInfo,
        detailsView: detailsView
      }" />
    </li>
  </ul>
</template>

<script lang="ts">

import {Options, Vue} from "vue-class-component";
import EvaluationService from "@/services/EvaluationService";

@Options({
  components: {
  },
  props: {
    assignmentsInCategory: Object,
    studentByCourseInfo: Object,
    detailsView: Object
  },
  emits: [],
})
export default class RCategories extends Vue {
  assignmentsInCategory!: Object
  studentByCourseInfo!: Object
  detailsView!: Object

  evaluationService = new EvaluationService()


  async mounted()
  : Promise<void> {
  }

  getWeightedPointsByCategory(category: any)
  : number {
    let maxPoints = 0

    let recursiveFun = function(cat: any) {
      for (let assignment of cat["assignments"]) {
        maxPoints += assignment.assignment_max_points * assignment.assignment_weight
      }
      for (let c of cat["categories"]) { recursiveFun(c) }
    }

    recursiveFun(category)
    return maxPoints
  }

  getAchievedWeightedPointsByCategory(category: any)
  : number {
    let achievedPoints = 0
    let self = this

    let recursiveFun = function(cat: any) {
      for (let assignment of cat["assignments"]) {
        achievedPoints += self.getWeightedPointsByAssignmentId(assignment.assignment_id)
      }
      for (let c of cat["categories"]) { recursiveFun(c) }
    }

    recursiveFun(category)
    return achievedPoints
  }


  getWeightedPointsByAssignmentId(assignmentId: number)
  : number {
    for (let it of this.studentByCourseInfo['evaluations_list']) {
      if (it.assignment_id == assignmentId) {
        return it.evaluation_points * it.assignment_weight
      }
    }
    return 0
  }

  async addEvaluationClicked(assignmentId: number, points: number)
  : Promise<void> {
    console.log("addEvaluationClicked", assignmentId, points, this.studentByCourseInfo['student_in_course_id'])
    await this.evaluationService.addEvaluation(assignmentId, this.studentByCourseInfo['student_in_course_id'], points)
    this.detailsView.updateData()
  }

}

</script>
