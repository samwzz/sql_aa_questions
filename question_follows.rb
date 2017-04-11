require_relative 'question_database'
require_relative 'questions'
require_relative 'user'

class QuestionFollows
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    follow = QuestionsDatabase.instance.execute(<<-SQL, id)
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

  def self.followers_for_question_id(question_id)
    users = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL
    return nil unless users.length > 0

    users.map { |user| Users.new(user) }
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      WHERE
        user_id = ?
    SQL
    return nil unless questions.length > 0

    questions.map { |question| Questions.new(question) }
  end

  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      *
    FROM
      questions
    JOIN
      question_follows ON questions.id = question_follows.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(*) DESC
    LIMIT
      ?
    SQL
    return nil unless questions.length > 0

    questions.map { |question| Questions.new(question) }
  end
end
