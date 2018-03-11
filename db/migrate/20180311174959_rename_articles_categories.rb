class RenameArticlesCategories < ActiveRecord::Migration
  def change
    rename_table :articles_categories, :article_categories
  end
end
