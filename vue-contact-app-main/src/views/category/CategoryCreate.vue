<template>
  <h1>Create</h1>

  <h4>Category</h4>
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
          <label class="control-label" for="category-name">Category Name</label>
          <input
              v-model="categoryName"
              class="form-control"
              type="text"
              id="category-name"
              data-val-required="The Category Name field is required." />
        </div>
        <div class="form-group">
          <label class="control-label" for="in-course">In Course</label>
          <select v-model="inCourse" @change="inCourseChanged($event)" class="form-select" id="in-course" data-val-required="The In Course field is required.">
            <option
                v-for="course of courses"
                :value="course.course_id"
                :key="course.course_id">{{ course.course_name }}</option>
          </select>
        </div>
        <div class="form-group">
          <label class="control-label" for="parent-category">Parent Category</label>
          <select v-model="parentCategory" class="form-select" id="parent-category">
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
    <RouterLink :to="{ name: 'categories' }">Back to List</RouterLink>
  </div>
</template>


<script lang="ts">
// import { usePersonsStore } from "@/stores/persons";
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import CourseService from "@/services/CourseService";
import CategoryService from "@/services/CategoryService";
import List from "@/List";
import type {ISimpleCourseResult} from "@/domain/ISimpleCourseResult";
import type {ISimpleCategoryResult} from "@/domain/ISimpleCategoryResult";


@Options({
  components: {
  },
  props: {},
  emits: [],
})
export default class CategoryCreate extends Vue {

  courseService = new CourseService();
  categoryService = new CategoryService();

  courses: ISimpleCourseResult[] = []
  categories: ISimpleCategoryResult[] = []

  categoryName: string = ''
  parentCategory: string = ''
  inCourse: string = ''

  errorMessages: List<string> = new List<string>()


  async mounted()
  : Promise<void> {
    console.log("mounted", "CategoryCreate");
    this.categories = await this.categoryService.getAllSimple()
    this.courses = await this.courseService.getAllSimple()

  }


  async submitClicked()
  : Promise<void> {
    console.log('submitClicked')
    this.errorMessages = new List<string>()

    if (this.categoryName.length <= 0) {
      this.errorMessages.push(document.querySelector('#category-name').getAttribute('data-val-required'))
    }

    if (this.inCourse.length <= 0) {
      this.errorMessages.push(document.querySelector('#in-course').getAttribute('data-val-required'))
    }

    // if there rnt any error, then try to post/add
    if (this.errorMessages.length <= 0) {
      await this.categoryService.addCategory(Number(this.inCourse),
          this.parentCategory.length <= 0 ? null : Number(this.parentCategory),
          this.categoryName)
      await this.$router.push('/categories');
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

