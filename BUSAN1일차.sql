CREATE TABLE lprod(
    lprod_id number(5) not null,
    lprod_gu char(4) not null,
    lprod_nm varchar2(40) not null,
    constraint pk_lprod Primary key(lprod_gu)
);

-- 조회하기
select * FROM LPROD;

-- 데이터 입력하기 (입력 후 커밋 필수!!!)
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    1,'P101','컴퓨터제품'
    );

insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    2,'P102','전자제품'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    3,'P103','여성캐쥬얼'
    );

insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    4,'P104','남성캐쥬얼'
    );
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    5,'P105','피혁잡화'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    6,'P106','화장품'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    7,'P107','음밤/CD'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    8,'P108','도서'
    );
    
insert into lprod(
lprod_id, lprod_gu, lprod_nm
)
    Values(
    9,'P109','문구류'
    );
    

commit;

select * FROM LPROD;

--상품 분류정보에서 상품분류코드의 값이 
--P201인 데이터를 조회
SELECT * FROM lprod
    WHERE lprod_gu>'P102';--문자로 적긴했지만 숫자의 크기로 인식하여 결과값나옴
    
-- 상품분류코드가 P102에 대해서
-- 상품분류명의 값을 향수로 수정해 주세요
-- 데이터 수정
select * from lprod
    where lprod_gu='P102';
    
update lprod
    Set lprod_nm='향수'
where lprod_gu='P102'; --primarykey

select * from lprod;

--데이터 삭제
-- 상품분류정보가 P202에 대한 데이터를 삭제
select * from lprod
    where lprod_gu = 'P102';
    
delete from lprod
    where lprod_gu='P102';

ROLLBACK; --커밋한 다음에는 효력 X
commit; -- 실제로 테이블에 들어가게 하기 위함

--테이블 생성
CREATE TABLE BUYER(
BUYER_ID    CHAR(6) NOT NULL,               --거래처코드
BUYER_NAME  VARCHAR2(40)    NOT NULL,       --거래처명
BUYER_IGU   CHAR(4) NOT NULL,               --취급상품 대분류
BUYER_BANK  VARCHAR2(60),                   --은행
BUYER_BANKNO    VARCHAR2(60),               --계좌번호
BUYER_BANKNAME  VARCHAR2(15),               --예금주
BUYER_ZIP   CHAR(7),                        --우편번호
BUYER_ADD1  VARCHAR2(100),                  --주소1
BUYER_ADD2  VARCHAR2(70),                   --주소2
BUYER_COMTEL    VARCHAR2(14) NOT NULL,      --전화번호
BUYER_FAX   VARCHAR2(20) NOT NULL           --FAX번호
);

--상태 변경하기
ALTER TABLE BUYER ADD(             --컬럼(변수) 추가하기
BUYER_MAIL VARCHAR2(60) NOT NULL,
BUYER_CHARGER VARCHAR2(20),
BUYER_TELEXT VARCHAR2(2)
);

--변수 속성 변경하기
ALTER TABLE BUYER MODIFY(BUYER_NAME VARCHAR(60));

ALTER TABLE BUYER
    ADD(CONSTRAINT PK_BUYER PRIMARY KEY(BUYER_ID),
        CONSTRAINT FR_BUYER_LPROD fOREIGN KEY(BUYER_IGU) --부모찾기
                                        REFERENCES LPROD(LPROD_GU));












