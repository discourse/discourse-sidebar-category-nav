import { apiInitializer } from "discourse/lib/api";
import CustomNavigation from "../components/custom-navigation";

export default apiInitializer((api) => {
  api.renderInOutlet("discovery-above", CustomNavigation);
});
