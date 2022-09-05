import type { IPerson } from "@/domain/IPerson";
// import { PersonService } from "@/services/PersonService";
import { defineStore } from "pinia";
export const usePersonsStore = defineStore({
  id: "persons",
  state: () => ({
    persons: [
    ] as IPerson[],
  }),
  getters: {
    personCount: (state) => state.persons.length,
  },
  actions: {
    add(person: IPerson) {
      this.persons.push(person);
    }
  },
});
