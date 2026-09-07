-- AX 2회차 Ch1 과제: SQL & 데이터베이스 기초
-- 작성자: 채희주
-- 환경: PostgreSQL + DBeaver

-- Part 1. Schema와 Table 만들기
DROP SCHEMA IF EXISTS practice CASCADE;
CREATE SCHEMA practice;

CREATE TABLE practice.members (
    member_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INTEGER,
    joined_at DATE
);

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'practice' AND table_name = 'members'
ORDER BY ordinal_position;

-- Part 2. INSERT와 SELECT
INSERT INTO practice.members (name, email, age, joined_at) VALUES
('김민수', 'minsu@example.com', 24, '2026-08-10'),
('이서연', 'seoyeon@example.com', 29, '2026-07-15'),
('박지훈', 'jihoon@example.com', 35, '2026-09-01'),
('최유진', 'yujin@example.com', 22, '2026-06-20'),
('정하늘', 'haneul@example.com', 27, '2026-08-25'),
('강도윤', 'doyun@example.com', 41, '2026-05-12');

-- 1. 전체 회원 조회
SELECT * FROM practice.members;

-- 2. 이름과 이메일만 조회
SELECT name, email FROM practice.members;

-- 3. 25세 이상 회원 조회
SELECT * FROM practice.members WHERE age >= 25;

-- 4. 특정 이름의 회원 조회
SELECT * FROM practice.members WHERE name = '이서연';

-- 5. 나이가 많은 순서로 조회
SELECT * FROM practice.members ORDER BY age DESC;

-- 6. 가입일 순서로 조회
SELECT * FROM practice.members ORDER BY joined_at;

-- Part 3. UPDATE와 DELETE
-- 수정 전 대상 확인
SELECT * FROM practice.members WHERE email = 'minsu@example.com';

UPDATE practice.members
SET age = 25
WHERE email = 'minsu@example.com';

-- 수정 후 결과 확인
SELECT * FROM practice.members WHERE email = 'minsu@example.com';

-- 삭제 전 대상 확인
SELECT * FROM practice.members WHERE email = 'yujin@example.com';

DELETE FROM practice.members
WHERE email = 'yujin@example.com';

-- 삭제 후 전체 결과 확인
SELECT * FROM practice.members ORDER BY member_id;

-- Part 4. 집계 함수
SELECT COUNT(*) AS total_members FROM practice.members;
SELECT ROUND(AVG(age), 2) AS average_age FROM practice.members;
SELECT MAX(age) AS oldest_age FROM practice.members;
SELECT MIN(age) AS youngest_age FROM practice.members;
SELECT COUNT(*) AS members_age_25_or_more
FROM practice.members
WHERE age >= 25;

-- Part 4 실행 결과 캡처용: 집계 결과를 한 화면에서 확인
SELECT
    COUNT(*) AS total_members,
    ROUND(AVG(age), 2) AS average_age,
    MAX(age) AS oldest_age,
    MIN(age) AS youngest_age,
    COUNT(*) FILTER (WHERE age >= 25) AS members_age_25_or_more
FROM practice.members;

-- 도전 문제 1. 연령대별 회원 수
SELECT (age / 10) * 10 AS age_group, COUNT(*) AS member_count
FROM practice.members
GROUP BY (age / 10) * 10
ORDER BY age_group;

-- 도전 문제 2. 평균 나이보다 나이가 많은 회원
SELECT *
FROM practice.members
WHERE age > (SELECT AVG(age) FROM practice.members)
ORDER BY age DESC;

-- [확인 질문]
-- 1. 각 회원을 겹치지 않게 구분하려면 고유한 값이 필요하기 때문이다.
-- 2. 조건이 없으면 한 명이 아니라 모든 회원 정보가 바뀌거나 삭제될 수 있다.
-- 3. SELECT *는 컬럼을 전부 가져오고, 컬럼명을 쓰면 필요한 값만 가져온다.
-- 4. COUNT()는 개수를 세고 AVG()는 숫자의 평균을 구한다.
-- 5. Python은 불러온 데이터를 코드에서 처리한다. SQL은 DB에 조건을 보내서
--    저장된 데이터 중 필요한 결과를 DB에서 조회한다.
