require_relative 'question_database'

class Replies
  attr_accessor :id, :question_id, :user_id, :body, :reply_id

  def self.find_by_id(id)
    reply = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless reply.length > 0

    Replies.new(reply.first)
  end

  def initialize(options)
    @id, @question_id, @user_id, @body, @reply_id =
      options.values_at('id', 'question_id', 'user_id', 'body', 'reply_id')
  end

  def self.find_by_user_id(user_id)
    replies = QuestionDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    retunr nil unless replies.length > 0

    replies.map { |reply| Replies.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    retunr nil unless replies.length > 0

    replies.map { |reply| Replies.new(reply) }
  end
end
