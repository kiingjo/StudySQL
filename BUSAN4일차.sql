/*
회원정보 중에 구매내역이 있는 회원에 대한 회원아이디, 회원이름, 생일(0000-00-00)조회
정렬은 생일 기준 오름차순 
*/

SELECT MEM_ID 회원아이디,
       MEM_NAME 회원이름,
       TO_CHAR(MEM_BIR,'YYYY-MM-DD') 생일
        FROM MEMBER
            WHERE MEM_ID IN (SELECT DISTINCT CART_MEMBER
                                    FROM CART)
        ORDER BY MEM_BIR ASC;
        
/*
--많이 사용하는 함수
TO_CHAR 형식부여
|| PASTE같이 연결하는 함수
*/

SELECT PROD_ID, PROD_NAME, PROD_LGU
    FROM PROD
        WHERE PROD_LGU IN(SELECT LPROD_GU
                            FROM LPROD
                                WHERE LPROD_NM='피혁잡화');
                                
SELECT PROD_ID, PROD_NAME, PROD_LGU
    FROM PROD
        WHERE EXISTS (SELECT LPROD_GU
                            FROM LPROD
                                WHERE LPROD_GU = PROD.PROD_LGU
                                AND LPROD_GU='P301');
                                
                    SELECT COUNT(*) FROM PROD;
---------------------------조인----------------------------------------------
------------CROSS 조인

--[일반방식]
SELECT M.MEM_ID,
       C.CART_MEMBER,
       P.PROD_ID
    FROM MEMBER M,CART C,PROD P,LPROD L,BUYER B;
    
SELECT TO_CHAR(COUNT(*),'999,999,999')
    FROM MEMBER M,CART C,PROD P,LPROD L,BUYER B;


--[국제표준방식]

SELECT *
FROM MEMBER CROSS JOIN CART
            CROSS JOIN PROD
            CROSS JOIN LPROD
            CROSS JOIN BUYER;


--------INNER JOIN(EQUAL JOIN)
--[일반방식]
SELECT P.PROD_ID 상품코드,
       P.PROD_NAME 상품명,
       L.LPROD_NM 상품분류코드
    FROM PROD P, LPROD L
        WHERE P.PROD_LGU = L.LPROD_GU;
        
SELECT P.PROD_ID,
       P.PROD_NAME,
       L.LPROD_NM,
       B.BUYER_NAME
    FROM PROD P, LPROD L, BUYER B
        WHERE P.PROD_LGU=L.LPROD_GU
        AND   P.PROD_BUYER=B.BUYER_ID;


--[국제방식]
SELECT PROD.PROD_ID 상품코드,
       PROD.PROD_NAME 상품명,
       L.LPROD_NM 상품분류코드
    FROM  PROD P, LPROD L
        WHERE P.PROD_LGU = L.LPROD_GU;
        
SELECT P.PROD_ID,
       P.PROD_NAME,
       L.LPROD_NM,
       B.BUYER_NAME
    FROM PROD P INNER JOIN LPROD L 
            ON(P.PROD_LGU=L.LPROD_GU) 
                
                INNER JOIN BUYER B
            ON(P.PROD_BUYER=B.BUYER_ID);
            
/*

회원이 구매한 거래처 정보를 조회하려고 합니다.
회원아이디, 회원이름, 상품거래처명, 상품분류명 조회
*/


--[일반형식]
SELECT M.MEM_ID 회원ID,
       M.MEM_NAME 회원이름,
       B.BUYER_NAME 상품거래처명,
       L.LPROD_NM 상품분류명
FROM MEMBER M, CART C, BUYER B, PROD P, LPROD L
    WHERE M.MEM_ID=C.CART_MEMBER  --MEMBER 테이블이 최상위 부모테이블이다 FK가 없다
    AND   C.CART_PROD=P.PROD_ID
    AND   P.PROD_LGU=L.LPROD_GU
    AND   P.PROD_BUYER=B.BUYER_ID;
    
    
    
    
---[국제표준]           
SELECT M.MEM_ID 회원ID,
       M.MEM_NAME 회원이름,
       B.BUYER_NAME 상품거래처명,
       L.LPROD_NM 상품분류명
FROM MEMBER M INNER JOIN CART C 
        ON (M.MEM_ID=C.CART_MEMBER)   
            INNER JOIN PROD P
        ON (C.CART_PROD=P.PROD_ID ) 
            INNER JOIN LPROD L
        ON (P.PROD_LGU=L.LPROD_GU)
            INNER JOIN BUYER B        --이전에 PROD를 연결했기 때문에 또 써도 상관없다
        ON (P.PROD_BUYER=B.BUYER_ID);
        
        
----------------------------------------문제
/*
거래처가 '삼성전자'인 자료에 대한 
상품코드, 상품명, 거래처명을 조회하려고 한다.
*/

--일반방식
SELECT P.PROD_ID 상품코드,
       P.PROD_NAME 상품명,
       B.BUYER_NAME 거래처명
FROM PROD P, BUYER B
    WHERE P.PROD_BUYER=B.BUYER_ID  -- INNER JOIN 조건도  WHERE에 두개 달아준다.
    AND B.BUYER_NAME='삼성전자';

--국제방식     
SELECT P.PROD_ID 상품코드,
       P.PROD_NAME 상품명,
       B.BUYER_NAME 거래처명
FROM PROD P INNER JOIN BUYER B
        ON P.PROD_BUYER=B.BUYER_ID -- ON해서 묶고 아래에 조건 WHERE 단다.
            AND B.BUYER_NAME='삼성전자';
    --WHERE B.BUYER_NAME='삼성전자' 가능

------------------문제
/*
상품테이블에서 상품코드, 상품명, 분류명, 거래처명, 거래처주소 조회
*/

--일반
SELECT P.PROD_ID 상품코드,
       P.PROD_NAME 상품명,
       L.LPROD_NM 분류명,
       B.BUYER_NAME 거래처명,
       B.BUYER_ADD1 ||' '|| B.BUYER_ADD2 거래처주소
FROM PROD P, LPROD L, BUYER B
    WHERE P.PROD_LGU=L.LPROD_GU
    AND   P.PROD_BUYER=B.BUYER_ID
    AND PROD_SALE<=100000
    AND SUBSTR(BUYER_ADD1,1,2)='부산';
    
--국제
SELECT P.PROD_ID 상품코드,
       P.PROD_NAME 상품명,
       L.LPROD_NM 분류명,
       B.BUYER_NAME 거래처명,
       B.BUYER_ADD1 ||' '|| B.BUYER_ADD2 거래처주소
FROM PROD P INNER JOIN LPROD L
    ON P.PROD_LGU=L.LPROD_GU
            INNER JOIN BUYER B
    ON P.PROD_BUYER=B.BUYER_ID
     AND PROD_SALE<=100000
    AND SUBSTR(BUYER_ADD1,1,2)='부산';


/*
문제 
상품분류코드가 P101인 것에 대한
상품분류명, 상품아이디, 판매가, 거래처담당자, 회원아이디, 주문수량 조회
단, 상품분류명을 기준 내림차순, 상품아이디를 기준 오름차순
*/
--일반
SELECT L.LPROD_NM 상품분류명,
       P.PROD_ID 상품아이디,
       P.PROD_SALE 판매가,
       B.BUYER_CHARGER 거래처담당자,
       M.MEM_ID 회원아이디,
       C.CART_QTY 주문수량
FROM MEMBER M, PROD P, BUYER B, CART C, LPROD L
    WHERE M.MEM_ID=C.CART_MEMBER
    AND   C.CART_PROD=P.PROD_ID
    AND   P.PROD_LGU=L.LPROD_GU
    AND   P.PROD_BUYER=B.BUYER_ID
    AND P.PROD_LGU='P101'
        ORDER BY P.PROD_LGU DESC, P.PROD_ID  ASC;
        
--국제
SELECT L.LPROD_NM 상품분류명,
       P.PROD_ID 상품아이디,
       P.PROD_SALE 판매가,
       B.BUYER_CHARGER 거래처담당자,
       M.MEM_ID 회원아이디,
       C.CART_QTY 주문수량
FROM MEMBER M INNER JOIN CART C
        ON M.MEM_ID=C.CART_MEMBER
              INNER JOIN PROD P
        ON C.CART_PROD=P.PROD_ID
              INNER JOIN LPROD L
        ON P.PROD_LGU=L.LPROD_GU
              INNER JOIN BUYER B
        ON P.PROD_BUYER=B.BUYER_ID
            
        AND P.PROD_LGU='P101'
            ORDER BY P.PROD_LGU DESC, P.PROD_ID  ASC;
            
            
-------------------------------------문제 풀어보기
/*
1. 오철희가 산 물건 중 TV 가 고장나서 교환받으려고 한다
교환받으려면 거래처 전화번호를 이용해야 한다.
구매처와 전화번호를 조회하시오.
*/

SELECT buyer_name,
       buyer_comtel
        FROM buyer
            WHERE buyer_id IN (SELECT prod_buyer FROM prod
                                    WHERE prod_id IN (SELECT cart_prod FROM cart
                                                            WHERE cart_member IN (SELECT mem_id FROM member 
                                                                        WHERE mem_name = '오철희'))
                                    AND prod_name LIKE '%TV%' );
--JOIN으로                                  
SELECT BUYER_NAME,
       BUYER_COMTEL
        FROM MEMBER M, CART C, PROD P, BUYER B
            WHERE M.MEM_ID= C.CART_MEMBER
            AND   P.PROD_ID=C.CART_PROD
            AND   P.PROD_BUYER=B.BUYER_ID
            AND MEM_NAME='오철희'
            AND PROD_NAME LIKE '%TV%';

/*       
 2. 대전에 사는 73년이후에 태어난 주부들중 2005년4월에 구매한 물품을 조회하고, 
그상품을 거래하는 각거래처의 계좌 은행명과 계좌번호를 뽑으시오.
(단, 은행명-계좌번호).*/      
*/  
SELECT BUYER_BANK,
       BUYER_BANKNO
        FROM BUYER
            WHERE BUYER_ID IN (SELECT PROD_BUYER FROM PROD
                                    WHERE PROD_ID IN (SELECT CART_PROD FROM CART
                                                        WHERE CART_NO LIKE '200504%'
                                                        AND CART_MEMBER IN (SELECT MEM_ID FROM MEMBER
                                                                                     WHERE SUBSTR(MEM_ADD1,1,2)='대전'
                                                                                        AND SUBSTR(MEM_BIR,1,2)>= 73 )
                                                                                        )
                                                                                        );
SELECT BUYER_BANK,
       BUYER_BANKNO,
       CART_NO,
       MEM_ADD1,
       MEM_BIR
        FROM MEMBER M, CART C, PROD P, BUYER B
           WHERE M.MEM_ID= C.CART_MEMBER
           AND SUBSTR(MEM_ADD1,1,2)='대전'
            AND SUBSTR(MEM_BIR,1,2)>= 73
            AND   CART_NO LIKE '200504%'
            AND   P.PROD_ID=C.CART_PROD
            AND   P.PROD_BUYER=B.BUYER_ID;
            
            
                                                                                        
/*
3. 물건을 구매한 회원들 중 5개이상 구매한 회원과 4개이하로 구매한 회원에게 쿠폰을 할인율이 다른 쿠폰을 발행할 예정이다. 
회원들을 구매갯수에 따라  오름차순으로 정렬하고  회원들의 회원id와 전화번호(HP)를 조회하라.
*/

SELECT MEM_ID,
       MEM_HP,
       ( SELECT SUM(CART_QTY) AS TMP
              FROM CART
              WHERE CART_MEMBER = member.mem_id) as TMP2
       FROM MEMBER 
       order by TMP2 ASC ;
            


 /*

[1문제]

주민등록상 1월생인 회원이 지금까지 구매한 상품의 상품분류 중  
뒤 두글자가 01이면 판매가를 10%인하하고
02면 판매가를 5%인상 나머지는 동일 판매가로 도출
(변경판매가의 범위는 500,000~1,000,000원 사이로 내림차순으로 도출하시오. (원화표기 및 천단위구분))
(Alias 상품분류, 판매가, 변경판매가)
*/
SELECT PROD_LGU 상품분류코드,
       PROD_SALE 판매가,
       TO_CHAR(DECODE(SUBSTR(PROD_LGU,3,2),'01',PROD_SALE*0.9,
                                           '02',PROD_SALE*1.05, PROD_SALE),'L999,999,999') AS 변경판매가
    FROM PROD 
    WHERE DECODE(SUBSTR(PROD_LGU,3,2),'01',PROD_SALE*0.9,
                                           '02',PROD_SALE*1.05, PROD_SALE) BETWEEN 500000 AND 1000000
    AND PROD_ID IN (SELECT CART_PROD FROM CART
                        WHERE CART_MEMBER IN (SELECT MEM_ID FROM MEMBER
                                                WHERE to_char(mem_bir, 'mm') = '01')
                                                )
                                                ;
                                                

/*
[2문제]

회원중 1975년생이고 대전 주소의 회원이 구매했던 모든상품 중에 
판매가가 판매가의 전체평균보다 높은 제품만 검색해보세요.
단  
1. 판매가를 기준으로 내림차순하고, 판매가는 천단위 구분표시
2. 상품중 삼성이 들어간 제품만 필터 
3. 상품색상중 NULL값은 '검정'으로 처리
4. 색깔별 갯수는 1이상일 것만 조회
*/

SELECT *
    FROM PROD
        WHERE PROD_SALE >= (SELECT AVG(PROD_SALE) FROM PROD)
        AND PROD_ID IN (SELECT CART_PROD FROM CART
                                WHERE CART_MEMBER IN (SELECT MEM_ID FROM MEMBER
                                                        WHERE SUBSTR(MEM_BIR,1,2)='75'
                                                        AND   SUBSTR(MEM_ADD1,1,2)='대전')
                                                        )
                                                        ORDER BY PROD_SALE DESC;
                                                


[3문제]

대전 지역에 거주하고 생일이 2월이고 구매일자가 4월 ~ 6월 사이인 회원 중 
구매수량이 전체회원의 평균 구매수량보다 높은 회원 조회 후 

"(mem_name) 회원님의 (Extract(month form mem_bir)) 월 생일을 진심으로 축하합니다. 
2마트 (mem_add 중 2글자) 점을 이용해 주셔서 감사합니다.
이번 2월 동안에는 VVIP회원으로 마일리지를 3배로 사용하실 수 있습니다.
앞으로도 많은 이용 바랍니다." 출력

(Alias 회원명, 성별, 주소, 이메일 주소, 생일 축하 문구)
 