import { computed } from "@ember/object";
import Service, { service } from "@ember/service";
import Site from "discourse/models/site";
import { bind } from "discourse-common/utils/decorators";

const CLASS_NAME = "sidebar-navigation-shown";

export default class CustomNavigationService extends Service {
  @service router;

  init() {
    super.init(...arguments);
    this.updateBodyClasses();
    this.router.on("routeDidChange", this.updateBodyClasses);
  }

  willDestroy() {
    super.willDestroy(...arguments);
    this.router.off("routeDidChange", this.updateBodyClasses);
  }

  @bind
  updateBodyClasses() {
    if (this.renderDiscoveryAbove || this.renderAboveMainContainer) {
      document.body.classList.add(CLASS_NAME);
    } else {
      document.body.classList.remove(CLASS_NAME);
    }
  }

  @computed("router.currentRouteName")
  get renderAboveMainContainer() {
    return (
      this.categoriesLoaded &&
      this.router.currentRouteName?.startsWith("topic.")
    );
  }

  @computed("router.currentRouteName")
  get renderDiscoveryAbove() {
    return (
      this.categoriesLoaded &&
      (this.router.currentRouteName?.startsWith("discovery.") ||
        this.router.currentRouteName?.startsWith("tag."))
    );
  }

  @computed()
  get sidebarCategories() {
    // using the site.categoriesList only allows categories visible to the current user to be shown
    // this prevents private categories showing up if they are in the list the admin decides to allow
    // in the sidebar
    let filteredIds = settings.sidebar_categories
      .split("|")
      .filter(Boolean)
      .map((id) => parseInt(id, 10));

    const topLevelCategories = Site.current().categoriesList.filter(
      (category) => {
        return !category.parentCategory;
      }
    );

    if (filteredIds.length > 0) {
      return topLevelCategories.filter((c) => filteredIds.includes(c.id));
    } else {
      return topLevelCategories;
    }
  }

  @computed
  get categoriesLoaded() {
    if (this.siteSettings.login_required && !this.currentUser) {
      return false;
    }
    return !!Site.current().categoriesList.length;
  }

  @computed("router.currentRoute")
  get currentRouteCategoryId() {
    const currentRoute = this.router.currentRoute;
    if (currentRoute?.name.startsWith("discovery.")) {
      return currentRoute.attributes.category?.id;
    } else if (currentRoute?.name.startsWith("topic.")) {
      return currentRoute.parent?.attributes?.category_id;
    }
  }
}
