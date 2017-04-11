DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  reply_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES user(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES question(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('Sam', 'Wang'),
  ('Sean', 'Perfecto');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('Hi', 'Hi Sam', 2),
  ('Yo', 'Yo Sean', 1);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1,2),
  (2,1);

INSERT INTO
  replies(question_id, user_id, body)
VALUES
  (1, 1, 'Replied'),
  (2, 2, 'Also Replied');

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1, 1),
  (2, 2);
