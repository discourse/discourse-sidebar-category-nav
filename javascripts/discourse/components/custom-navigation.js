import Component from "@ember/component";
import { action } from "@ember/object";
import { readOnly } from "@ember/object/computed";
import { service } from "@ember/service";
import discourseComputed from "discourse-common/utils/decorators";

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
    if (
      e.target.nodeName !== "A" &&
      (e.type === "click" || (e.type === "keyup" && e.key === "Enter"))
    ) {
      const currentParent = e.target.closest(
        ".category-sidebar-list-item__parent"
      );
      const toggle = currentParent.querySelector(".sidebar-category-toggle");

      currentParent.classList.toggle("show-children");
      toggle.setAttribute(
        "aria-expanded",
        toggle.getAttribute("aria-expanded") === "false"
      );

      if (settings.accordion_expansion) {
        // toggle state of all shown items
        document
          .querySelectorAll(".category-sidebar-list-item__parent.show-children")
          .forEach((item) => {
            if (item !== currentParent) {
              item.classList.remove("show-children");
              item
                .querySelector(".sidebar-category-toggle")
                .setAttribute("aria-expanded", "false");
            }
          });
      }
    }
  },
});
