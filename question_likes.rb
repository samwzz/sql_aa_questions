require_relative 'question_database'
require_relative 'user'
require_relative 'questions'

class QuestionLikes
  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
    like = QuestionsDatabase.instance.execute(<<-SQL, id)
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

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.user_id
      WHERE
        question_id = ?
    SQL
      return nil unless likers.length > 0

      likers.map { |liker| Users.new(liker) }
    end

    def self.num_likes_for_question_id(question_id)
      num_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
          COUNT(*)
        FROM
          question_likes
        WHERE
          question_id = ?
      SQL
        return nil unless num_likes.first.values.first >= 0

        num_likes.first.values.first
    end

    def self.liked_questions_for_user_id(user_id)
      liked_questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
          *
        FROM
          questions
        JOIN
          question_likes ON questions.id = question_likes.question_id
        WHERE
          user_id = ?
      SQL
        return nil unless liked_questions.length > 0

        liked_questions.map { |question| Questions.new(question) }
    end

    def self.most_liked_questions(n)
      questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
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
