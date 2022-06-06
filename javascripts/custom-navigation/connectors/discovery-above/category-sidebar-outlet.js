import discourseComputed from "discourse-common/utils/decorators";
import { inject as service } from "@ember/service";

export default {
  setupComponent() {
    this.reopen({
      router: service(),

      @discourseComputed("router.currentRouteName")
      showOnRoute(currentRouteName) {
        console.log(currentRouteName);
        if (currentRouteName.indexOf("discovery") > -1 || currentRouteName.indexOf("tag") > -1) {
          return true;
        } else {
          return false;
        }
      }
    });
  }
};
