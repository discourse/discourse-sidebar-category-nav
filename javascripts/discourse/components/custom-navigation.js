import Component from "@ember/component";
import discourseComputed, { observes } from "discourse-common/utils/decorators";
import { inject as service } from "@ember/service";
import Category from "discourse/models/category";
import { action } from "@ember/object";
import { schedule } from "@ember/runloop";

export default Component.extend({
  router: service(),
  tagName: "",

  didInsertElement() {
    console.log(this);
    this._super(...arguments);
    this._updateBodyClasses();
  },

  willDestroyElement() {
    this._super(...arguments);
    this._updateBodyClasses();
  },

  _updateBodyClasses() {
    const shouldCleanup = this.isDestroying || this.isDestroyed;
    if (!shouldCleanup && this.shouldShow) {
      document.body.classList.add(`sidebar-navigation-shown`);
    } else {
      document.body.classList.remove("sidebar-navigation-shown");
    }
  },

  @discourseComputed("categoriesLoaded")
  shouldShow(categoriesLoaded) {
    if (categoriesLoaded) {
      return true;
    } else {
      return false;
    }
  },

  @discourseComputed()
  categoriesLoaded() {
    if (this.siteSettings.login_required && !this.currentUser) return false;
    return Category.list().length !== 0;
  },

  @discourseComputed("site.categoriesList")
  sidebarCategories(categoriesList) {
    // using the site.categoriesList only allows categories visible to the current user to be shown
    // this prevents private categories showing up if they are in the list the admin decides to allow
    // in the sidebar
    let filteredIds = settings.sidebar_categories
      .split("|")
      .map(id => parseInt(id));
    return categoriesList.filter(category => {
      return !category.parentCategory;
    });
  },

  @discourseComputed("router.currentRoute")
  currentRouteCategory(currentRoute) {
    if (!currentRoute?.attributes) {
      return false;
    }
    if (
      !currentRoute.name === "discovery.category" ||
      !currentRoute.attributes.category
    ) {
      return false;
    }
    return currentRoute.attributes.category.name;
  },

  @discourseComputed("router.currentRoute")
  currentRoute(currentRoute) {
    if (!currentRoute?.attributes) {
      return false;
    }
    if (
      currentRoute.name !== "discovery.category" ||
      !currentRoute.attributes.category
    ) {
      return false;
    }
    if (
      currentRoute.name !== "discovery.category" ||
      !currentRoute.attributes.category.parentCategory
    ) {
      return false;
    }

    return currentRoute;
  }
});
