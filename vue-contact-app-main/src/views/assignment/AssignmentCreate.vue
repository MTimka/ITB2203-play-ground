<template>
    <h1>Create</h1>

    <h4>Assigment</h4>
    <hr />
    <div class="row">
        <div class="col-md-12">
            <div v-for="msg of errorMessages.getItems()" class="text-danger validation-summary-errors" data-valmsg-summary="true">
                <ul>
                    <li>{{ msg }}</li>
                </ul>
            </div>

            <div>
                <div class="form-group">
                    <label class="control-label" for="assignment-name">Assignment Name</label>
                    <input
                        v-model="assignmentName"
                        class="form-control"
                        type="text"
                        id="assignment-name"
                        data-val-required="The Assignment Name field is required." />
                </div>
                <div class="form-group">
                  <label class="control-label" for="assignment-comment">Assignment Comment</label>
                  <input
                      v-model="assignmentComment"
                      class="form-control"
                      type="text"
                      id="assignment-comment" />
                </div>
                <div class="form-group">
                  <label class="control-label" for="weight">Weight</label>
                  <input
                      v-model="weight"
                      class="form-control"
                      type="text" id="weight"
                      data-val-required="The Weight field is required." />
                </div>
                <div class="form-group">
                    <label class="control-label" for="max-points">Max Points</label>
                    <input
                        v-model="maxPoints"
                        class="form-control"
                        type="text" id="max-points"
                        data-val-required="The Max Points field is required." />
                </div>
                <div class="form-group">
                  <label class="control-label" for="in-course">In Course</label>
                  <select v-model="inCourse" @change="inCourseChanged($event)" class="form-select" id="in-course">
                    <option v-for="course of courses" :value="course.course_id" :key="course.course_id" >{{ course.course_name }}</option>
                  </select>
                </div>
                <div class="form-group">
                  <label class="control-label" for="in-category">In Category</label>
                  <select v-model="inCategory" class="form-select" id="in-category">
                    <option v-for="cat of categories" :value="cat.category_id" :key="cat.category_id" >{{ cat.category_name }}</option>
                  </select>
                </div>
                <div class="form-group">
                    <input @click="submitClicked()" type="submit" value="Create" class="btn btn-primary" />
                </div>
            </div>
        </div>
    </div>

    <div>
      <RouterLink :to="{ name: 'assignments' }">Back to List</RouterLink>
    </div>
</template>


<script lang="ts">
import AssignmentService from "@/services/AssignmentService";
import CourseService from "@/services/CourseService";
import CategoryService from "@/services/CategoryService";
import type { ISimpleCourseResult } from "@/domain/ISimpleCourseResult";
import type { ISimpleCategoryResult } from "@/domain/ISimpleCategoryResult";
// import { usePersonsStore } from "@/stores/persons";
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import List from "@/List";

@Options({
    components: {
    },
    props: {},
    emits: [],
})
export default class AssignmentCreate extends Vue {
  // personsStore = usePersonsStore();
  assignmentService = new AssignmentService()
  courseService = new CourseService()
  categoryService = new CategoryService()

  courses: ISimpleCourseResult[] = []
  categories: ISimpleCategoryResult[] = []

  assignmentName: string = ''
  assignmentComment: string = ''
  weight: string = '1'
  maxPoints: string = ''
  inCategory: string = ''
  inCourse: string = ''

  errorMessages: List<string> = new List<string>()

  async mounted()
  : Promise<void> {
    console.log("mounted", "AssignmentCreate");
    this.courses = await this.courseService.getAllSimple()
  }

  async submitClicked()
  : Promise<void> {
    console.log('submitClicked')
    this.errorMessages = new List<string>()

    if (this.assignmentName.length <= 0) {
      this.errorMessages.push(document.querySelector('#assignment-name').getAttribute('data-val-required'))
    }

    if (this.maxPoints.length <= 0) {
      this.errorMessages.push(document.querySelector('#max-points').getAttribute('data-val-required'))
    }

    if (this.weight.length <= 0) {
      this.errorMessages.push(document.querySelector('#weight').getAttribute('data-val-required'))
    }

    // if there rnt any error, then try to post/add
    if (this.errorMessages.length <= 0) {
      await this.assignmentService.addAssignment(Number(this.inCategory), Number(this.inCourse), this.assignmentName,
          this.assignmentComment, Number(this.maxPoints), Number(this.weight))
      await this.$router.push('/assignments');
    }
  }

  async inCourseChanged(event: any)
  : Promise<void> {
    console.log('inCourseChanged', event, event.target.value)
    this.categories = await this.categoryService.getSimpleByCourse(Number(event.target.value))
    console.log("categories", this.categories)
  }
}
</script>

