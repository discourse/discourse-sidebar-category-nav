import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import CustomNavigation from "../../components/custom-navigation";

@classNames("above-main-container-outlet", "category-sidebar-outlet")
export default class CategorySidebarOutlet extends Component {
  <template><CustomNavigation @placement="above-main-container" /></template>
}
