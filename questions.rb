require_relative 'question_database'
require_relative 'user'
require_relative 'question_follows'
require_relative 'question_likes'
require_relative 'modelbase'

class Questions < Model
  attr_accessor :id, :title, :body, :author_id

  # def self.all
  #  data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
  #  data.map { |datum| Questions.new(datum) }
  # end
  #
  # def self.find_by_id(id)
  #   question = QuestionsDatabase.instance.execute(<<-SQL, id)
  #     SELECT
  #       *
  #     FROM
  #       questions
  #     WHERE
  #       id = ?
  #   SQL
  #   return nil unless question.length > 0
  #
  #   Questions.new(question.first)
  # end

  def initialize(options)
    @id, @title, @body, @author_id = options.values_at("id", "title",
      "body", "author_id")
  end

  def self.find_by_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    return nil unless questions.length > 0

    questions.map { |question| Questions.new(question) }
  end

  def author
    author = Users.find_by_id(@author_id)
  end

  def replies
    Replies.find_by_question_id(@id)
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def likers
    QuestionLikes.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLikes.num_likes_for_question_id(@id)
  end

  def self.most_liked(n)
    QuestionLikes.most_liked_questions(n)
  end

  def save
    @id.nil? ? self.create : self.update
  end

  def create
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id)
      INSERT INTO
        questions (title, body, author_id)
      VALUES
        (?, ?, ?)
    SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @author_id, @id)
      UPDATE
        questions
      SET
        title = ?
        body = ?
        author_id = ?
      WHERE
        id = ?
    SQL
  end
end
