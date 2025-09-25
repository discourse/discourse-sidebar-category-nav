import { apiInitializer } from "discourse/lib/api";
import CustomNavigation from "../components/custom-navigation";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "discovery-above",
    <template><CustomNavigation @outlet="discovery" /></template>
  );

  api.renderInOutlet(
    "above-main-container",
    <template><CustomNavigation @outlet="main-container" /></template>
  );
});
