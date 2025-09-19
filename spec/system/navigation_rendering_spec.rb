# frozen_string_literal: true

describe "Navigation Rendering", type: :system do
  let(:theme) do
    parent_theme = Fabricate(:theme, name: "Parent Theme")
    component = Fabricate(:theme, name: "Category Sidebar Navigation", component: true)
    parent_theme.set_default!
  end

  before do
    theme
    upload_theme_component
    @category = Fabricate(:category, name: "Test Category")
    @topic = Fabricate(:topic, category: @category)
    @post = Fabricate(:post, topic: @topic)
  end

  context "when on discovery routes" do
    it "renders navigation only once" do
      visit("/")

      expect(page).to have_selector(".category-sidebar-outlet", count: 1)
    end

    it "renders navigation on category pages" do
      visit("/c/#{@category.id}")

      expect(page).to have_selector(".category-sidebar-outlet", count: 1)
    end
  end

  context "when on topic routes" do
    it "does not render navigation" do
      visit("/t/#{@topic.slug}/#{@topic.id}")

      expect(page).to have_no_selector(".category-sidebar-outlet")
    end
  end

  context "when on categories page" do
    it "renders navigation only once" do
      visit("/categories")

      expect(page).to have_selector(".category-sidebar-outlet", count: 1)
    end
  end

  context "while elsewhere navigation does not render" do
    it "does not render on user profiles" do
      user = Fabricate(:user)
      visit("/u/#{user.username}")

      expect(page).to have_no_selector(".category-sidebar-outlet")
    end
  end
end
