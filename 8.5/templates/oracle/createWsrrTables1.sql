-- begin_generated_IBM_copyright_prolog

-- Licensed Materials - Property of IBM
-- 
-- 5724-N72 5655-WBS
-- 
-- Copyright IBM Corp. 2006, 2010 All Rights Reserved.
-- 
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with
-- IBM Corp.

-- end_generated_IBM_copyright_prolog

------------------------------------------------

ALTER SESSION SET CURRENT_SCHEMA = __DBSCHEMA__;

CREATE TABLE SUBJECT (
        HASH    NUMBER(19)      NOT NULL,
        URI     VARCHAR2(1024)  NOT NULL,
        VERSION NUMBER(19)      DEFAULT 0 NOT NULL,
        CONSTRAINT subject_pk   PRIMARY KEY (HASH)
);

CREATE TABLE PREDICATE (
        HASH    NUMBER(19)      NOT NULL,
        URI     VARCHAR2(1024)  NOT NULL,
        CONSTRAINT predicate_pk PRIMARY KEY (HASH)
);

CREATE TABLE OBJECT (
        HASH            NUMBER(19)      NOT NULL,
        STRING          VARCHAR2(1024)  NOT NULL,
        LANG    		CHAR(2),
	    DISTRICT        CHAR(2),
	    LVARIANT    	VARCHAR2(254),
	    CONTENT         BLOB ,
        CONSTRAINT obj_pk PRIMARY KEY(HASH)
);

CREATE INDEX IDX_VALUE_LANG     ON __DBSCHEMA__.OBJECT(LANG ASC, DISTRICT ASC, LVARIANT ASC, HASH ASC);

CREATE TABLE GRAPH (
        HASH    NUMBER(19)      NOT NULL,
        URI     VARCHAR2(1024)  NOT NULL,
        CONSTRAINT graph_pk     PRIMARY KEY(HASH)
);


--statement entries go into the default tablespace via default bufferpool
CREATE TABLE STATEMENT (
        SUBJ_HASH       NUMBER(19) NOT NULL,
        PRED_HASH       NUMBER(19) NOT NULL,
        OBJ_HASH        NUMBER(19) NOT NULL,
        OBJ_HASH_REL    NUMBER(19),
        OBJ_TYP_CD      NUMBER(3)  NOT NULL
);

CREATE TABLE GSTATEMENT (
        SUBJ_HASH       NUMBER(19) NOT NULL,
        PRED_HASH       NUMBER(19) NOT NULL,
        OBJ_HASH        NUMBER(19) NOT NULL,
        OBJ_TYP_CD      NUMBER(3)  NOT NULL,
        LANG            CHAR(2),
        GRAPH_HASH      NUMBER(19)
);


ALTER TABLE GSTATEMENT ADD CONSTRAINT FK_GSTATEMENT_SUBJ FOREIGN KEY (SUBJ_HASH) REFERENCES SUBJECT (HASH);
ALTER TABLE GSTATEMENT ADD CONSTRAINT FK_GSTATEMENT_PRED FOREIGN KEY (PRED_HASH) REFERENCES PREDICATE (HASH);
ALTER TABLE GSTATEMENT ADD CONSTRAINT FK_GSTATEMENT_GRAPH FOREIGN KEY (GRAPH_HASH) REFERENCES GRAPH (HASH);

ALTER TABLE STATEMENT ADD CONSTRAINT FK_STATEMENT_SUBJ FOREIGN KEY (SUBJ_HASH) REFERENCES SUBJECT (HASH);
ALTER TABLE STATEMENT ADD CONSTRAINT FK_STATEMENT_OBJ_HASH_REL FOREIGN KEY (OBJ_HASH_REL) REFERENCES SUBJECT(HASH);
ALTER TABLE STATEMENT ADD CONSTRAINT FK_STATEMENT_PRED FOREIGN KEY (PRED_HASH) REFERENCES PREDICATE (HASH);

CREATE INDEX IDX_STMT_OBJ_HASH_REL ON __DBSCHEMA__.STATEMENT(OBJ_HASH_REL ASC);
CREATE UNIQUE INDEX IDX_STMT_SUBJ_PRED_OBJ_SUB ON STATEMENT (SUBJ_HASH ASC, PRED_HASH ASC, OBJ_TYP_CD ASC, OBJ_HASH ASC);
CREATE UNIQUE INDEX IDX_STMT_PRED_OBJ_SUBJ ON STATEMENT (PRED_HASH ASC, OBJ_HASH ASC, OBJ_TYP_CD ASC, SUBJ_HASH ASC);
CREATE UNIQUE INDEX IDX_STMT_OBJ_SUBJ_PRED ON STATEMENT (OBJ_HASH ASC, OBJ_TYP_CD ASC, SUBJ_HASH ASC, PRED_HASH ASC);

CREATE UNIQUE INDEX IDX_GSTMT_REL_SUBJ ON __DBSCHEMA__.GSTATEMENT(SUBJ_HASH ASC, OBJ_HASH ASC, OBJ_TYP_CD ASC, PRED_HASH ASC, GRAPH_HASH ASC, LANG ASC) ;
CREATE UNIQUE INDEX IDX_GSTMT_REL_OBJ ON __DBSCHEMA__.GSTATEMENT(OBJ_HASH ASC, PRED_HASH ASC, OBJ_TYP_CD ASC, SUBJ_HASH ASC, GRAPH_HASH ASC) ;
CREATE UNIQUE INDEX IDX_GSTMT_GRAPH ON __DBSCHEMA__.GSTATEMENT(GRAPH_HASH ASC, SUBJ_HASH ASC, PRED_HASH ASC, OBJ_TYP_CD ASC, OBJ_HASH ASC) ;
CREATE UNIQUE INDEX IDX_GSTMT_PRED ON __DBSCHEMA__.GSTATEMENT(PRED_HASH ASC, SUBJ_HASH ASC, OBJ_HASH ASC, OBJ_TYP_CD ASC, GRAPH_HASH ASC) ;

CREATE INDEX IDX_GSTMT_PRED_OBJ_SUB ON __DBSCHEMA__.GSTATEMENT (PRED_HASH ASC, OBJ_HASH ASC, SUBJ_HASH ASC) ;
CREATE INDEX IDX_GSTMT_OBJ_SUBJ_PRED ON __DBSCHEMA__.GSTATEMENT (OBJ_HASH ASC, SUBJ_HASH ASC, PRED_HASH ASC) ;
CREATE UNIQUE INDEX IDX_GSTMT_INSTANCE_ROW ON __DBSCHEMA__.GSTATEMENT (SUBJ_HASH ASC, GRAPH_HASH ASC, OBJ_TYP_CD ASC, OBJ_HASH ASC, PRED_HASH ASC) ;

CREATE UNIQUE INDEX IDX_OBJ_STRING ON __DBSCHEMA__.OBJECT (HASH ASC, STRING) ;
CREATE UNIQUE INDEX IDX_PRED_URI ON __DBSCHEMA__.PREDICATE (HASH ASC, URI) ;
CREATE UNIQUE INDEX IDX_GRAPH_URI ON __DBSCHEMA__.GRAPH (HASH ASC, URI) ;
CREATE UNIQUE INDEX IDX_SUBJ_URI ON __DBSCHEMA__.SUBJECT (HASH ASC, URI, VERSION) ;

CREATE TABLE MOD_LOCK (
    ID NUMBER(*,0)         NOT NULL ENABLE,
	MLOCK NUMBER(*,0)      NOT NULL ENABLE
);

INSERT INTO MOD_LOCK (ID,MLOCK) VALUES (1,0);

----------------------------------------------------------
-- View that shows the STATEMENT table in its resolved state - that is, with full
-- text values for GRAPH, SUBJECT, PREDICATE, and OBJECT.  Intended only for service purposes.
----------------------------------------------------------
CREATE VIEW SVC_STATEMENT AS
    SELECT (select URI from SUBJECT where HASH = SUBJ_HASH) SUBJECT,
    (select URI from PREDICATE where HASH = PRED_HASH) PREDICATE, 
    CASE
        WHEN st.OBJ_TYP_CD IN (1,2,9,16) THEN (SELECT STRING from OBJECT WHERE HASH=st.OBJ_HASH)
        WHEN st.OBJ_TYP_CD IN (17) THEN 'BLOB: ' || CAST(st.OBJ_HASH AS CHAR(25)) || ' (BYTELEN: ' || CAST((SELECT length(CONTENT) FROM OBJECT WHERE HASH = st.OBJ_HASH) AS CHAR(25)) || ')'
        WHEN st.OBJ_TYP_CD IN (18) THEN 'LARGE STRING: ' || CAST(st.OBJ_HASH AS CHAR(25)) || ' (BYTELEN: ' || CAST((SELECT length(CONTENT) FROM OBJECT WHERE HASH = st.OBJ_HASH) AS CHAR(25)) || ')'
        ELSE CAST(st.OBJ_HASH AS CHAR(25))
    END OBJECT,
    (SELECT URI from GRAPH WHERE HASH=st.GRAPH_HASH) GRAPH,
    st.OBJ_TYP_CD OBJ_TYP_CD, st.SUBJ_HASH SUBJ_HASH, st.PRED_HASH PRED_HASH, st.OBJ_HASH OBJ_HASH, st.OBJ_HASH_REL OBJ_HASH_REL, st.GRAPH_HASH GRAPH_HASH, st.LANG LANG
    FROM 
        (select SUBJ_HASH, PRED_HASH, OBJ_HASH, cast(null as NUMBER(19)) as GRAPH_HASH, OBJ_TYP_CD, cast(null as CHAR(2)) as LANG, OBJ_HASH_REL from STATEMENT
        UNION ALL
        select SUBJ_HASH, PRED_HASH, OBJ_HASH, GRAPH_HASH, OBJ_TYP_CD, LANG, cast(null as NUMBER(19)) as OBJ_HASH_REL from GSTATEMENT) st;

GRANT SELECT,INSERT,UPDATE,DELETE ON SUBJECT TO __DBUSER__; 
GRANT SELECT,INSERT,UPDATE,DELETE ON PREDICATE TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON OBJECT TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON GRAPH TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON STATEMENT TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON GSTATEMENT TO __DBUSER__;
GRANT SELECT ON SVC_STATEMENT TO __DBUSER__;
GRANT UPDATE ON MOD_LOCK TO __DBUSER__;