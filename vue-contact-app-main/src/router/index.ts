import AssignmentsListIndex from "@/views/assignment/AssignmentsListIndex.vue";
import ContactTypeIndex from "@/views/category/CategoriesListIndex.vue";
import CourseCreate from "@/views/course/CourseCreate.vue";
import CourseEdit from "@/views/course/CourseEdit.vue";
import CourseDetails from "@/views/course/CourseDetails.vue";
import Login from "@/views/identity/Login.vue";
import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import CoursesListIndex from "@/views/course/CoursesListIndex.vue";
import AssignmentCreate from "@/views/assignment/AssignmentCreate.vue";
import AssignmentEdit from "@/views/assignment/AssignmentEdit.vue";
import CategoriesListIndex from "@/views/category/CategoriesListIndex.vue";
import CategoryEdit from "@/views/category/CategoryEdit.vue";
import CategoryCreate from "@/views/category/CategoryCreate.vue";
import StudentsListIndex from "@/views/student/StudentsListIndex.vue";
import StudentEdit from "@/views/student/StudentEdit.vue";
import StudentCreate from "@/views/student/StudentCreate.vue";
import CourseAddStudent from "@/views/course/CourseAddStudent.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: HomeView,
    },
    {
      path: "/identity/account/login",
      name: "login",
      component: Login,
    },

    // { path: "/test", name: "test", component: Folder },

    { path: "/courses", name: "courses", component: CoursesListIndex},
    { path: "/courses/index", name: "courses-index", component: CoursesListIndex},
    { path: "/course/create", name: "course-create", component: CourseCreate},
    { path: "/course/edit/:id", name: "course-edit", component: CourseEdit, props: true},
    { path: "/course/details/:id", name: "course-details", component: CourseDetails, props: true},
    { path: "/course/add-student/:id", name: "course-add-student", component: CourseAddStudent, props: true},

    { path: "/assignments", name: "assignments", component: AssignmentsListIndex},
    { path: "/assignments/index", name: "assignments-index", component: AssignmentsListIndex},
    { path: "/assignment/create", name: "assignment-create", component: AssignmentCreate},
    { path: "/assignment/edit:id", name: "assignment-edit", component: AssignmentEdit, props: true},

    { path: "/categories", name: "categories", component: CategoriesListIndex},
    { path: "/categories/index", name: "categories-index", component: CategoriesListIndex},
    { path: "/category/create", name: "category-create", component: CategoryCreate},
    { path: "/category/edit:id", name: "category-edit", component: CategoryEdit, props: true},

    { path: "/students", name: "students", component: StudentsListIndex},
    { path: "/students/index", name: "students-index", component: StudentsListIndex},
    { path: "/student/create", name: "student-create", component: StudentCreate},
    { path: "/student/edit:id", name: "student-edit", component: StudentEdit, props: true},
  ]
});

export default router;
