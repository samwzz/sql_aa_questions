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
  ('Sean', 'Perfecto'),
  ('Donald', 'Duck'),
  ('Barack', 'Obama');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('Life', 'What is the answer to life?', 1),
  ('Death', 'What is after death?', 2),
  ('Help', 'Where is Mickey? I cannot find him.', 3),
  ('Vacation', 'Where is the best place to vacation?', 4);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1,2),
  (2,1),
  (1,3),
  (4,1),
  (3,4);

INSERT INTO
  replies(question_id, user_id, body, reply_id)
VALUES
  (1, 3, 'I am duck. Why would I know', NULL),
  (1, 1, 'I like ducks, mmm tasty.', 1),
  (2, 4, 'America', NULL),
  (2, 2, 'So you saying I am dead already Barack?', 3),
  (3, 1, 'Mickey is in Disneyland ya dumb duck', NULL),
  (4, 3, 'Quack', NULL);

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 2),
  (4, 2),
  (1, 2),
  (3, 4);
