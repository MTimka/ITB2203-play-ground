<template>
  <Header />

  <div class="container">
    <main role="main" class="pb-3">
      <RouterView />
    </main>
  </div>

  <Footer />
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import { RouterLink, RouterView } from "vue-router";
import Header from "./components/Header.vue";
import Footer from "./components/Footer.vue";

import { usePersonsStore } from "@/stores/persons";

@Options({
  components: {
    Header, Footer
  }
})
export default class App extends Vue {
  // personsStore = usePersonsStore();
  // personService = new PersonService();

  /*
    constructor() {
      super();

    }
      */

  async mounted(): Promise<void> {
    console.log("mounted");
    // this.personsStore.$state.persons =
    //   await this.personService.getAll();
  }
}
</script>


