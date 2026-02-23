# frozen_string_literal: true

describe "Navigation Rendering" do
  let!(:category) { Fabricate(:category, name: "Test Category") }
  let!(:topic) { Fabricate(:topic, category:) }
  let!(:post) { Fabricate(:post, topic:) }

  before { upload_theme_component }

  context "when on discovery routes" do
    it "renders navigation only once" do
      visit("/")

      expect(page).to have_selector(".category-sidebar-outlet", count: 1)
    end

    it "renders navigation on category pages" do
      visit("/c/#{category.id}")

      expect(page).to have_selector(".category-sidebar-outlet", count: 1)
    end
  end

  context "when on topic routes" do
    it "does render navigation" do
      visit("/t/#{topic.id}")

      expect(page).to have_selector(".category-sidebar-outlet")
    end

    it "renders navigation when navigating directly to a deep post (first chunk of posts not loaded)" do
      deep_topic = Fabricate(:topic, category:)

      22.times { Fabricate(:post, topic: deep_topic) }

      visit("/t/#{deep_topic.slug}/#{deep_topic.id}/22")

      expect(page).to have_selector(".category-sidebar-outlet")
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
