DROP TABLE IF EXISTS users;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)   
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    body TEXT,
    questions_id INTEGER NOT NULL,
    parent_reply INTEGER NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY(questions_id) REFERENCES questions(id),
    FOREIGN KEY(parent_reply) REFERENCES replies(id),
    FOREIGN KEY(author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL
)