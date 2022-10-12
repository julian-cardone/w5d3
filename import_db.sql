PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)   
);


CREATE TABLE question_follows(
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL
);


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


CREATE TABLE question_likes(
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL
);

INSERT INTO
    users(fname, lname)
VALUES
    ('Julian', 'Cardona'),
    ('Justin', 'Kilburn'),
    ('Kyle', 'G');

INSERT INTO
    questions(title, body, author_id)
VALUES
    ('Bathroom?', 'Where is the bathroom?', (SELECT id FROM users WHERE fname = 'Justin' AND lname = 'Kilburn')),
    ('Lunch?', 'Is it lunch time yet?', (SELECT id FROM users WHERE fname = 'Julian' AND lname = 'Cardona'));

INSERT INTO
    replies(body, questions_id, parent_reply, author_id)
VALUES
    ('anywhere you''d like', 
    (SELECT id FROM questions WHERE title = 'Bathroom?'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Julian' AND lname = 'Cardona')),

    ('Dude, so close', 
    (SELECT id FROM questions WHERE title = 'Lunch?'),
    NULL,
    (SELECT id FROM users WHERE fname = 'Justin' AND lname = 'Kilburn')),

    ('that being said, no.',
    (SELECT id FROM questions WHERE title = 'Bathroom?'),
    (SELECT id FROM replies WHERE author_id = (SELECT id FROM users WHERE fname = 'Julian' AND lname = 'Cardona')),
    (SELECT id FROM users WHERE fname = 'Kyle' AND lname = 'G'));