require_relative 'question_database'

class Users
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    user = QuestionDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0

    Users.new(user.first)
  end

  def initialize(options)
    @id, @fname, @lname = options.values_at('id', 'fname', "lname")
  end

  def self.find_by_name(fname, lname)
    user = QuestionDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname, lname = ?, ?
    SQL
    return nil unless user.length > 0

    Users.new(user.first)
  end

  def authored_questions(id)
    Questions.find_by_author_id(id)
  end

  def authored_replies(id)
    Replies.find_by_user_id(id)
  end
end
