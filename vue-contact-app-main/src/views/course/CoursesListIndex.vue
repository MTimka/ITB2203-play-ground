
<template>
    <h1>Courses Index</h1>

    <p>
        <RouterLink to="/course/create">Create new</RouterLink>
    </p>
    <table class="table">
        <thead>
            <tr>
                <th>Course Name</th>
                <th>Course Code</th>
                <th>Creator Name</th>
                <th class="w-20"></th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="item of courses" :key="item.course_id">
                <td>{{ item.course_name }}</td>
                <td>{{ item.course_code }}</td>
                <td>{{ item.course_creator_name }}</td>
                <td class="w-20">
                    <RouterLink :to="{ name: 'course-edit', params: { id: item.course_id } }">Edit</RouterLink> |
                    <RouterLink :to="{ name: 'course-details', params: { id: item.course_id } }">Details</RouterLink> |
                    <a href="#" @click="deleteClicked(item.course_id)">Delete</a>
                </td>
            </tr>
        </tbody>
    </table>
</template>

<script lang="ts">
import CourseService from "@/services/CourseService";
import { Options, Vue } from "vue-class-component";
import type { ISimpleCourseResult } from "@/domain/ISimpleCourseResult";


@Options({
    components: {
    },
    props: {},
    emits: [],
})
export default class CoursesListIndex extends Vue {

  courseService = new CourseService()
  courses: ISimpleCourseResult[] = []


  async mounted()
  : Promise<void> {
    console.log("mounted");
    this.courses = await this.courseService.getAllSimple()
    console.log(this.courses)
  }

  async deleteClicked(course_id: number)
  : Promise<void> {
    console.log('deleteClicked', course_id)
    await this.courseService.deleteCourse(course_id)
    this.courses = await this.courseService.getAllSimple()
  }

}

</script>

