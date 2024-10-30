import Category from "discourse/models/category";

export default function (categoryId, parentCategoryId) {
  const category = Category.findById(categoryId);
  if (!category) {
    return false;
  }

  return (
    category.parentCategory?.id === parentCategoryId ||
    category.parentCategory?.parentCategory?.id === parentCategoryId
  );
}
