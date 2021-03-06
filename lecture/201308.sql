
-- Final_Workshop

-- 품 1. 3. 4. 5. 6. 7. 8. 11. 12. 13. 14. 15. 16. 17. 18. 
-- 못품 9.-> 18 ( 품 ) 
-- 확인 필요  2. 10. ( 확인 완료 )


-- 테이블 
-- TB_BOOK, TB_WRITER, TB_PUBLISHER, TB_BOOK_AUTHOR


-- 1
-- 4개의 테이블에 포함된 데이터 건 수 를 구하는 SQL구문 
SELECT COUNT(*)
FROM TB_BOOK;

SELECT COUNT(*)
FROM TB_WRITER;

SELECT COUNT(*)
FROM TB_PUBLISHER;

SELECT COUNT(*)
FROM TB_BOOK_AUTHOR;


SELECT *
FROM TB_BOOK; -- 1738개의 행 

SELECT *
FROM TB_WRITER; --1052개의 행 

SELECT *
FROM TB_PUBLISHER; -- 11개의 행

SELECT *
FROM TB_BOOK_AUTHOR; -- 2292개의 행 


-- 2
DESC TB_BOOK;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TB_BOOK';

SELECT *
-- TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_DEFAULT, NULLABLE, CONSTRAINT_NAME, CONSTRAINT_TYPE, R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
    JOIN USER_CONS_COLUMNS USING(CONSTRAINT_NAME);

SELECT *
FROM COL
WHERE TNAME = 'TB_BOOK'; -- 아마도 이렇게 ? 

-- 모범 답안
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_DEFAULT, NULLABLE, CONSTRAINT_NAME, CONSTRAINT_TYPE, R_CONSTRAINT_NAME
FROM   USER_TAB_COLS 
LEFT JOIN   (SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE, R_CONSTRAINT_NAME
              FROM   USER_CONS_COLUMNS
				      JOIN   USER_CONSTRAINTS USING  (TABLE_NAME, CONSTRAINT_NAME)
				      WHERE  TABLE_NAME IN ('TB_BOOK', 'TB_BOOK_AUTHOR','TB_PUBLISHER','TB_WRITER')) V USING (TABLE_NAME, COLUMN_NAME) 
WHERE  TABLE_NAME IN ('TB_BOOK', 'TB_BOOK_AUTHOR', 'TB_PUBLISHER', 'TB_WRITER')
ORDER BY 1, 2;




-- 3
-- 도서명이 25자 이상인 책 번호와 도서명을 출력
SELECT BOOK_NO, BOOK_NM
FROM TB_BOOK
WHERE LENGTH(BOOK_NM) >= 25;




-- 4 
-- 휴대폰 번호가 '019'로 시작하는 김씨 성을 가진 작가를 이름순으로 정렬 했을 때, 
-- 가장 먼저 표시되는 작가의 이름과, 사무실 전화번호, 집 전화번호, 휴대폰 전화번호 표시
SELECT WRITER_NM, OFFICE_TELNO, HOME_TELNO, MOBILE_NO
FROM TB_WRITER
WHERE SUBSTR(MOBILE_NO, 1, 3) = '019' 
    AND WRITER_NM LIKE '김%'
ORDER BY 1;


SELECT I.*
FROM (
    SELECT WRITER_NM, OFFICE_TELNO, HOME_TELNO, MOBILE_NO
    FROM TB_WRITER
    WHERE SUBSTR(MOBILE_NO, 1, 3) = '019' 
        AND WRITER_NM LIKE '김%'
    ORDER BY 1
) I
WHERE ROWNUM = 1;




-- 5
-- 저작 형태가 '옮김'에 해당하는 작가들이 총 몇명인지 계산하는 구문
-- 결과 헤더는 작가(명)으로 표시되도록

SELECT *
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE = '옮김';


SELECT COUNT(*) AS "작가(명)"
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE = '옮김';



-- 6 
-- 300권 이상 등록된 도서의 저작 형태 및 등록된 도서 수량을 표시하는 구문
-- 저작 형태가 등록되지 않은 경우는 제외 
SELECT *
FROM TB_BOOK_AUTHOR;

SELECT COMPOSE_TYPE, COUNT(*)
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IS NOT NULL
GROUP BY COMPOSE_TYPE
HAVING COUNT(*) >= 300;




-- 7
-- 가장 최근에 발간된 최신작 이름과 발행일자, 출판사 이름을 표시하는 SQL 구문을 작성하시오
SELECT BOOK_NM, ISSUE_DATE, PUBLISHER_NM
FROM TB_BOOK
ORDER BY 2 DESC;

SELECT *
FROM (
    SELECT BOOK_NM, ISSUE_DATE, PUBLISHER_NM
    FROM TB_BOOK
    ORDER BY 2 DESC
)
WHERE ROWNUM = 1;



-- 8
-- 가장 많은 책을 쓴 작가 3명의 이름과 수량을 표시하되, 많이 쓴 순서대로 표시하는 SQL 구문을 작성하시오.
-- 단, 동명이인(同名異人) 작가는 없다고 가정한다. (결과 헤더는 “작가 이름”, “권 수”로 표시되도록 할 것)
SELECT *
FROM TB_WRITER;

SELECT *
FROM TB_BOOK_AUTHOR
ORDER BY 2;

SELECT WRITER_NO, WRITER_NM, BOOK_NO
FROM TB_WRITER
    JOIN TB_BOOK_AUTHOR USING(WRITER_NO);

SELECT WRITER_NO, COUNT(*)
FROM TB_WRITER
    JOIN TB_BOOK_AUTHOR USING(WRITER_NO)
GROUP BY WRITER_NO
ORDER BY COUNT(*) DESC;

SELECT WRITER_NM, COUNT(*)
FROM TB_WRITER
    JOIN TB_BOOK_AUTHOR USING(WRITER_NO)
GROUP BY WRITER_NM
ORDER BY COUNT(*) DESC;



-- 푼 부분
SELECT *
FROM (
    SELECT WRITER_NM AS 작가이름, COUNT(*) AS 권수
    FROM TB_WRITER
        JOIN TB_BOOK_AUTHOR USING(WRITER_NO)
    GROUP BY WRITER_NM
    ORDER BY COUNT(*) DESC
)
WHERE ROWNUM IN ( 1, 2, 3);




-- 9
-- 작가 정보 테이블의 모든 등록일자 항목이 누락되어 있는 걸 발견하였다. 
-- 누락된 등록일자 값을 각 작가의 ‘최초 출판도서의 발행일과 동일한 날짜’로 변경시키는 SQL 구문을 작성하시오. 
-- (COMMIT 처리할 것)
SELECT *
FROM TB_BOOK;

SELECT *
FROM TB_WRITER; -- 1052개 

SELECT *
FROM TB_BOOK_AUTHOR
ORDER BY WRITER_NO, BOOK_NO;


-- 작가의 ‘최초 출판도서의 발행일'                     
SELECT WRITER_NO, BOOK_NO
FROM TB_BOOK_AUTHOR 
WHERE BOOK_NO = ( SELECT MIN(BOOK_NO) FROM TB_BOOK_AUTHOR WHERE WRITER_NO = '1')
GROUP BY WRITER_NO, BOOK_NO
ORDER BY 2;

-- 이렇게 찾을 수 있다 
SELECT WRITER_NO, BOOK_NO
FROM TB_BOOK_AUTHOR 
WHERE BOOK_NO IN ( SELECT MIN(BOOK_NO) FROM TB_BOOK_AUTHOR GROUP BY WRITER_NO )
GROUP BY WRITER_NO, BOOK_NO
ORDER BY TO_NUMBER(WRITER_NO);


--  SH가 쓴 코드 
SELECT WRITER_NO, MIN(ISSUE_DATE)
FROM TB_BOOK_AUTHOR
    JOIN TB_BOOK USING (BOOK_NO)
GROUP BY WRITER_NO;

SELECT WRITER_NO, ISSUE_DATE
FROM TB_BOOK_AUTHOR
    JOIN TB_BOOK USING (BOOK_NO)
WHERE WRITER_NO = '1'
ORDER BY ISSUE_DATE;

SELECT BOOK_NM,BOOK_NO
FROM TB_BOOK;

-- ISSUE_DATE로 다시 해보자
-- 작가의 ‘최초 출판도서의 발행일' 
SELECT WRITER_NO, ISSUE_DATE
FROM TB_BOOK_AUTHOR
    JOIN TB_BOOK USING(BOOK_NO)
ORDER BY 1, 2;

SELECT WRITER_NO, MIN(ISSUE_DATE)
FROM TB_BOOK_AUTHOR
    JOIN TB_BOOK USING(BOOK_NO)
GROUP BY WRITER_NO
ORDER BY WRITER_NO;

UPDATE TB_WRITER W-- 이 테이블의 작가인덱스로 그 작가의 출판도서 발행일과 하나하나 비교 
SET REGIST_DATE = ( SELECT MIN(ISSUE_DATE)
                    FROM TB_BOOK_AUTHOR A
                        JOIN TB_BOOK B ON A.BOOK_NO = B.BOOK_NO
                    WHERE W.WRITER_NO = A.WRITER_NO
                    GROUP BY WRITER_NO
                    ORDER BY WRITER_NO );
                    
-- JOIN이 아니라 서브쿼리로 (상관서브쿼리)
-- 왜 안되는가 싶어서 JOIN 순서를 바꿔봤다. 
UPDATE TB_WRITER W-- 이 테이블의 작가인덱스로 그 작가의 출판도서 발행일과 하나하나 비교 
SET REGIST_DATE = ( SELECT MIN(ISSUE_DATE)
                    FROM TB_BOOK B
                        JOIN TB_BOOK_AUTHOR A ON A.BOOK_NO = B.BOOK_NO
                    WHERE W.WRITER_NO = A.WRITER_NO
                    GROUP BY WRITER_NO );
                    
-- 서브쿼리안에 ORDER BY 절을 쓸 필요도 없으며, ORDER BY가 있으니까 에러가 난다. 

ROLLBACK;

COMMIT;

SELECT *
FROM TB_WRITER;


-- 10 
-- 현재 도서저자 정보 테이블은 저서와 번역서를 구분 없이 관리하고 있다. 
-- 앞으로는 번역서는 따로 관리하려고 한다. 
-- 제시된 내용에 맞게 “TB_BOOK_TRANSLATOR” 테이블을 생성하는 SQL 구문을 작성하시오. 
-- (Primary Key 제약 조건 이름은 “PK_BOOK_TRANSLATOR”로 하고, Reference 제약 조건 이름은 “FK_BOOK_TRANSLATOR_01”, “FK_BOOK_TRANSLATOR_02”로 할 것)
CREATE TABLE TB_BOOK_TRANSLATOR(

    BOOK_NO VARCHAR2(10) NOT NULL, 
    WRITER_NO VARCHAR2(10) NOT NULL,
    TRANS_LANG VARCHAR2(60),
    -- 테이블레벨에서 
    CONSTRAINT PK_BOOK_TRANSLATOR PRIMARY KEY(BOOK_NO, WRITER_NO),
    CONSTRAINT FK_BOOK_TRANSLATOR_01 FOREIGN KEY(BOOK_NO) REFERENCES TB_BOOK(BOOK_NO),
    CONSTRAINT FK_BOOK_TRANSLATOR_02 FOREIGN KEY(WRITER_NO) REFERENCES TB_WRITER(WRITER_NO)
);
-- 컬럼에 속성 추가 어떻게 해야되는지? 
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.BOOK_NO IS '도서 번호';
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.WRITER_NO IS '작가 번호';
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.TRANS_LANG IS '번역 언어';


SELECT *
FROM TB_BOOK_TRANSLATOR;

DROP TABLE TB_BOOK_TRANSLATOR;


-- 11 
-- 도서 저작 형태(compose_type)가 '옮김', '역주', '편역', '공역'에 해당하는 데이터는 
-- 도서 저자 정보 테이블에서 도서 역자 정보 테이블(TB_BOOK_TRANSLATOR)로 옮기는 SQL 구문을 작성하시오. 
-- 단, “TRANS_LANG” 컬럼은 NULL 상태로 두도록 한다. 
-- (이동된 데이터는 더 이상 TB_BOOK_AUTHOR 테이블에 남아 있지 않도록 삭제할 것)
SELECT *
FROM TB_BOOK_AUTHOR;

SELECT COUNT(*)
FROM TB_BOOK_AUTHOR
WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역'); -- 169 

INSERT INTO TB_BOOK_TRANSLATOR(BOOK_NO, WRITER_NO)(SELECT BOOK_NO, WRITER_NO
                                                    FROM TB_BOOK_AUTHOR
                                                    WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역'));
SELECT *
FROM TB_BOOK_TRANSLATOR;

DELETE FROM TB_BOOK_AUTHOR WHERE COMPOSE_TYPE IN ('옮김', '역주', '편역', '공역');

ROLLBACK;

SELECT *
FROM TB_BOOK_TRANSLATOR;


-- 12 
-- 2007년도에 출판된 번역서 이름과 번역자(역자)를 표시하는 SQL 구문을 작성하시오.
SELECT BOOK_NM, WRITER_NM
FROM TB_BOOK
    JOIN TB_BOOK_TRANSLATOR USING(BOOK_NO)
    JOIN TB_WRITER USING(WRITER_NO)
WHERE EXTRACT(YEAR FROM ISSUE_DATE) = 2007;


-- 13
-- 12번 결과를 활용하여 대상 번역서들의 출판일을 변경할 수 없도록 하는 뷰를 생성하는 SQL 구문을 작성하시오. 
-- (뷰 이름은 “VW_BOOK_TRANSLATOR”로 하고 도서명, 번역자, 출판일이 표시되도록 할 것)

-- 특정 컬럼 ( WHERE절에 쓰는 컬럼의 데이터를 변경할 수 없도록 하는거니까 WITH READ ONLY가 아니라 WITH CHECK OPTION
CREATE OR REPLACE VIEW VW_BOOK_TRANSLATOR
AS 
SELECT BOOK_NM, WRITER_NM, ISSUE_DATE
FROM TB_BOOK
    JOIN TB_BOOK_TRANSLATOR USING(BOOK_NO)
    JOIN TB_WRITER USING(WRITER_NO)
WITH READ ONLY;

SELECT *
FROM VW_BOOK_TRANSLATOR;

-- 모범 답안
CREATE OR REPLACE VIEW VW_BOOK_TRANSLATOR AS
SELECT BOOK_NM, 
       WRITER_NM 
FROM   TB_WRITER
JOIN   TB_BOOK_TRANSLATOR USING  (WRITER_NO)
JOIN   TB_BOOK USING  (BOOK_NO)
WHERE  TO_CHAR(ISSUE_DATE, 'RRRR') = '2007'
WITH CHECK OPTION; 




-- 14
-- 새로운 출판사(춘 출판사)와 거래 계약을 맺게 되었다. 
-- 제시된 다음 정보를 입력하는 SQL 구문을 작성하시오.(COMMIT 처리할 것)
SELECT *
FROM TB_PUBLISHER;

INSERT INTO TB_PUBLISHER VALUES('춘 출판사', '02-6710-3737', DEFAULT);


-- 15
--동명이인(同名異人) 작가의 이름을 찾으려고 한다. 이름과 동명이인 숫자를 표시하는 SQL 구문을 작성하시오.
SELECT SUBSTR(WRITER_NM, 1, 3), COUNT(*)
FROM TB_WRITER
WHERE LENGTH(WRITER_NM) IN (3, 8)
GROUP BY SUBSTR(WRITER_NM, 1, 3)
HAVING COUNT(*) > 1
ORDER BY 1;

-- 한자까지 비교해서 동일한 사람 추출 
SELECT WRITER_NM, COUNT(*)
FROM TB_WRITER
GROUP BY WRITER_NM
HAVING COUNT(*) > 1
ORDER BY 1;



-- 16
-- 도서의 저자 정보 중 저작 형태(compose_type)가 누락된 데이터들이 적지 않게 존재한다. 
-- 해당 컬럼이 NULL인 경우 '지음'으로 변경하는 SQL 구문을 작성하시오.(COMMIT 처리할 것)

SELECT *
FROM TB_BOOK_AUTHOR;

UPDATE TB_BOOK_AUTHOR
SET COMPOSE_TYPE = '지음'
WHERE COMPOSE_TYPE IS NULL;

ROLLBACK;



-- 17 
-- 서울지역 작가 모임을 개최하려고 한다. 
-- 사무실이 서울이고, 사무실 전화 번호 국번(가운데자리)이 3자리인 작가의 이름과 사무실 전화 번호를 표시하는 SQL 구문을 작성하시오.
SELECT WRITER_NM, OFFICE_TELNO
FROM TB_WRITER
WHERE SUBSTR(OFFICE_TELNO, 1, 2) = '02' 
    AND SUBSTR(OFFICE_TELNO, 4, 4) LIKE '___-';

SELECT *
FROM TB_WRITER;

-- 모범 답안
SELECT WRITER_NM, 
        OFFICE_TELNO
FROM   TB_WRITER
WHERE  OFFICE_TELNO LIKE '02%'
AND    OFFICE_TELNO LIKE '02-___-%'
ORDER BY 1; 


-- 18
-- 2006년 1월 기준으로 등록된 지 31년 이상 된 작가 이름을 이름순으로 표시하는 SQL 구문을 작성하시오.
SELECT WRITER_NM
FROM TB_WRITER
WHERE EXTRACT(YEAR FROM TO_DATE('2006/01', 'YYYY/MM')) - EXTRACT(YEAR FROM REGIST_DATE) >= 31
ORDER BY WRITER_NM;

SELECT *
FROM TB_WRITER;

SELECT EXTRACT(YEAR FROM TO_DATE('2006/01', 'YYYY/MM')) - EXTRACT(YEAR FROM REGIST_DATE)
FROM TB_WRITER
WHERE EXTRACT(YEAR FROM TO_DATE('2006/01', 'YYYY/MM')) - EXTRACT(YEAR FROM REGIST_DATE) >= 31;

-- 모범 답안
SELECT WRITER_NM
FROM   TB_WRITER
WHERE  MONTHS_BETWEEN(TO_DATE('20060101','YYYYMMDD'), REGIST_DATE) >= 372
ORDER BY 1;
-- 이럴 경우  만 30년이 아님
--WHERE  TO_CHAR(SYSDATE,'yyyy') - TO_CHAR(ISSUE_DATE,'yyyy') >= 30




-- 19
-- 요즘 들어 다시금 인기를 얻고 있는 '황금가지' 출판사를 위한 기획전을 열려고 한다. 
-- '황금가지' 출판사에서 발행한 도서 중 재고 수량이 10권 미만인 도서명과 가격, 재고상태를 표시하는 SQL 구문을 작성하시오. 
--  재고 수량이 5권 미만인 도서는 ‘추가주문필요’로, 나머지는 ‘소량보유’로 표시하고, 재고수량이 많은 순, 도서명 순으로 표시되도록 한다.
SELECT BOOK_NM,    
       PRICE, 
       CASE
            WHEN STOCK_QTY < 5 
            THEN '추가주문필요'
            ELSE '소량보유'
        END
FROM TB_BOOK
WHERE PUBLISHER_NM = '황금가지' 
    AND STOCK_QTY < 10
ORDER BY STOCK_QTY DESC, BOOK_NM ASC;



-- 20
-- '아타트롤' 도서 작가와 역자를 표시하는 SQL 구문을 작성하시오. (결과 헤더는 ‘도서명’,’저자’,’역자’로 표시할 것)
SELECT BOOK_NM, WRITER_NM, ;

SELECT *
FROM TB_BOOK
    JOIN TB_BOOK_AUTHOR USING(BOOK_NO)
    JOIN TB_WRITER USING(WRITER_NO)
WHERE BOOK_NM = '아타트롤';

SELECT *
FROM TB_WRITER
WHERE WRITER_NM = '윤도숭';



-- 21
-- 현재 기준으로 최초 발행일로부터 만 30년이 경과되고, 
-- 재고 수량이 90권 이상인 도서에 대해 도서명, 재고 수량, 원래 가격, 20% 인하 가격을 표시하는 SQL 구문을 작성하시오. 
-- (결과 헤더는 “도서명”, “재고 수량”, “가격(Org)”, “가격(New)”로 표시할 것. 
-- 재고 수량이 많은 순, 할인 가격이 높은 순, 도서명 순으로 표시되도록 할 것)
SELECT BOOK_NM AS  "도서명", STOCK_QTY AS "재고 수량", PRICE AS "가격(Org)", PRICE*0.8 AS "가격(New)"
FROM TB_BOOK
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM ISSUE_DATE)  >= 31 
    AND STOCK_QTY >= 90
ORDER BY STOCK_QTY DESC, PRICE*0.8 DESC, BOOK_NM;



SELECT EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM ISSUE_DATE) 
FROM TB_BOOK;

SELECT *
FROM TB_BOOK;







