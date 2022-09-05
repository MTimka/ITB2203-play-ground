<template>
    <h1>Create</h1>

    <h4>Course</h4>
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
                    <label class="control-label" for="course-name">Course Name</label>
                    <input v-model="courseName" class="form-control" type="text" id="course-name" />
                </div>
                <div class="form-group">
                    <label class="control-label" for="course-code">Course Code</label>
                    <input v-model="courseCode" class="form-control" type="text" id="course-code"/>
                </div>
                <div class="form-group">
                  <label class="control-label" for="self-reg-key">Self registration key</label>
                  <input v-model="selfRegKey" class="form-control" type="text" id="self-reg-key" />
                </div>
                <div class="form-group">
                    <input @click="submitClicked()" type="submit" value="Create" class="btn btn-primary" />
                </div>
            </div>
        </div>
    </div>

    <div>
      <RouterLink :to="{ name: 'courses' }">Back to List</RouterLink>
    </div>
</template>


<script lang="ts">
import CourseService from "@/services/CourseService";
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import List from "@/List";

@Options({
    components: {
    },
    props: {},
    emits: [],
})
export default class CourseCreate extends Vue {
  courseService = new CourseService()


  courseName: string = ''
  courseCode: string = ''
  selfRegKey: string = ''
  errorMessages: List<string> = new List<string>()


  async submitClicked()
  : Promise<void> {
    console.log('submitClicked')

    if (this.courseName.length > 0 && this.courseCode.length > 0) {
      await this.courseService.addCourse(this.courseName, this.courseCode)
      await this.$router.push('/courses');
    } else {
      errorMessages.push('Too short!')
    }
  }
}
</script>

