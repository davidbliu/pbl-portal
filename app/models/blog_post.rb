class BlogPost < ParseResource::Base
  fields :title, :content, :author, :folder, :edit_permissions, :view_permissions, :createdAt, :updateAt, :tags
end
