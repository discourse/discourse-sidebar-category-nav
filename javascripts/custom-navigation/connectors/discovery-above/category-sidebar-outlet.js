import discourseComputed from "discourse-common/utils/decorators";
import { inject as service } from "@ember/service";

export default {
  setupComponent() {
    this.reopen({
      router: service(),

      @discourseComputed("router.currentRouteName")
      showOnRoute(currentRouteName) {
        if (currentRouteName.indexOf("discovery") > -1) {
          return true;
        } else {
          return false;
        }
      },
    });
  },
};