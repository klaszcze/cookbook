class RecipeStatsQuery
  GROUP_BY = {
    'week' => '%W',
    'month' => '%m'
  }.freeze

  def get_stats(author:, group_by:)
    group_by = group_by && group_by.in?(GROUP_BY.keys) ? group_by: 'month'
    query(author: author, group_by: group_by)
  end

  private

  def query(author:, group_by:)
    group_by_format = GROUP_BY[group_by]
    sql = <<-SQL
    SELECT
      categories.name AS category_name,
      strftime('%Y', recipes.created_at) AS year,
      strftime('#{group_by_format}', recipes.created_at) AS #{group_by},
      COUNT(recipes.id) AS recipe_count,
      SUM(COALESCE(likes.count, 0)) AS total_likes
    FROM
      recipes
      JOIN
      authors ON recipes.author_id = authors.id
      JOIN
      recipe_categories ON recipe_categories.recipe_id = recipes.id
      JOIN
      categories ON categories.id = recipe_categories.category_id
      LEFT JOIN
      (SELECT recipe_id, COUNT(*) AS count FROM likes GROUP BY recipe_id) AS likes
      ON likes.recipe_id = recipes.id
    WHERE
        authors.id = #{author.id}
    GROUP BY
        categories.name, strftime('%Y', recipes.created_at), strftime('#{group_by_format}', recipes.created_at)
    ORDER BY
        year DESC, #{group_by} DESC, categories.id;
  SQL

    ActiveRecord::Base.connection.execute(sql)
  end

end