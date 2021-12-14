import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
  tagName: "",

  init() {
    this._super(...arguments);
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
      return filteredIds.includes(category.id);
    });
  }
});
