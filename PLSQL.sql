CREATE OR REPLACE FUNCTION GET_MIN_PRICE(HID IN NUMBER)
RETURN NUMBER IS 
    MIN_PRICE NUMBER;
BEGIN
    SELECT MIN(NVL(PRICE, 0)) INTO MIN_PRICE
    FROM ROOMS
    WHERE HOUSE_ID = HID;
    
    RETURN MIN_PRICE;
END;
    
CREATE OR REPLACE FUNCTION GET_MAX_PRICE(HID IN NUMBER)
RETURN NUMBER IS 
    MAX_PRICE NUMBER;
BEGIN
    SELECT MAX(NVL(PRICE, 0)) INTO MAX_PRICE
    FROM ROOMS
    WHERE HOUSE_ID = HID;
    
    RETURN MAX_PRICE;
END;

CREATE OR REPLACE FUNCTION INSERT_HOUSE_RETURN_HOUSE_ID(USRID IN NUMBER, AID IN NUMBER, HNAME IN VARCHAR2, 
HNO IN VARCHAR2, DESCR IN VARCHAR2)
RETURN NUMBER IS
		HID NUMBER;
BEGIN
    INSERT INTO HOUSES(USER_ID,ADDRESS_ID,HOUSE_NAME,HOUSE_NO,DESCRIPTION) 
    VALUES(USRID, AID, HNAME, HNO, DESCR) RETURNING HOUSE_ID INTO HID;
		
		RETURN HID;
END;

CREATE OR REPLACE FUNCTION INSERT_ADDRESS_RETURN_ADDRESS_ID(STR IN VARCHAR2, PC IN VARCHAR2, CID IN NUMBER)
RETURN NUMBER IS
		AID NUMBER;
BEGIN
    INSERT INTO ADDRESSES(STREET, POST_CODE, CITY_ID) 
    VALUES(STR, PC, CID) RETURNING ADDRESS_ID INTO AID;
		
		RETURN AID;
END;