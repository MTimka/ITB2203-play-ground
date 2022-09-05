import { createApp } from "vue";

import { createPinia } from "pinia";

import App from "./App.vue";
import router from "./router";

import 'jquery';
import 'popper.js';
import 'bootstrap';
// import 'bootstrap-vue'

import 'bootstrap/dist/css/bootstrap.min.css';
// import 'bootstrap-vue/dist/bootstrap-vue.css';

// import 'bootstrap/dist/js/bootstrap.min.js';
import 'font-awesome/css/font-awesome.min.css';

import '../src/assets/css/styles.scss';

const app = createApp(App);

app.use(createPinia());
app.use(router);

app.mount("#app");
