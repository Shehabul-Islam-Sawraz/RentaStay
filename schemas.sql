CREATE TABLE USERS (
	USER_ID NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) CONSTRAINT PERSON_PK PRIMARY KEY, 
	USERNAME VARCHAR2(50) NOT NULL UNIQUE ,
	FIRST_NAME VARCHAR2(25),
	LAST_NAME VARCHAR2(25),
	EMAIL VARCHAR2(50) NOT NULL UNIQUE,
	PHONE_NO VARCHAR2(20),
	PASSWORD VARCHAR2(255) NOT NULL,
	BANK_ACC_NO VARCHAR2(35),
	CREDIT_CARD_NO VARCHAR2(16),
	POINTS NUMBER(6,0)
);

CREATE TABLE COUNTRIES
(
	COUNTRY_NAME VARCHAR2(60) CONSTRAINT COUNTRY_PK PRIMARY KEY
);

CREATE TABLE STATES
(
	STATE_ID NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) CONSTRAINT STATE_PK PRIMARY KEY,
	STATE_NAME VARCHAR2(60) NOT NULL,
	COUNTRY_NAME VARCHAR2(60) NOT NULL,
	
	CONSTRAINT STATE_COUNTRY_FK FOREIGN KEY(COUNTRY_NAME) REFERENCES COUNTRIES(COUNTRY_NAME)
);

CREATE TABLE CITIES
(
	CITY_ID NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) CONSTRAINT CITY_PK PRIMARY KEY,
	CITY_NAME VARCHAR2(60) NOT NULL,
	STATE_ID NUMBER NOT NULL,

	CONSTRAINT CITY_STATE_FK FOREIGN KEY(STATE_ID) REFERENCES STATES(STATE_ID)
);

CREATE TABLE ADDRESSES 
(
	ADDRESS_ID NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1) CONSTRAINT ADDRESS_PK PRIMARY KEY,
	STREET VARCHAR2(50) NOT NULL,
	POST_CODE VARCHAR2(20) NOT NULL,
	CITY_ID NUMBER NOT NULL,
	
	CONSTRAINT ADDRESS_CITY_FK FOREIGN KEY(CITY_ID) REFERENCES CITIES(CITY_ID)
);

CREATE TABLE HOUSES
(
	HOUSE_ID NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) CONSTRAINT HOUSE_PK PRIMARY KEY,
	USER_ID NUMBER NOT NULL,
	ADDRESS_ID NUMBER NOT NULL UNIQUE,
	HOUSE_NAME VARCHAR2(20),
	HOUSE_NO VARCHAR2(30) NOT NULL,
	DESCRIPTION VARCHAR2(255),
	PHOTOS_PATH VARCHAR2(100),
	
	CONSTRAINT HOUSE_OWNER_FK FOREIGN KEY(USER_ID) REFERENCES USERS(USER_ID),
	CONSTRAINT HOUSE_ADDRESS_FK FOREIGN KEY(ADDRESS_ID) REFERENCES ADDRESSES(ADDRESS_ID)
);


CREATE TABLE PAYMENTS
(
	TRANSACTION_ID VARCHAR2(10) CONSTRAINT PAYMENT_PK PRIMARY KEY,
	TRANSACTION_DATE DATE DEFAULT SYSDATE NOT NULL,
	AMOUNT NUMBER NOT NULL,
	PAYMENT_METHOD VARCHAR2(10)
);

CREATE TABLE ROOMS 
(
	HOUSE_ID NUMBER NOT NULL,
	ROOM_NO NUMBER NOT NULL,
	PHOTOS_PATH VARCHAR2(100),
	MAX_CAPACITY NUMBER,
	DESCRIPTION VARCHAR2(255),
	PRICE NUMBER NOT NULL,
	OFFER_PCT NUMBER,
	CONSTRAINT ROOM_HOUSE_FK FOREIGN KEY(HOUSE_ID) REFERENCES HOUSES(HOUSE_ID),
	CONSTRAINT ROOM_PK PRIMARY KEY(HOUSE_ID, ROOM_NO)
);

CREATE TABLE RENTS
(
	USER_ID NUMBER NOT NULL,
	HOUSE_ID NUMBER NOT NULL,
	ROOM_NO NUMBER NOT NULL,
	TRANSACTION_ID VARCHAR2(10),
	REVIEW NUMBER,
	REVIEW_COMMENT VARCHAR2(255),
	CHECKIN DATE NOT NULL,
	CHECKOUT DATE NOT NULL,
	CONSTRAINT RENT_USER_FK FOREIGN KEY(USER_ID) REFERENCES USERS(USER_ID),
	CONSTRAINT RENT_PAYMENT_FK FOREIGN KEY(TRANSACTION_ID) REFERENCES PAYMENTS(TRANSACTION_ID),
	CONSTRAINT RENT_ROOM_FK FOREIGN KEY(HOUSE_ID, ROOM_NO) REFERENCES ROOMS(HOUSE_ID, ROOM_NO)
);

