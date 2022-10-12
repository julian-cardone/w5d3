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

    def authored_questions
        Questions.find_by_author_id(self.id)
    end

    def authored_replies
        Replies.find_by_user_id(self.id)
    end
end

class Questions 
    attr_accessor :id, :title, :body, :author_id

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE id = #{id}")
        data.map {|datum| Questions.new(datum)}
    end

    def self.find_by_author_id(author_id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE author_id = #{author_id}")
        data.map {|datum| Questions.new(datum)}
    end

    def initialize(hash)
        @id = hash['id']
        @title = hash['title']
        @body = hash['body']
        @author_id = hash['author_id']
    end

    def author
        Users.find_by_id(self.author_id)
    end

    def replies
        Replies.find_by_question_id(self.id)
    end

end

class Replies
    attr_accessor :id, :body, :questions_id, :parent_reply_id, :author_id

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE id = #{id}")
        data.map {|datum| Replies.new(datum)}
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE author_id = #{user_id}")
        data.map {|datum| Replies.new(datum)}
    end

    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE questions_id = #{question_id}")
        data.map {|datum| Replies.new(datum)}
    end


    def initialize(hash)
        @id = hash['id']
        @body = hash['body']
        @questions_id = hash['questions_id']
        @parent_reply_id = hash['parent_reply_id']
        @author_id = hash['author_id']
    end

    def author
        Users.find_by_id(self.author_id)
    end

    def question
        Questions.find_by_id(self.questions_id)
    end

    def parent_reply
        raise 'no parent reply' if !self.parent_reply_id 
        Replies.find_by_id(self.parent_reply_id)
    end

    def child_replies
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies WHERE parent_reply_id = #{self.id}")
        raise 'no replies' if data.empty?
        data.map {|datum| Replies.new(datum)}
    end

end