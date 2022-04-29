-- 2일차

/* 
[문제]
한 번도 상품을 구매한 적이 없는 회원 아이디, 이름을 조회 
*/
-- 1. 테이블 찾기        : 상품 - prod, 구매내역 - cart, 조회하는 컬럼 - member (후보)
-- 2. 조회할 컬럼 찾기 : mem_id, mem_name (조회하는 컬럼이 기준)
-- 3. 조건 있는지 확인 : 구매내역을 봐야 한다 - cart
select mem_id 회원ID, mem_name 회원명
from member 
-- 조회하는 컬럼이 기준
where mem_id NOT IN (select cart_member from cart);

/*
[문제]
한 번도 판매된 적이 없는 상품을 조회하려고 합니다.
판매된 적이 없는 상품 이름을 조회해 주세요
*/
-- 테이블    : prod, cart
-- 조건       : 
-- 조회컬럼 : prod_name
select prod_name 상품명
from prod
where prod_id NOT IN (select cart_prod from cart) ;

/*
[문제]
회원 중에 김은대 회원이 지금까지 구매햇던 모든 상품명을 조회해 주세요.
*/
-- 테이블    : 회원 - member, 상품명 - prod, 구매내역 - cart
-- 조건       : mem_name = '김은대'
-- 조회컬럼 : prod_name
-- 3개의 테이블 간의 연결관계가 있는지 확인하기 (있으면 작성 가능)
select prod_name 상품명
from prod
where prod_id IN (
            select cart_prod 
            from cart
            where cart_member IN (
                        select mem_id
                        from member
                        where mem_name = '김은대'
                    )
        ) ;
        
/*
[문제]
상품 중 판매가격이 10만원 이상, 30만원 이하인 상품을 조회.
조회 컬럼은 상품명, 판매가격입니다.
정렬은 판매가격을 기준으로 내림차순 해주세요.
*/
-- 테이블    : prod, 
-- 조건       :
-- 조회컬럼 : prod_name, prod_sale 
select prod_name, prod_sale
from prod
where prod_sale >= 100000 and 
         prod_sale <= 300000
order by prod_sale desc ;

select prod_name, prod_sale
from prod
where prod_sale BETWEEN 100000 and 300000 
order by prod_sale desc ;
-- BETWEEN : 이상, 이하 일 때만 사용이 가능 (미만, 초과일 때는 사용x)

-- 회원 중 생일 1975-01-01에서 1976-12-31 사이에 태어난 회원을 검색하시오 (alias는 회원ID, 회원명, 생일)
select mem_id 회원ID, mem_name 회원명, mem_regno1 생일
from member
where mem_regno1 BETWEEN 750101 AND 761231 ;

select mem_id 회원ID, mem_name 회원명, mem_regno1 생일
from member
where mem_bir BETWEEN '1975-01-01' 
                            AND '1976-12-31' ;
                            
select mem_id 회원ID, mem_name 회원명, mem_regno1 생일
from member
where mem_bir BETWEEN '75/01/01' 
                            AND '76/12/31' ;
                            
/*
[문제]
거래처 담당자 강남구씨가 담당하는 상품을 구매한 회원들을 조회하려고 합니다.
회원 아이디, 회원 이름을 조회해 주세요
*/
-- 2가지 방법이 있음
-- 테이블    : buyer, prod, cart, member, (lprod)
-- 조건       : buyer_charger
-- 조회컬럼 : mem_id, mem_name
select mem_id, mem_name
from member
where mem_id IN (
            select cart_member 
            from cart
            where cart_prod IN (
                        select prod_id 
                        from prod
                        where prod_buyer IN (
                                    select buyer_id 
                                    from buyer
                                    where buyer_charger = '강남구'
                        )
            )
) ;

select mem_id, mem_name
from member
where mem_id IN (
            select cart_member 
            from cart
            where cart_prod IN (
                        select prod_id 
                        from prod
                        where prod_lgu IN (
                                    select lprod_gu 
                                    from lprod
                                    where lprod_gu IN (
                                                select buyer_lgu
                                                from buyer
                                                where buyer_charger = '강남구' 
                                    )
                        )
            )
) ;


-- LIKE


/*
[문제]
회원테이블의 회원성명 중 성씨 '이' --> '리' 로 치환하여 뒤에 이름을 붙인 후 검색
alias명은 회원명, 회원명치환
*/
select concat(replace(substr(mem_name, 1, 1), '이', '리'),
         substr(mem_name, 2))
from member ;


-- 날짜 함수
select sysdate
from dual;

select add_months(sysdate, 5) 
from dual ;

select next_day(sysdate, '월요일'),
         last_day(sysdate)
from dual ;

-- 이번 달이 며칠이 남았는지 검색하기
select last_day(sysdate) - sysdate
from dual ;

-- 생일이 3월인 회원만 검색
select mem_bir, mem_name,
    extract(month from mem_bir) as bir3
from member
where extract(month from mem_bir) = '3' ; 

/*
회원 생일 중 1973년생이 주로 구매한 상픔을 오름차순으로 조회하려고 합니다.
- 조회컬럼 : 상품명
단, 상품명에 삼성이 포함된 상품만 조회, 그리고 조회 결과는 중복제거
*/
-- cart, member, prod
select DISTINCT prod_name
from prod
where prod_name LIKE '%삼성%' 
   and prod_id IN (
                select cart_prod 
                from cart
                where cart_member IN (
                                select mem_id 
                                from member
                                where extract(year from mem_bir) = 1973
                                )
                    )
order by prod_name asc;

--상품 테이블에서 상품입고일을 '2008-09-28'형식으로 나오게 검색하시오
--(상품명, 상품판매가, 입고일)

SELECT PROD_NAME,
       PROD_SALE,
       TO_CHAR(prod_insdate,'YYYY-MM-DD')
    FROM PROD ;
    
-- 회원이름과 생일로 다음처럼 출력되게 작성하시오.
SELECT CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(MEM_NAME,'님은 '),TO_CHAR(MEM_BIR,'YYYY')),'년 '),TO_CHAR(MEM_BIR,'MON') ),' 출생이고 태어난 요일은 '),TO_CHAR(MEM_BIR,'DAY'))
FROM MEMBER;

-- 문자열 합치기는 ||바 두개로 합치기
SELECT MEM_NAME ||
       '님은 ' ||
       TO_CHAR(MEM_BIR,'YYYY') ||
       '년 ' ||
       TO_CHAR(MEM_BIR,'MON')|| 
       ' 출생이고 태어난 요일은 ' ||
       TO_CHAR(MEM_BIR,'DAY')
    FROM MEMBER;

SELECT TO_CHAR(1234.6,'999,999.00') FROM DUAL; --천단위, 소숫점처리
SELECT TO_CHAR(-1234.6,'L9999.00PR') FROM DUAL; --지역 화폐, 음수일경우 <>묶기
SELECT TO_CHAR(255,'XXX') FROM DUAL;

SELECT TO_CHAR(PROD_SALE,'L999,999,999,999') 판매가격 --천단위, 원화
FROM PROD;

SELECT TO_NUMBER('3.14') FROM DUAL; --숫자같이 생긴 문자만 TO_CHAR 가능

SELECT MEM_ID 회원ID,
       CONCAT( SUBSTR(MEM_ID,1,2) ,
       TO_NUMBER(SUBSTR(MEM_ID,-2))+10) 조합회원ID
        FROM MEMBER
            WHERE MEM_NAME='이쁜이';
    
-- 판매상품평균
SELECT PROD_LGU,  
       ROUND(AVG(PROD_COST),2) --평균
        FROM PROD
        GROUP BY PROD_LGU;
 
--상품분류별 판매가격평균       
SELECT PROD_LGU 상품분류코드,
       TO_CHAR(AVG(PROD_SALE),'999,999,999,999') 판매가격평균
    FROM PROD
        GROUP BY PROD_LGU;
        
--장바구니 테이블의 회원별 COUNT 집계
SELECT CART_MEMBER,
       COUNT(*) MEM_COUNT
FROM CART
GROUP BY CART_MEMBER;

SELECT MEM_ID,
       MEM_NAME
       FROM MEMBER
        WHERE MEM_ID IN (SELECT CART_MEMBER
                            FROM CART
                                 WHERE CART_QTY>= SELECT AVG(CART_QTY) FROM CART
                                )
                                ORDER BY mem_regno1;

SELECT AVG(CART_QTY) FROM CART;
        
SELECT MEM_ID,
       MEM_NAME
       FROM MEMBER
        WHERE MEM_ID IN (SELECT CART_MEMBER
                            FROM CART
                                WHERE CART_QTY >= (SELECT AVG(CART_QTY) FROM CART)
                                );
                                


