import Component from "@ember/component";
import { concat } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { readOnly } from "@ember/object/computed";
import { LinkTo } from "@ember/routing";
import { service } from "@ember/service";
import { tagName } from "@ember-decorators/component";
import { and, eq, or } from "truth-helpers";
import icon from "discourse/helpers/d-icon";
import htmlSafe from "discourse/helpers/html-safe";
import { i18n } from "discourse-i18n";
import childIsActive from "../helpers/child-is-active";

@tagName("")
export default class CustomNavigation extends Component {
  @service customNavigation;
  @service router;

  @readOnly("router.currentRoute") currentRoute;
  @readOnly("customNavigation.currentRouteCategoryId") currentRouteCategoryId;
  @readOnly("customNavigation.sidebarCategories") sidebarCategories;

  get shouldRender() {
    if (this.outlet === "discovery") {
      return this.customNavigation.renderDiscoveryAbove;
    } else if (this.outlet === "main-container") {
      return this.customNavigation.renderAboveMainContainer;
    }
  }

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
  }

  <template>
    {{#if this.shouldRender}}
      <div class="category-sidebar-outlet">
        <div class="category-sidebar">
          <ul class="category-sidebar-list">
            <li class="category-sidebar-list-item all-topics">
              <LinkTo
                @route="discovery.latest"
                class="category-sidebar-list-item-link"
              >
                All Topics
              </LinkTo>
            </li>

            {{#each this.sidebarCategories as |sidebarCategory|}}
              <li
                class={{concat
                  "category-sidebar-list-item category-sidebar-list-item__parent "
                  (if
                    (or
                      (and
                        (eq this.currentRouteCategoryId sidebarCategory.id)
                        sidebarCategory.has_children
                      )
                      (childIsActive
                        this.currentRouteCategoryId sidebarCategory.id
                      )
                    )
                    "show-children"
                  )
                }}
                style={{htmlSafe
                  (concat "--category-color: #" sidebarCategory.color ";")
                }}
              >
                <div class="category-sidebar-list-item__parent-container">
                  <LinkTo
                    @route="discovery.category"
                    @model={{concat
                      sidebarCategory.slug
                      "/"
                      sidebarCategory.id
                    }}
                    class="category-sidebar-list-item-link"
                    @current-when={{eq
                      this.currentRouteCategoryId
                      sidebarCategory.id
                    }}
                  >
                    <span
                      class="sidebar-category-badge"
                    ></span>{{sidebarCategory.name}}
                  </LinkTo>
                  {{#if sidebarCategory.has_children}}
                    <div
                      class="sidebar-category-toggle"
                      role="button"
                      tabindex="0"
                      {{on "click" this.toggleSection}}
                      {{on "keyup" this.toggleSection}}
                      aria-expanded={{if
                        (or
                          (and
                            (eq this.currentRouteCategoryId sidebarCategory.id)
                            sidebarCategory.has_children
                          )
                          (childIsActive
                            this.currentRouteCategoryId sidebarCategory.id
                          )
                        )
                        "true"
                        "false"
                      }}
                      aria-controls={{concat
                        "category-sidebar-list-"
                        sidebarCategory.id
                      }}
                      aria-label={{i18n
                        (themePrefix "subcategory_toggle")
                        category=sidebarCategory.name
                      }}
                    >
                      {{icon "chevron-right"}}
                    </div>
                  {{/if}}
                </div>
                {{#if
                  (or
                    sidebarCategory.has_children
                    (childIsActive
                      this.currentRouteCategoryId sidebarCategory.id
                    )
                  )
                }}
                  <ul
                    class="category-sidebar-list subcategories"
                    id={{concat "category-sidebar-list-" sidebarCategory.id}}
                  >
                    {{#each sidebarCategory.subcategories as |childCategory|}}
                      <li
                        class="category-sidebar-list-item child
                          {{if childCategory.subcategories 'has-children'}}"
                        style={{htmlSafe
                          (concat "--category-color: #" childCategory.color ";")
                        }}
                      >
                        <LinkTo
                          @route="discovery.category"
                          @model={{concat
                            sidebarCategory.slug
                            "/"
                            childCategory.slug
                            "/"
                            childCategory.id
                          }}
                          class="category-sidebar-list-item-link subcategory-item"
                          @current-when={{eq
                            this.currentRouteCategoryId
                            childCategory.id
                          }}
                        >
                          {{childCategory.name}}
                        </LinkTo>

                        {{#if
                          (or
                            (eq this.currentRouteCategoryId childCategory.id)
                            childCategory.has_children
                          )
                        }}
                          <ul class="category-sidebar-list sub-subcategories">
                            {{#each
                              childCategory.subcategories
                              as |grandChildCategory|
                            }}
                              <li
                                class="category-sidebar-list-item grandchild"
                                style={{htmlSafe
                                  (concat
                                    "--category-color: #"
                                    grandChildCategory.color
                                    ";"
                                  )
                                }}
                              >
                                <LinkTo
                                  @route="discovery.category"
                                  @model={{concat
                                    sidebarCategory.slug
                                    "/"
                                    childCategory.slug
                                    "/"
                                    grandChildCategory.slug
                                    "/"
                                    grandChildCategory.id
                                  }}
                                  class="category-sidebar-list-item-link subcategory-item grandchild"
                                  @current-when={{eq
                                    this.currentRouteCategoryId
                                    grandChildCategory.id
                                  }}
                                >
                                  {{grandChildCategory.name}}
                                </LinkTo>
                              </li>
                            {{/each}}
                          </ul>
                        {{/if}}
                      </li>
                    {{/each}}
                  </ul>
                {{/if}}
              </li>
            {{/each}}
          </ul>
        </div>
      </div>
    {{/if}}
  </template>
}
