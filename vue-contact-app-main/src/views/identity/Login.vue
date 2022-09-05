<template>
    <h1>Login</h1>

    <div class="row">
        <div class="col-md-12">

            <div v-if="errorMsg != null" class="text-danger validation-summary-errors" data-valmsg-summary="true">
                <ul>
                    <li>{{ errorMsg }}</li>
                </ul>
            </div>

            <div>
                <div class="form-group">
                    <label class="control-label" for="FirstName">email</label>
                    <input v-model="email" class="form-control" type="text" />
                </div>
                <div class="form-group">
                    <label class="control-label" for="LastName">password</label>
                    <input v-model="password" class="form-control" type="password" />
                </div>
                <div class="form-group">
                    <input @click="loginClicked()" type="submit" value="Login" class="btn btn-primary" />
                </div>
            </div>
        </div>
    </div>

</template>

<script lang="ts">
// import { IdentityService } from "@/services/AssignmentService";
import { useIdentityStore } from "@/stores/identity";
import { Options, Vue } from "vue-class-component";
import { RouterLink } from "vue-router";

@Options({
    components: {
    },
    props: {},
    emits: [],
})
export default class Login extends Vue {
    // identityStore = useIdentityStore();
    //
    // email: string = '';
    // password: string = '';
    // errorMsg: string | null = null;
    //
    //
    // identityService = new IdentityService();
    //
    // async loginClicked(): Promise<void> {
    //     console.log('submitClicked');
    //     var res = await this.identityService.login(this.email, this.password);
    //     console.log(res);
    //
    //     this.identityStore.$state.jwt = res.data!;
    //
    // }

}
</script>

