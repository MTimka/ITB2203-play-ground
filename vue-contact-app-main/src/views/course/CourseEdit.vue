<template>
    <h1>Edit</h1>

    <h4>{{courseInfo.course_name}}</h4>
    <hr />
    <div class="row">
        <div class="col-md-4">
            <form>

                <div v-for="msg of errorMessages.getItems()" class="text-danger validation-summary-errors" data-valmsg-summary="true">
                  <ul>
                    <li>{{ msg }}</li>
                  </ul>
                </div>

                <div class="form-group">
                    <label class="control-label" for="course-name">Course Name</label>
                    <input
                        v-model="courseName"
                        class="form-control"
                        type="text"
                        data-val="true"
                        data-val-maxlength="The field Course Name must be a string or array type with a maximum length of &#x27;128&#x27;."
                        data-val-maxlength-max="128"
                        data-val-required="The Course Name field is required."
                        id="course-name"
                        maxlength="128"
                        placeholder="Course Name"
                    />
                </div>
                <div class="form-group">
                    <label class="control-label" for="course-code">Course Code</label>
                    <input
                        v-model="courseCode"
                        class="form-control"
                        type="text"
                        data-val="true"
                        data-val-maxlength="The field Course Code must be a string or array type with a maximum length of &#x27;128&#x27;."
                        data-val-maxlength-max="128"
                        data-val-required="The Course Code field is required."
                        id="course-code"
                        maxlength="128"
                        placeholder="Course Code"
                    />
                </div>
                <div class="form-group">
                    <input type="button" value="Save" class="btn btn-primary" @click="updateClicked()" />
                </div>
            </form>
        </div>
    </div>

    <div>
      <RouterLink :to="{ name: 'courses' }">Back to List</RouterLink>
    </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import type { ISimpleCourseResult } from "@/domain/ISimpleCourseResult";
import CourseService from "@/services/CourseService";
import List from "@/List";

@Options({
  components: {
  },
  props: {
    id: String
  },
  emits: [],
})
export default class CourseEdit extends Vue {
  id!: string

  courseService = new CourseService();

  courseName: string = ''
  courseCode: string = ''
  courseInfo: ISimpleCourseResult = {}
  errorMessages: List<string> = new List<string>()

  async mounted()
  : Promise<void> {
    console.log("mounted", "CourseEdit");
    this.courseInfo = await this.courseService.getInfo(Number(this.id))
    this.courseName = this.courseInfo.course_name
    this.courseCode = this.courseInfo.course_code

    // this.courses = await this.courseService.getAllSimple()
    // console.log(this.courses.data)

  }

  async updateClicked()
  : Promise<void> {
    console.log('updateClicked', this.id)
    this.errorMessages = new List<string>()

    if (this.courseName.length <= 0) {
      this.errorMessages.push(document.querySelector('#course-name').getAttribute('data-val-required'))
    }

    if (this.courseCode.length <= 0) {
      this.errorMessages.push(document.querySelector('#course-code').getAttribute('data-val-required'))
    }

    if (this.errorMessages.length <= 0) {
      await this.courseService.updateCourse(this.id, this.courseName, this.courseCode)
      await this.$router.push('/courses');
    }

  }

}
</script>

