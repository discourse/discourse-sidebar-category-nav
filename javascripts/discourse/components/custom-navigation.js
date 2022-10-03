import { action } from "@ember/object";
import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";
import { inject as service } from "@ember/service";
import { readOnly } from "@ember/object/computed";

export default Component.extend({
  customNavigation: service(),
  router: service(),
  tagName: "",

  currentRoute: readOnly("router.currentRoute"),
  currentRouteCategoryId: readOnly("customNavigation.currentRouteCategoryId"),
  sidebarCategories: readOnly("customNavigation.sidebarCategories"),

  @discourseComputed(
    "placement",
    "customNavigation.renderAboveMainContainer",
    "customNavigation.renderDiscoveryAbove"
  )
  shouldShow(placement, renderAboveMainContainer, renderDiscoveryAbove) {
    if (placement === "above-main-container") {
      return renderAboveMainContainer;
    } else if (placement === "discovery-above") {
      return renderDiscoveryAbove;
    }
  },

  @action
  toggleSection(e) {
    e.stopPropagation();

    let closest = e.target.closest(".category-sidebar-list-item__parent");
    closest.classList.toggle("show-children");

    if (settings.accordion_expansion) {
      const expandedItems = document.querySelectorAll(
        ".category-sidebar-list-item__parent"
      );

      expandedItems.forEach((item) => {
        if (item !== closest) {
          item.classList.remove("show-children");
        }
      });
    }
  },

  @action
  boxClick(e) {
    if (e.target.nodeName != "A") {
      this.send("toggleSection", e);
    }
  },
});
