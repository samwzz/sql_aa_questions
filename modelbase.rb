require_relative 'question_database'

class Model

  def self.all
   data = QuestionsDatabase.instance.execute("SELECT * FROM #{self.to_s.downcase}")
   data.map { |datum| self.new(datum) }
  end

  def self.find_by_id(id)
    array = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self.to_s.downcase}
      WHERE
        id = ?
    SQL
    return nil unless array.length > 0

    self.new(array.first)
  end

  # def self.where(options = {})
  #   variables = options.keys.map(&:to_s).join(", ")
  #   array = QuestionsDatabase.instance.execute(<<-SQL, #{variables})
  #     SELECT
  #       *
  #     FROM
  #       #{self.to_s.downcase}
  #     WHERE
  #       id = ?
  #   SQL
  #   return nil unless array.length > 0

    self.new(array.first)
  end
end
