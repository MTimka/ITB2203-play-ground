
<template>
  <h1>Categories Index</h1>

  <p>
    <RouterLink to="/category/create">Create new</RouterLink>
  </p>
  <table class="table">
    <thead>
    <tr>
      <th>Category Name</th>
      <th>Parent Category</th>
      <th>In Course</th>
      <th class="w-20"></th>
    </tr>
    </thead>
    <tbody>
    <tr v-for="item of categories" :key="item.category_id">
      <td>{{ item.category_name }}</td>
      <td>{{ item.category_parent_name }}</td>
      <td>{{ item.course_name }} 「 {{ item.course_code }} 」</td>
      <td class="w-20">
        <RouterLink :to="{ name: 'category-edit', params: { id: item.category_id } }">Edit</RouterLink> |
        <a href="/Persons/Details/d31d15f4-517c-43b1-a1b8-5dac38c99c01">Details</a> |
        <a href="#" @click="deleteClicked(item.category_id)">Delete</a>
      </td>
    </tr>
    </tbody>
  </table>
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";
import CategoryService from "@/services/CategoryService";
import type { ISimpleCategoryResult } from "@/domain/ISimpleCategoryResult";
import List from "@/List";

@Options({
  components: {
  },
  props: {},
  emits: [],
})
export default class CategoriesListIndex extends Vue {

  categoryService = new CategoryService()
  categories: ISimpleCategoryResult[] = []


  async mounted()
  : Promise<void> {
    console.log("mounted", "CategoriesListIndex");
    this.categories = await this.categoryService.getAllSimple()
    console.log(this.categories)
  }

  async deleteClicked(categoryId: number)
  : Promise<void> {
    console.log('deleteClicked', categoryId)
    // await this.courseService.deleteCourse(course_id)
    // this.assignments = await this.assignmentService.getAllSimple()
  }


}
</script>

