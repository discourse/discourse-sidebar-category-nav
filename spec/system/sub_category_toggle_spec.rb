# frozen_string_literal: true

describe "Sub Category Toggle", type: :system do
  let!(:category) { Fabricate(:category, name: "Test Category") }
  let!(:subcategory) { Fabricate(:category, name: "Test Subcategory", parent_category: category) }

  before { upload_theme_component }

  it "displays subcategories when toggle is clicked" do
    visit("/")

    expect(page).to have_no_selector(".category-sidebar-list-item__parent.show-children")
    find(".sidebar-category-toggle").click
    expect(page).to have_selector(".category-sidebar-list-item__parent.show-children")
    expect(page).to have_selector(
      ".category-sidebar-list-item-link.subcategory-item",
      text: subcategory.name,
    )
  end

  it "displays subcategories when on category page" do
    visit("/c/#{category.id}")
    expect(page).to have_selector(".category-sidebar-list-item__parent.show-children")
    expect(page).to have_selector(
      ".category-sidebar-list-item-link.subcategory-item",
      text: subcategory.name,
    )
  end
end
