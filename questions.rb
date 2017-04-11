require_relative 'question_database'
require_relative 'user'

class Questions
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0

    Questions.new(question.first)
  end

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
end
