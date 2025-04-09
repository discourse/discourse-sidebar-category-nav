# frozen_string_literal: true

describe "Sub Category Toggle", type: :system do
  let(:theme) do
    parent_theme = Fabricate(:theme, name: "Parent Theme")
    component = Fabricate(:theme, name: "Category Sidebar Navigation", component: true)
    parent_theme.set_default!
  end

  before do
    theme
    upload_theme_component
    @category = Fabricate(:category, name: "Test Category")
    @subcategory = Fabricate(:category, name: "Test Subcategory", parent_category: @category)
  end

  it "displays subcategories when toggle is clicked" do
    visit("/")

    expect(page).to have_no_selector(".category-sidebar-list-item__parent.show-children")
    find(".sidebar-category-toggle").click
    expect(page).to have_selector(".category-sidebar-list-item__parent.show-children")
    expect(page).to have_selector(
      ".category-sidebar-list-item-link.subcategory-item",
      text: @subcategory.name,
    )
  end

  it "displays subcategories when on category page" do
    visit("/c/#{@category.id}")
    expect(page).to have_selector(".category-sidebar-list-item__parent.show-children")
    expect(page).to have_selector(
      ".category-sidebar-list-item-link.subcategory-item",
      text: @subcategory.name,
    )
  end
end
