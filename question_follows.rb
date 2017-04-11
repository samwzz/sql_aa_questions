require_relative 'question_database'

class QuestionFollows
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    follow = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil unless follow.length > 0

    QuestionFollows.new(follow.first)
  end

  def initialize(options)
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end
end
