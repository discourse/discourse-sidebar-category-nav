import { getOwner } from "discourse-common/lib/get-owner";

export default {
  shouldRender(args, component) {
    const router = getOwner(this).lookup("router:main");
    return router.currentRouteName.includes("topic");
  },
};