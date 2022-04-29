
                
-- 3일차
/*
수행 순서
 : select -> from + 테이블 -> where + 일반 조건 (in, and, or, ..) (맞는 조건들을 걸러냄)
   -> group by + 일반컬럼 -> having + 그룹 조건 
   -> (select 줄) 출력할 컬럼(그룹 함수) 체크 -> order by 
*/

-- GROUP
-- count
-- count(컬럼) : null 값은 제외
-- count(*)     : null 값도 포함

/*
[문제] 
구매내역(장바구니) 정보에서 회원아이디로 주문(수량)에 대한 평균을 조회해 주세요.
회원아이디를 기준으로 내림차순
*/
select cart_member, avg(cart_qty) as avg_qty
from cart 
group by cart_member
order by cart_member desc;

/*
[문제]
상품 정보에서 판매가격의 평균 값을 구해주세요.
단, 평균값은 소수점 둘째자리까지 표현해주세요.
*/
select round(avg(prod_sale), 2) avg_sale
from prod ;

/*
[문제]
상품정보에서 상품분류별 판매가격의 평균값을 구해주세요.
조회 컬럼은 상품분류코드, 상품분류별 판매가격의 평균
단, 평균값은 소수점 둘째자리까지 표현해주세요.
*/
select prod_lgu, round(avg(prod_sale), 2) avg_sale
from prod
group by prod_lgu;

-- 회원테이블의 취미종류수를 count 집계
select count(DISTINCT mem_like) 취미종류수
from member ;

-- 회원테이블의 취미별 count집계
select mem_like 취미, 
         count(mem_like) 자료수, count(*) "자료수(*)"
from member
group by  mem_like ;

-- 회원테이블의 직업종류수는 count집계
select count(DISTINCT mem_job) kind_job
from member ;

select mem_id, count(mem_job) cnt_job
from member 
group by mem_id
order by ;

/*
[문제]
회원 전체의 마일리지 평균보다 큰 회원에 대한 아이디, 이름, 마일리지를 조회해 주세요
정렬은 마일리지가 높은 순으로
*/
select avg(mem_mileage)
from member ;

select mem_id, mem_name, mem_mileage 
from member
where mem_mileage >= (
                                  select avg(mem_mileage)
                                  from member
                                  )
order by mem_mileage desc;


-- max(col), min(col)
select cart_member 회원ID,
        max(distinct cart_qty) "최대수량(distinct)",
        max(cart_qty) 최대수량
from cart
group by cart_member ;


select *
from cart ;

-- 오늘이 2005년도 7월 11일이라 가정하고 장바구니테이블에 발생될 추가주문번호를 검색하시오
-- alias 최고치주문번호, 추가주문번호
select max(cart_no) 마지막주문번호, (max(cart_no) + 1) 추가주문번호 
from cart
where cart_no LIKE '20050711%' ;
-- like / substr / to_date 등 사용 가능

/*
[문제]
구매정보에서 연도별로 판매된 상품의 갯수, 평균구매수량을 조회하려고 합니다.
정렬은 연도를 기준으로 내림차순해주세요
*/
select substr(cart_no, 1, 4) as yyyy, 
         sum(cart_qty) as sum_qty,
         avg(cart_qty) as avg_qty
from cart 
group by substr(cart_no, 1, 4)
order by yyyy desc;
-- 단일 그룹의 그룹 함수가 아니다 : 그룹함수를 제외한 일반함수가 들어가있다라는 뜻

/*
[문제]
구매정보에서 연도별, 상품분류코드별로 상품의 갯수를 조회하려고 합니다.
정렬은 연도를 기준으로 내림차순해주세요.
*/
SELECT SUBSTR(CART_NO,1,4) YYYY,
       SUBSTR(CART_PROD,1,4) 상품분류코드,
       COUNT(CART_PROD) 갯수
        FROM CART
            GROUP BY SUBSTR(CART_NO,1,4), SUBSTR(CART_PROD,1,4)
                ORDER BY SUBSTR(CART_NO,1,4);
                
SELECT AVG(mem_mileage) MEM_AVG,
       SUM(MEM_MILEAGE) MEM_SUM,
       MAX(MEM_MILEAGE) MEM_MAX,
       MIN(MEM_MILEAGE) MEM_MIN,
       COUNT(MEM_ID)
  FROM MEMBER;
  
/*
상품 테이블에서 상품 분류별 판매가전체의 
평균, 합계, 최고값, 최저값, 자료수 검색
*/

SELECT PROD_LGU 상품코드,
       ROUND(AVG(PROD_SALE),2) 평균,
       SUM(PROD_SALE) 합계,
       MAX(PROD_SALE) 최대값,
       MIN(PROD_SALE) 최소값,
       COUNT(PROD_LGU) 자료수
    FROM PROD
        GROUP BY PROD_LGU
        HAVING COUNT(PROD_LGU) >=20 ; --그룹화에서의 조건절 HAVING
        
/*
회원테이블에서 지역(주소1의 2자리), 생일년도별로 마일리지평균,
합계,최고,최소, 자료수 검색
*/

SELECT SUBSTR(MEM_ADD1,1,2) 지역,
       TO_NUMBER(SUBSTR(MEM_BIR,1,2)) 년도, --TO_CHAR(MEM_BIR, 'YYYY')
       AVG(mem_mileage) MEM_AVG,
       SUM(MEM_MILEAGE) MEM_SUM,
       MAX(MEM_MILEAGE) MEM_MAX,
       MIN(MEM_MILEAGE) MEM_MIN,
       COUNT(MEM_MILEAGE)
    FROM MEMBER
            GROUP BY  SUBSTR(MEM_ADD1,1,2),
                      TO_NUMBER(SUBSTR(MEM_BIR,1,2))
                        ORDER BY SUBSTR(MEM_ADD1,1,2), 
                                 TO_NUMBER(SUBSTR(MEM_BIR,1,2));
UPDATE BUYER SET BUYER_CHARGER=NULL
WHERE BUYER_CHARGER LIKE '김%';

UPDATE BUYER SET BUYER_CHARGER=''
    WHERE BUYER_CHARGER LIKE '성%';
        
SELECT BUYER_NAME 거래처,
       BUYER_CHARGER 담당자,
        FROM BUYER
            WHERE BUYER_CHARGER = NULL;

SELECT BUYER_NAME 거래처,
       BUYER_CHARGER 담당자,
        FROM BUYER
            WHERE BUYER_CHARGER = NULL;
            
SELECT BUYER_NAME,
       BUYER_CHARGER,
       NVL(BUYER_CHARGER,'없다')
        FROM BUYER;
        
SELECT MEM_NAME 성명,
       MEM_MILEAGE 마일리지,
       MEM_MILEAGE +100 마일리지_100
    FROM MEMBER;

SELECT MEM_NAME 성명,
       MEM_MILEAGE 마일리지,
       NVL2(MEM_MILEAGE,'정상회원','비정상 회원') 회원상태
    FROM MEMBER;
    
SELECT DECODE(SUBSTR(PROD_LGU,1,2),
              'P1','컴퓨터/전자제품',
              'P2','의류',
              'P3','잡화','기타')
        FROM PROD;
        
SELECT  PROD_NAME 상품명,
        PROD_LGU  상품코드,
        DECODE(SUBSTR(PROD_LGU,1,2),
              'P1',PROD_SALE*1.1,
              'P2',PROD_SALE*1.15,PROD_SALE) AS 상품별_인상가격
        FROM PROD;

CASE 컬럼  

WHEN 조건1 THEN 값1 

WHEN 조건2 THEN 값2 

ELSE 값3 

END 

SELECT MEM_NAME,
       (MEM_REGNO1 || '-' || MEM_REGNO2) 주민등록번호,
       CASE SUBSTR(MEM_REGNO2,1,1) WHEN '1' THEN '남자'
                                    ELSE '여자' 
                                    END    --CASE문에 END 필수
                                    AS 성별
    FROM MEMBER;
    
----------------------문제 만들기----------------------------------------
/*
문제1
컴퓨터제품을 주관하며 수도권(서울,인천)에 살고 주소에 '마' 가 들어간 곳에 사는 담당자가 담당하는
제품 중에서 판매가격이 전체판매가격 이상인 상품을 구매한 회원들이 사는 곳(지역)을  분류하고

지역별 회원들이 생각하는 기념일별 가장 많은 기념일은 어떤것인지 알아내시오
--서울: 수도권
--충남, 대전 : 충청도 나머지는 경상도
*/

select DECODE(SUBSTR(MEM_ADD1,1,2),'서울','수도권',
                                   '충남','충청도',
                                   '대전','충청도','경상도') AS 지역,
       MEM_MEMORIAL,
       COUNT(MEM_MEMORIAL)
      
                                   
        from member
where mem_id IN (
            select cart_member 
            from cart
            where cart_prod IN (
                        select prod_id  
                        from prod
                        where PROD_SALE >= (SELECT AVG(PROD_SALE) FROM PROD) 
                            AND prod_lgu IN (
                                    select lprod_gu 
                                    from lprod
                                    where LPROD_NM='컴퓨터제품'
                                        AND lprod_gu IN (
                                                select buyer_lgu
                                                from buyer
                                                where SUBSTR(BUYER_ADD1,1,2)='서울' 
                                                OR    SUBSTR(BUYER_ADD1,1,2)='인천'
                                                AND   BUYER_ADD1 LIKE '%마%'  
                                    )
                        )
            )
)

GROUP BY  MEM_MEMORIAL, 
          DECODE(SUBSTR(MEM_ADD1,1,2),'서울','수도권',
                                   '충남','충청도',
                                   '대전','충청도','경상도') ;

------------------------------------------------------------------------     


/*
부산에 사는 담당자가 담당하는 상품의 판매가가 전체 평균판매가의 3배 이상이고 
안전 재고수량별 안전재고수가 가장 높은 상품을 구매한 회원 중 자영업이 아닌 멤버 아이디와 회원이름을
구하시오
*/


                        
                        
                        
        
                        
                        
                        
                        
                        
                        
                        
                        
                        
     