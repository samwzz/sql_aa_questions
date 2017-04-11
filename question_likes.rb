require_relative 'question_database'

class QuestionLikes
  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
    like = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    return nil unless like.length > 0

    QuestionLikes.new(like.first)
  end

  def initialize(options)
    @id, @user_id, @question_id = options.values_at('id', 'user_id', 'question_id')
  end
end
