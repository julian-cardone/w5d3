require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class Users
    attr_accessor :id, :fname, :lname

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM users WHERE id = #{id}")
        data.map {|datum| Users.new(datum)}
    end

    def self.find_by_name(fname, lname)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)

            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?

            SQL
   
        data.map {|datum| Users.new(datum)}

    end

    def initialize(hash)
        @id = hash['id']
        @fname = hash['fname']
        @lname = hash['lname']
    end

end

class Questions 

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE id = #{id}")
        data.map {|datum| Questions.new(datum)}
    end

     def initialize(hash)
        @id = hash['id']
        @title = hash['title']
        @body = hash['body']
        @author_id = hash['author_id']
     end

end

class Replies

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE id = #{id}")
        data.map {|datum| Replies.new(datum)}
    end

    def initialize(hash)
        @id = hash['id']
        @body = hash['body']
        @questions_id = hash['questions_id']
        @parent_reply_id = hash['parent_reply_id']
        @author_id = hash['author_id']
    end

end