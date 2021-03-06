
-- SCOTT 계정으로 생성함 
-- 시퀀스 생성
-- 100부터 1씩 증가 
CREATE SEQUENCE SEQ_IDX
    START WITH 100
    INCREMENT BY 1
    NOCYCLE
    NOCACHE;
    
DROP SEQUENCE IDX;

DROP TABLE MEMBER;
    
-- MEMBER 테이블 생성
CREATE TABLE MEMBER(
    IDX NUMBER PRIMARY KEY,
    MEMBER_ID VARCHAR2(10) NOT NULL,
    MEMBER_PWD VARCHAR2(10) NOT NULL,
    MEMBER_NAME VARCHAR2(20) NOT NULL,
    EMAIL VARCHAR2(30),
    ADDRESS VARCHAR2(100),
    PHONE VARCHAR2(11),
    ENROLL_DATE DATE
);

SELECT *
FROM MEMBER;

INSERT INTO MEMBER VALUES(SEQ_IDX.NEXTVAL, 'test1234', '1234', '김하나', 'hana@naver.com', '서울시 서초구', '01054547878', SYSDATE);
INSERT INTO MEMBER VALUES(SEQ_IDX.NEXTVAL, 'dudu99', '9876', '최둘둘', '22ck@naver.com', '서울시 용산구', '01012341234', SYSDATE);



-- ㄱㅔ시판 
CREATE SEQUENCE SEQUENCE_IDX
    START WITH 1
    INCREMENT BY 1
    NOCYCLE
    NOCACHE;
    
DROP SEQUENCE SEQUENCE_IDX;
    
CREATE TABLE BOARD(
    IDX NUMBER PRIMARY KEY,
    DIV VARCHAR2(10) CHECK(DIV IN('공지', '일반', '비밀')),
    TITLE VARCHAR2(50) NOT NULL,
    CONTENTS VARCHAR2(3000) NOT NULL,
    CONSTRAINT WRITER_NUMBER FOREIGN KEY(IDX) REFERENCES MEMBER(IDX),
    WRITE_DATE DATE DEFAULT SYSDATE
);

SELECT *
FROM BOARD;
