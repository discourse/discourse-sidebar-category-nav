import { registerUnbound } from "discourse-common/lib/helpers";

registerUnbound("childIsActive", (currentRoute, parentSlug) => {
  if (
    !currentRoute ||
    !currentRoute.attributes ||
    !currentRoute.attributes.category
  )
    {return false;}

  let currentPath =
    currentRoute.attributes.modelParams.category_slug_path_with_id;

  return currentPath.includes(parentSlug);
});
