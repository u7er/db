﻿DROP TABLE APRODUCT;
DROP TABLE AITEM;

/
CREATE TABLE AITEM (
  ID NUMBER(30) NOT NULL,
  nameItem VARCHAR2(50) NOT NULL,
  PRIMARY KEY(ID)
);
/
CREATE TABLE APRODUCT (
  ID NUMBER(30) NOT NULL,
  nameProduct VARCHAR2(50) NOT NULL,
  fieldID NUMBER(10) NOT NULL,
  PRIMARY KEY(ID),
  FOREIGN KEY (fieldID) REFERENCES AITEM(ID)
);
/
DROP SEQUENCE seqProduct;
DROP SEQUENCE seqItem;
/
CREATE SEQUENCE seqProduct START WITH 1001;
CREATE SEQUENCE seqItem;
/
CREATE OR REPLACE PACKAGE tablePack IS
  TYPE  nameItemTab IS TABLE OF AITEM.NAMEITEM%TYPE;
  TYPE  nameProductTab IS TABLE OF APRODUCT.NAMEPRODUCT%TYPE;
  PROCEDURE dataAdd;
  PROCEDURE dataDel;
  --PROCEDURE selectField (delName IN VARCHAR2 DEFAULT NULL);
END;
/
CREATE OR REPLACE PACKAGE BODY tablePack IS
  arrItem nameItemTab;
  arrProduct nameProductTab;
  PROCEDURE dataAdd IS
  BEGIN
    INSERT INTO AITEM(ID, nameItem) VALUES(seqItem.NEXTVAL, 'Булочка');
    INSERT INTO AITEM(ID, nameItem) VALUES(seqItem.NEXTVAL, 'Торт');
    INSERT INTO AITEM(ID, nameItem) VALUES(seqItem.NEXTVAL, 'Булка');
    INSERT INTO AITEM(ID, nameItem) VALUES(seqItem.NEXTVAL, 'Хлебушек');
    INSERT INTO AITEM(ID, nameItem) VALUES(seqItem.NEXTVAL, 'Пироженое');
    INSERT INTO AITEM(ID, nameItem) VALUES(seqItem.NEXTVAL, 'Кекс');
    INSERT INTO AITEM(ID, nameItem) VALUES(seqItem.NEXTVAL, 'Круассан');
    
    INSERT INTO APRODUCT(ID, nameProduct, fieldID) VALUES(seqProduct.NEXTVAL, 'Мука', 1);
    INSERT INTO APRODUCT(ID, nameProduct, fieldID) VALUES(seqProduct.NEXTVAL, 'Вода', 2);
    INSERT INTO APRODUCT(ID, nameProduct, fieldID) VALUES(seqProduct.NEXTVAL, 'Молоко', 3);
    INSERT INTO APRODUCT(ID, nameProduct, fieldID) VALUES(seqProduct.NEXTVAL, 'Сахар', 7);
    INSERT INTO APRODUCT(ID, nameProduct, fieldID) VALUES(seqProduct.NEXTVAL, 'Масло', 2);
    INSERT INTO APRODUCT(ID, nameProduct, fieldID) VALUES(seqProduct.NEXTVAL, 'Соль', 6);
    INSERT INTO APRODUCT(ID, nameProduct, fieldID) VALUES(seqProduct.NEXTVAL, 'Сода', 6);
END dataAdd;
    PROCEDURE dataDel IS 
    BEGIN   
        DELETE FROM APRODUCT;
        DELETE FROM AITEM;
        EXECUTE IMMEDIATE 'DROP SEQUENCE seqProduct';
        EXECUTE IMMEDIATE 'DROP SEQUENCE seqItem';
    END dataDel;
    END;
/   
BEGIN
    tablePack.dataAdd;
   -- tablePack.dataDel;
END;
/

CREATE OR REPLACE VIEW myView AS
  SELECT APRODUCT.ID, APRODUCT.nameProduct,
  AITEM.ID AITEM_ID, AITEM.nameItem, APRODUCT.FIELDID 
  FROM AITEM, APRODUCT WHERE AITEM.ID = APRODUCT.FIELDID; 
/
select * from myview;
/

CREATE OR REPLACE PACKAGE helpPack IS
  err_code NUMBER(10,0);
  err_msg VARCHAR2(500);
  PROCEDURE delProduct (idProduct IN number DEFAULT NULL);
  PROCEDURE ADD_DEL_TablePack (actTable IN VARCHAR2 DEFAULT NULL);
END helpPack;
/

CREATE OR REPLACE PACKAGE BODY helpPack IS

  PROCEDURE DelProduct 
  (idProduct IN number DEFAULT NULL) IS
  BEGIN
  DELETE FROM APRODUCT WHERE ID=idProduct;
    COMMIT;
    EXCEPTION 
      WHEN OTHERS THEN
      begin
        ROLLBACK;
        err_code := SQLCODE;
        err_msg := SUBSTR(SQLERRM, 1, 200);
        RAISE_APPLICATION_ERROR(err_code, err_msg);
        end;
  END DelProduct;

  
  PROCEDURE ADD_DEL_TablePack 
  (actTable IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    IF actTable = 'dataAdd' THEN
      tablePack.dataAdd;
    ELSIF actTable = 'dataDel' THEN
      tablePack.dataDel;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Не выбрано действий над таблицами');
    END IF;
    EXCEPTION 
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ОШИБКА!');
  END ADD_DEL_TablePack;
END helpPack;
/
BEGIN 
  HELPPACK.DELPRODUCT(1008);
  --HELPPACK.IN_DEL_TABLEPACK('dataIn');
END;

-- Право на обращение к нашему представлению для всех пользователей
GRANT SELECT ON myView TO PUBLIC;
-- Право на обращение к пакету только для UP1
GRANT EXECUTE ON helpPack TO up1;
