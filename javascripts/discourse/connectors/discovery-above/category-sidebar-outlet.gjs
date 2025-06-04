import Component from "@ember/component";
import { classNames } from "@ember-decorators/component";
import CustomNavigation from "../../components/custom-navigation";

@classNames("discovery-above-outlet", "category-sidebar-outlet")
export default class CategorySidebarOutlet extends Component {
  <template><CustomNavigation @placement="discovery-above" /></template>
}
