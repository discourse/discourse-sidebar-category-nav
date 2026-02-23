import { apiInitializer } from "discourse/lib/api";
import CustomNavigation from "../components/custom-navigation";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "discovery-above",
    <template><CustomNavigation @outlet="discovery" /></template>
  );

  api.renderInOutlet(
    "before-main-outlet",
    <template><CustomNavigation @outlet="main-container" /></template>
  );
});
