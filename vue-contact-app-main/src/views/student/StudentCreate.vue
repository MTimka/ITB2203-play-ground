<template>
  <h1>Create</h1>

  <h4>Student</h4>
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
          <label class="control-label" for="student-name">Student Name</label>
          <input
              v-model="studentName"
              class="form-control"
              type="text"
              id="student-name"
              data-val-required="The Student Name field is required." />
        </div>
        <div class="form-group">
          <label class="control-label" for="student-code">Student Code</label>
          <input
              v-model="studentCode"
              class="form-control"
              type="text"
              id="student-code"
              data-val-required="The Student Code field is required." />
        </div>
        <div class="form-group">
          <input type="button" value="Add" class="btn btn-primary" @click="submitClicked()" />
        </div>
      </form>
    </div>
  </div>

  <div>
    <RouterLink :to="{ name: 'students' }">Back to List</RouterLink>
  </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import type { ISimpleStudentResult } from "@/domain/ISimpleStudentResult";
import StudentService from "@/services/StudentService";
import List from "@/List";

@Options({
  components: {
  },
  props: {
    id: String
  },
  emits: [],
})
export default class StudentCreate extends Vue {
  id!: string

  studentService = new StudentService();

  studentName: string = ''
  studentCode: string = ''

  // studentInfo: ISimpleStudentResult = {}
  errorMessages: List<string> = new List<string>()

  async mounted()
      : Promise<void> {
    console.log("mounted", "StudentCreate");
    // this.studentInfo = await this.studentService.getInfo(Number(this.id))
    // this.studentName = this.studentInfo.student_name
    // this.studentCode = this.studentInfo.student_code
  }

  async submitClicked()
  : Promise<void> {
    console.log('submitClicked')
    this.errorMessages = new List<string>()

    if (this.studentName.length <= 0) {
      this.errorMessages.push(document.querySelector('#student-name').getAttribute('data-val-required'))
    }

    if (this.studentCode.length <= 0) {
      this.errorMessages.push(document.querySelector('#student-code').getAttribute('data-val-required'))
    }

    if (this.errorMessages.length <= 0) {
      await this.studentService.addStudent(this.studentName, this.studentCode)
      await this.$router.push('/students');
    }

  }

}
</script>

