import { registerUnbound } from "discourse-common/lib/helpers";
import Category from "discourse/models/category";

registerUnbound("childIsActive", (categoryId, parentCategoryId) => {
  const c = Category.findById(categoryId);
  if (!c) {
    return false;
  }

  if (c.parentCategory?.id === parentCategoryId) {
    return true;
  }

  if (c.parentCategory?.parentCategory?.id === parentCategoryId) {
    return true;
  }

  return false;
});
