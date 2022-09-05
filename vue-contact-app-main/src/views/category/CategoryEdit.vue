<template>
  <h1>Edit</h1>

  <h4>{{categoryInfo.category_name}}</h4>
  <hr />
  <div class="row">
    <div class="col-md-4">
      <div v-for="msg of errorMessages.getItems()" class="text-danger validation-summary-errors" data-valmsg-summary="true">
        <ul>
          <li>{{ msg }}</li>
        </ul>
      </div>

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
        <select v-model="inCourse" @change="inCourseChanged($event)" class="form-select" id="in-course">
          <option
              v-for="course of courses"
              :value="course.course_id"
              :key="course.course_id">{{ course.course_name }}</option>
        </select>
      </div>
      <div class="form-group">
        <label class="control-label" for="in-category">Parent Category</label>
        <select v-model="parentCategory" class="form-select" id="in-category">
          <option v-for="cat of categories" :value="cat.category_id" :key="cat.category_id" >{{ cat.category_name }}</option>
        </select>
      </div>
      <div class="form-group">
        <input @click="updateClicked()" type="button" value="Edit" class="btn btn-primary" />
      </div>
    </div>
  </div>

  <div>
    <RouterLink :to="{ name: 'categories' }">Back to List</RouterLink>
  </div>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import type { ISimpleAssignmentResult } from "@/domain/ISimpleAssignmentResult";
import CourseService from "@/services/CourseService";
import CategoryService from "@/services/CategoryService";
import List from "@/List";
import type {ISimpleCourseResult} from "@/domain/ISimpleCourseResult";
import type {ISimpleCategoryResult} from "@/domain/ISimpleCategoryResult";

@Options({
  components: {
  },
  props: {
    id: String
  },
  emits: [],
})
export default class CategoryEdit extends Vue {
  id!: string

  courseService = new CourseService();
  categoryService = new CategoryService();

  courses: ISimpleCourseResult[] = []
  categories: ISimpleCategoryResult[] = []

  categoryName: string = ''
  parentCategory: string = ''
  inCourse: string = ''

  categoryInfo: ISimpleCategoryResult = {}
  errorMessages: List<string> = new List<string>()

  async mounted()
  : Promise<void> {
    console.log("mounted", "CategoryEdit");
    this.categoryInfo = await this.categoryService.getInfo(Number(this.id))
    this.courses = await this.courseService.getAllSimple()

    let categories = await this.categoryService.getSimpleByCourse(this.categoryInfo.course_id)
    this.categories = categories.filter((it) => {
      console.log("filter", it.category_id, Number(this.id))
      return it.category_id !== Number(this.id)
    })
    // console.log("categories", this.categories)

    this.categoryName = this.categoryInfo.category_name
    this.parentCategory = this.categoryInfo.category_parent_name
    this.parentCategory = this.categoryInfo.category_parent_id
    this.inCourse = this.categoryInfo.course_id
  }

  async updateClicked()
  : Promise<void> {
    console.log('updateClicked', this.id)
    this.errorMessages = new List<string>()

    if (this.categoryName.length <= 0) {
      this.errorMessages.push(document.querySelector('#category-name').getAttribute('data-val-required'))
    }

    // if there rnt any error, then try to post/add
    if (this.errorMessages.length <= 0) {
      await this.categoryService.updateCategory(Number(this.id), Number(this.inCourse),
          this.parentCategory.length <= 0 ? null : Number(this.parentCategory),
          this.categoryName)
      await this.$router.push('/categories');
    }

  }

  async inCourseChanged(event: any)
  : Promise<void> {
    console.log('inCourseChanged', event, event.target.value)

    let categories = await this.categoryService.getSimpleByCourse(Number(event.target.value))

    this.categories = categories.filter((it) => {
      console.log("filter", it.category_id, Number(this.id))
      return it.category_id !== Number(this.id)
    })

    console.log("categories", this.categories)

    this.parentCategory = '';
  }

}
</script>

