-- begin_generated_IBM_copyright_prolog

-- Licensed Materials - Property of IBM
-- 
-- 5724-N72 5655-WBS
-- 
-- Copyright IBM Corp. 2008, 2009 All Rights Reserved.
-- 
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with
-- IBM Corp.

-- end_generated_IBM_copyright_prolog

CREATE TABLE __DBSCHEMA__.SR_ANALYTICS (
		EVENT IMAGE,
		SOURCE_COMPONENT_ID VARCHAR(1020),
		REPORTER_COMPONENT_ID VARCHAR(1020),
		SITUATION INT,
		CREATION_TIME datetime NOT NULL,
		EXTENSION_NAME VARCHAR(1024),
		VERSION VARCHAR(16),
		MSG_DATA_ELEMENT_MSGLOCALE VARCHAR(11),
		MSG_DATA_ELEMENT_MSGCATLOGTKNS VARCHAR(4000),
		MSG_DATA_ELEMENT_MSGID VARCHAR(256),
		MSG_DATA_ELEMENT_MSGIDTYPE VARCHAR(32),
		MSG_DATA_ELEMENT_MSGCATALOGID VARCHAR(128),
		MSG_DATA_ELEMENT_MSGCATLOGTYPE VARCHAR(32),
		MSG_DATA_ELEMENT_MSGCATALOG VARCHAR(128),
		SITUATION_CATEGORYNAME VARCHAR(20) DEFAULT 'ReportSituation',
		SITUATION_REPORTCATEGORY CHAR(5) DEFAULT 'Log',
		GLOBAL_INSTANCE_ID VARCHAR(48) NOT NULL	);

ALTER TABLE __DBSCHEMA__.SR_ANALYTICS ADD CONSTRAINT SR_ANALYTICS_PK 
	PRIMARY KEY	(GLOBAL_INSTANCE_ID);

CREATE INDEX SR_ANALYTICS_VER_IDX ON __DBSCHEMA__.SR_ANALYTICS ( VERSION );

CREATE TABLE __DBSCHEMA__.SR_ASSERTION (
		GLOBAL_INSTANCE_ID VARCHAR(48) NOT NULL,
		ASSERTION_TYPE VARCHAR(40) NOT NULL,
		ASSERTION_ID VARCHAR(120),
		ASSERTION_NAME VARCHAR(120),
		STATUS CHAR(1) DEFAULT '0' NOT NULL	);

ALTER TABLE __DBSCHEMA__.SR_ASSERTION ADD CONSTRAINT SR_ASSERTION_PK 
	PRIMARY KEY	(GLOBAL_INSTANCE_ID);

ALTER TABLE __DBSCHEMA__.SR_ASSERTION ADD CONSTRAINT ASSN_ANYTCS_FK 
	FOREIGN KEY	(GLOBAL_INSTANCE_ID)
	REFERENCES __DBSCHEMA__.SR_ANALYTICS	(GLOBAL_INSTANCE_ID)
	ON DELETE CASCADE;
	
CREATE TABLE __DBSCHEMA__.SR_ASSOCIATED (
		RESOLVED_RECORD VARCHAR(48) NOT NULL,
		GLOBAL_INSTANCE_ID VARCHAR(48) NOT NULL	);

ALTER TABLE __DBSCHEMA__.SR_ASSOCIATED ADD CONSTRAINT ASSCTD_ANLYTICS_FK 
	FOREIGN KEY (GLOBAL_INSTANCE_ID)
	REFERENCES __DBSCHEMA__.SR_ANALYTICS (GLOBAL_INSTANCE_ID)
	ON DELETE CASCADE;

CREATE TABLE __DBSCHEMA__.SR_ENTITYACTION (
		OPERATION VARCHAR(20),
		ENTITY_TYPE VARCHAR(1020),
		USERID VARCHAR(64),
		ROLE CHAR(254),
		ENTITY_BSRURI VARCHAR(48),
		TRANSITION_URI VARCHAR(1020),
		GLOBAL_INSTANCE_ID VARCHAR(48) NOT NULL	);

ALTER TABLE __DBSCHEMA__.SR_ENTITYACTION ADD CONSTRAINT SR_ENTITYACTION_PK 
	PRIMARY KEY	(GLOBAL_INSTANCE_ID);

ALTER TABLE __DBSCHEMA__.SR_ENTITYACTION ADD CONSTRAINT ENTYUPD_ANYTCS_FK 
	FOREIGN KEY	(GLOBAL_INSTANCE_ID)
	REFERENCES __DBSCHEMA__.SR_ANALYTICS	(GLOBAL_INSTANCE_ID)
	ON DELETE CASCADE;

CREATE TABLE __DBSCHEMA__.SR_VALDTRPOLICY (
		GLOBAL_INSTANCE_ID VARCHAR(48) NOT NULL,
		POLICYDOMAIN VARCHAR(1020),
		POLICYID VARCHAR(1020),
		POLICYCLASS VARCHAR(1020),
		STATUS CHAR(1) DEFAULT '0' NOT NULL,
		POLICYNAME VARCHAR(1020),
		POLICYURI VARCHAR(1020),
		CREATION_TIME datetime NOT NULL	);

ALTER TABLE __DBSCHEMA__.SR_VALDTRPOLICY ADD CONSTRAINT SR_VALDTRPOLICY_PK 
	PRIMARY KEY	(GLOBAL_INSTANCE_ID);

ALTER TABLE __DBSCHEMA__.SR_VALDTRPOLICY ADD CONSTRAINT VALDPLCY_ANYTCS_FK 
	FOREIGN KEY	(GLOBAL_INSTANCE_ID)
	REFERENCES __DBSCHEMA__.SR_ANALYTICS	(GLOBAL_INSTANCE_ID)
	ON DELETE CASCADE;

CREATE TABLE __DBSCHEMA__.SR_WMB_POLICY (
		GLOBAL_INSTANCE_ID VARCHAR(48) NOT NULL,
		TOTAL_RECEIPTS DECIMAL(19,0) NOT NULL,
		TOTAL_RECEIPT_SUCCESS DECIMAL(19,0) NOT NULL,
		TOTAL_RECEIPT_FAULTS DECIMAL(19,0) NOT NULL,
		TOTAL_REPLIES DECIMAL(19,0) NOT NULL,
		TOTAL_REPLY_SUCCESS DECIMAL(19,0) NOT NULL,
		TOTAL_REPLY_FAULTS DECIMAL(19,0) NOT NULL,
		POLICY_SET_NAME VARCHAR(1024),
		BROKER_NAME VARCHAR(1024) NOT NULL,
		BROKER_UUID VARCHAR(36) NOT NULL,
		EXGRP_NAME VARCHAR(1024) NOT NULL,
		EXGRP_UUID VARCHAR(36) NOT NULL,
		FLOW_DEPLOYED VARCHAR(1) NOT NULL,
		FLOW_NAME VARCHAR(1024) NOT NULL,
		NODE_NAME VARCHAR(1024) NOT NULL,
		OPERATION_NAME VARCHAR(1024) NOT NULL,
		RESET_TIME datetime NOT NULL,
		INTERVAL_START_TIME datetime NOT NULL,
		INTERVAL_END_TIME datetime NOT NULL,
		CHECK (FLOW_DEPLOYED IN ('0','1'))	);

ALTER TABLE __DBSCHEMA__.SR_WMB_POLICY ADD CONSTRAINT SR_WMB_POLICY_PK 
	PRIMARY KEY	(GLOBAL_INSTANCE_ID);

ALTER TABLE __DBSCHEMA__.SR_WMB_POLICY ADD CONSTRAINT ASSN_SR_WMB_POLICY_FK 
	FOREIGN KEY	(GLOBAL_INSTANCE_ID)
	REFERENCES __DBSCHEMA__.SR_ANALYTICS (GLOBAL_INSTANCE_ID)
	ON DELETE CASCADE;

CREATE TABLE __DBSCHEMA__.WSRRTASK ( TASKID BIGINT NOT NULL ,
               VERSION VARCHAR(5) NOT NULL ,
               ROW_VERSION INT NOT NULL ,
               TASKTYPE INT NOT NULL ,
               TASKSUSPENDED TINYINT NOT NULL ,
               CANCELLED TINYINT NOT NULL ,
               NEXTFIRETIME BIGINT NOT NULL ,
               STARTBYINTERVAL VARCHAR(254) NULL ,
               STARTBYTIME BIGINT NULL ,
               VALIDFROMTIME BIGINT NULL ,
               VALIDTOTIME BIGINT NULL ,
               REPEATINTERVAL VARCHAR(254) NULL ,
               MAXREPEATS INT NOT NULL ,
               REPEATSLEFT INT NOT NULL ,
               TASKINFO IMAGE NULL ,
               NAME VARCHAR(254) NOT NULL ,
               AUTOPURGE INT NOT NULL ,
               FAILUREACTION INT NULL ,
               MAXATTEMPTS INT NULL ,
               QOS INT NULL ,
               PARTITIONID INT NULL ,
               OWNERTOKEN VARCHAR(200) NOT NULL ,
               CREATETIME BIGINT NOT NULL );

ALTER TABLE __DBSCHEMA__.WSRRTASK WITH NOCHECK ADD CONSTRAINT WSRRTASK_PK PRIMARY KEY  NONCLUSTERED ( TASKID );

CREATE INDEX WSRRTASK_IDX1 ON __DBSCHEMA__.WSRRTASK ( TASKID, OWNERTOKEN );

CREATE CLUSTERED INDEX WSRRTASK_IDX2 ON __DBSCHEMA__.WSRRTASK ( NEXTFIRETIME ASC,
               REPEATSLEFT,
               PARTITIONID );

CREATE TABLE __DBSCHEMA__.WSRRTREG ( REGKEY VARCHAR(254) NOT NULL ,
               REGVALUE VARCHAR(254) NULL ,
               PRIMARY KEY ( REGKEY ) );

CREATE TABLE __DBSCHEMA__.WSRRLMGR ( LEASENAME VARCHAR(254) NOT NULL,
               LEASEOWNER VARCHAR(254) NOT NULL,
               LEASE_EXPIRE_TIME BIGINT,
               DISABLED VARCHAR(5) );

ALTER TABLE __DBSCHEMA__.WSRRLMGR WITH NOCHECK ADD CONSTRAINT WSRRLMGR_PK PRIMARY KEY  NONCLUSTERED ( LEASENAME );

CREATE TABLE __DBSCHEMA__.WSRRLMPR ( LEASENAME VARCHAR(254) NOT NULL,
               NAME VARCHAR(254) NOT NULL,
               VALUE VARCHAR(254) NOT NULL );

CREATE INDEX WSRRLMPR_IDX1 ON __DBSCHEMA__.WSRRLMPR ( LEASENAME, NAME ) ;

GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.SR_WMB_POLICY TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.SR_VALDTRPOLICY TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.SR_ENTITYACTION TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.SR_ASSOCIATED TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.SR_ANALYTICS TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.SR_ASSERTION TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.WSRRTASK TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.WSRRTREG TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.WSRRLMGR TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.WSRRLMPR TO __DBUSER__;

GO -- remove this line if running through JDBC

------------------
-- UPGRADE tables
------------------
CREATE TABLE __DBSCHEMA__.UPGRADESTATUSRECORD  (
		  ID SMALLINT NOT NULL DEFAULT 1,
		  COMPONENT INT NOT NULL DEFAULT 0, 
		  SUBCOMPONENT VARCHAR(1024),
		  STATUS INT NOT NULL DEFAULT 0,  
		  TOTAL BIGINT NOT NULL DEFAULT 0 , 
		  PROCESSED BIGINT NOT NULL DEFAULT 0 , 
		  PERCENTAGE BIGINT NOT NULL DEFAULT 0,   
		  CONFIGFILE IMAGE,
		  COMPONENTINFO IMAGE );

CREATE TABLE __DBSCHEMA__.UPGRADEEXCEPTIONS (
		  BSRURI VARCHAR(1024) NOT NULL,
		  EXCEPTIONTIME datetime NOT NULL,
		  SEVERITY INT NOT NULL DEFAULT 0, 
		  COMPONENT INT NOT NULL DEFAULT 0, 
		  SUBCOMPONENT VARCHAR(1024),
		  UPGRADEEXCEPTION IMAGE );
		
CREATE TABLE __DBSCHEMA__.UPGRADEOBJECTHISTORY (
		  BSRURI VARCHAR(1024) NOT NULL,
		  STATUSTIME datetime NOT NULL,
		  STATUS VARCHAR(1024) NOT NULL );
		
CREATE TABLE __DBSCHEMA__.UPGRADEOBJECTSTATUS (
		  BSRURI VARCHAR(1024) NOT NULL,
		  STATUSTIME datetime NOT NULL,
		  STATUS VARCHAR(1024) NOT NULL );

CREATE TABLE __DBSCHEMA__.UPGRADECOMPONENTS (
		  COMPONENT INT NOT NULL DEFAULT 0, 
		  SUBCOMPONENT VARCHAR(1024),
		  STARTTIME datetime NOT NULL,
		  ENDTIME datetime,
		  DURATION BIGINT NOT NULL DEFAULT 0, 
		  TOTAL BIGINT NOT NULL DEFAULT 0 );

GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.UPGRADESTATUSRECORD TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.UPGRADEEXCEPTIONS TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.UPGRADEOBJECTHISTORY TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.UPGRADEOBJECTSTATUS TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.UPGRADECOMPONENTS TO __DBUSER__;

GO -- remove this line if running through JDBC

CREATE TABLE __DBSCHEMA__.VERIFY ( VERIFY NVARCHAR(60) );
GRANT SELECT,INSERT,DELETE ON __DBSCHEMA__.VERIFY TO __DBUSER__;

GO -- remove this line if running through JDBC

-- CRE Tables
CREATE TABLE __DBSCHEMA__.CRE_LARGE_CDATA (
    ID BIGINT NOT NULL IDENTITY, 
    DATA TEXT, 
    PRIMARY KEY (ID)
);
CREATE TABLE __DBSCHEMA__.CRE_PAGE (
    ID VARCHAR(254) NOT NULL, 
    PRIMARY KEY (ID)
);
CREATE TABLE __DBSCHEMA__.CRE_STATE_ITEM (
    ID BIGINT NOT NULL IDENTITY, 
    LOCALE VARCHAR(254), 
    LOCALIZED_VALUE VARCHAR(1000), 
    NAME VARCHAR(254), 
    READ_ONLY BIT, 
    VALUE VARCHAR(1000), 
    STATE_SET_ID VARCHAR(254) NOT NULL, 
    LOCALIZED_VALUE_DATA_ID BIGINT, 
    VALUE_DATA_ID BIGINT, 
    PRIMARY KEY (ID)
);
CREATE INDEX I_STT_ITM_LOCALIZE ON __DBSCHEMA__.CRE_STATE_ITEM
    (LOCALIZED_VALUE_DATA_ID ASC);
CREATE INDEX I_STT_ITM_STATESET ON __DBSCHEMA__.CRE_STATE_ITEM
    (STATE_SET_ID ASC);
CREATE INDEX I_STT_ITM_VALUEDAT ON __DBSCHEMA__.CRE_STATE_ITEM
    (VALUE_DATA_ID ASC);

CREATE TABLE __DBSCHEMA__.CRE_STATE_SET (
	ID VARCHAR(254) NOT NULL, 
	DEFINITION_URL VARCHAR(1000), 
	LAST_CONFIG_UPDATED DATETIME, 
	IS_MODE VARCHAR(254), 
	NAME VARCHAR(254), 
	USERNAME VARCHAR(254) NOT NULL, 
	WIDGET_ID VARCHAR(254) NOT NULL, 
	PRIMARY KEY (ID), 
	CONSTRAINT U_CR_S_ST_USERNAME UNIQUE (USERNAME, WIDGET_ID)
);

CREATE INDEX I_STATESET ON __DBSCHEMA__.CRE_STATE_SET
	(IS_MODE, NAME);
	
CREATE TABLE __DBSCHEMA__.CRE_WIDGET_INSTANCE (
    ID VARCHAR(254) NOT NULL, 
    DEFINITION_URL VARCHAR(1000), 
    WIDGET_TYPE VARCHAR(254), 
    DOCUMENT_ID VARCHAR(254), 
    HASHED_DOMAIN BIT, 
    PARENT_ID VARCHAR(254), 
    DOM_PLACEMENT VARCHAR(254), 
    RENDER_TYPE VARCHAR(254), 
    PAGE_ID VARCHAR(254) NOT NULL, 
    PRIMARY KEY (ID)
);
CREATE INDEX I_WDGTTNC_PAGE ON __DBSCHEMA__.CRE_WIDGET_INSTANCE
    (PAGE_ID ASC);
    
CREATE TABLE __DBSCHEMA__.CRE_WIDGET_INSTANCE_CRE_WIRE (
    WIDGETINSTANCE_ID VARCHAR(254), 
    WIRES_ID BIGINT
);
CREATE INDEX I_WDGT_WR_ELEMENT ON __DBSCHEMA__.CRE_WIDGET_INSTANCE_CRE_WIRE
    (WIRES_ID ASC);
CREATE INDEX I_WDGT_WR_WIDGETIN ON __DBSCHEMA__.CRE_WIDGET_INSTANCE_CRE_WIRE
    (WIDGETINSTANCE_ID ASC);
    
CREATE TABLE __DBSCHEMA__.CRE_WIRE (
    ID BIGINT NOT NULL IDENTITY, 
    SOURCE_EVENT VARCHAR(254), 
    SOURCE_WIDGET VARCHAR(254), 
    TARGET_EVENT VARCHAR(254), 
    TARGET_WIDGET VARCHAR(254), 
    WIDGET_ID VARCHAR(254) NOT NULL, 
    PRIMARY KEY (ID)
);
CREATE INDEX I_WIRE_WIDGETINSTA ON __DBSCHEMA__.CRE_WIRE
    (WIDGET_ID ASC);
CREATE INDEX I_WIRE_SOURCEWID ON __DBSCHEMA__.CRE_WIRE
    (SOURCE_WIDGET ASC);
CREATE INDEX I_WIRE_TARGETWID ON __DBSCHEMA__.CRE_WIRE
    (TARGET_WIDGET ASC);
    
GO -- remove this line if running through JDBC
    
ALTER TABLE __DBSCHEMA__.CRE_STATE_ITEM ADD FOREIGN KEY (STATE_SET_ID) REFERENCES __DBSCHEMA__.CRE_STATE_SET (ID);
ALTER TABLE __DBSCHEMA__.CRE_STATE_ITEM ADD FOREIGN KEY (LOCALIZED_VALUE_DATA_ID) REFERENCES __DBSCHEMA__.CRE_LARGE_CDATA (ID);
ALTER TABLE __DBSCHEMA__.CRE_STATE_ITEM ADD FOREIGN KEY (VALUE_DATA_ID) REFERENCES __DBSCHEMA__.CRE_LARGE_CDATA (ID);
ALTER TABLE __DBSCHEMA__.CRE_WIDGET_INSTANCE ADD FOREIGN KEY (PAGE_ID) REFERENCES __DBSCHEMA__.CRE_PAGE (ID);
ALTER TABLE __DBSCHEMA__.CRE_WIDGET_INSTANCE_CRE_WIRE ADD FOREIGN KEY (WIDGETINSTANCE_ID) REFERENCES __DBSCHEMA__.CRE_WIDGET_INSTANCE (ID);
ALTER TABLE __DBSCHEMA__.CRE_WIDGET_INSTANCE_CRE_WIRE ADD FOREIGN KEY (WIRES_ID) REFERENCES __DBSCHEMA__.CRE_WIRE (ID);
ALTER TABLE __DBSCHEMA__.CRE_WIRE ADD FOREIGN KEY (WIDGET_ID) REFERENCES __DBSCHEMA__.CRE_WIDGET_INSTANCE (ID);
ALTER TABLE __DBSCHEMA__.CRE_STATE_SET ADD FOREIGN KEY (WIDGET_ID) REFERENCES __DBSCHEMA__.CRE_WIDGET_INSTANCE (ID);

GO -- remove this line if running through JDBC

GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.CRE_LARGE_CDATA TO __DBUSER__; 
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.CRE_PAGE TO __DBUSER__; 
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.CRE_STATE_ITEM TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.CRE_STATE_SET TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.CRE_WIDGET_INSTANCE TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.CRE_WIDGET_INSTANCE_CRE_WIRE TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.CRE_WIRE TO __DBUSER__;

GO -- remove this line if running through JDBC

-- UI Persistence Store
CREATE TABLE __DBSCHEMA__.UIUSER (
    HASH BIGINT NOT NULL IDENTITY PRIMARY KEY,
    NAME VARCHAR(768), 
    LASTVIEWEDPAGE VARCHAR(64), 
    LASTVIEWEDVIEW VARCHAR(64), 
    ISGROUP SMALLINT,
    NOWELCOME SMALLINT,
	CONSTRAINT BOOL1 CHECK(ISGROUP IN (0, 1, 2)),
	CONSTRAINT BOOL2 CHECK(NOWELCOME IN (0, 1)),
	CONSTRAINT NAME_ISGRP UNIQUE (NAME, ISGROUP)
);

CREATE TABLE __DBSCHEMA__.UISTATUSFLAG (
    NAME VARCHAR(64) NOT NULL, 
    STATUS VARCHAR(1000), 
    PRIMARY KEY (NAME)
);

INSERT INTO __DBSCHEMA__.UISTATUSFLAG VALUES ('READONLY','0');
INSERT INTO __DBSCHEMA__.UISTATUSFLAG VALUES ('SHOWWELCOME','0');

CREATE INDEX USF_VIEW ON __DBSCHEMA__.UISTATUSFLAG
	(NAME);
	
CREATE TABLE __DBSCHEMA__.UIUSERSTORAGE (
	USERNAME VARCHAR(768) NOT NULL,
	USERDATA TEXT,
	PRIMARY KEY (USERNAME)
);

CREATE TABLE __DBSCHEMA__.USERVIEWPERM (
    USER_ID BIGINT NOT NULL, 
    VIEW_ID VARCHAR(64) NOT NULL, 
    EDIT SMALLINT, 
    PRIMARY KEY (USER_ID, VIEW_ID),
    CONSTRAINT BOOL3 CHECK(EDIT IN (0, 1))
);

CREATE INDEX UV_VIEW ON __DBSCHEMA__.USERVIEWPERM
    (VIEW_ID, USER_ID);
    
GO -- remove this line if running through JDBC

ALTER TABLE __DBSCHEMA__.USERVIEWPERM ADD FOREIGN KEY (USER_ID) REFERENCES __DBSCHEMA__.UIUSER (HASH) ON DELETE CASCADE;

GO -- remove this line if running through JDBC

CREATE TABLE __DBSCHEMA__.DEFAULTPERM (
    USER_ID BIGINT NOT NULL, 
    EDIT SMALLINT, 
    PRIMARY KEY (USER_ID),
    CONSTRAINT BOOL4 CHECK(EDIT IN (0, 1))
);

CREATE INDEX DEF_VIEW ON __DBSCHEMA__.DEFAULTPERM
    (USER_ID);

GO -- remove this line if running through JDBC

ALTER TABLE __DBSCHEMA__.DEFAULTPERM ADD FOREIGN KEY (USER_ID) REFERENCES __DBSCHEMA__.UIUSER (HASH) ON DELETE CASCADE;

GO -- remove this line if running through JDBC

INSERT INTO __DBSCHEMA__.UIUSER (NAME, LASTVIEWEDVIEW, LASTVIEWEDPAGE, ISGROUP, NOWELCOME) VALUES('ALL_AUTHENTICATED','','',1, 0);

GO -- remove this line if running through JDBC

INSERT INTO __DBSCHEMA__.DEFAULTPERM SELECT MAX(HASH),0 FROM __DBSCHEMA__.UIUSER;

GO -- remove this line if running through JDBC

INSERT INTO __DBSCHEMA__.UIUSER (NAME, LASTVIEWEDVIEW, LASTVIEWEDPAGE, ISGROUP, NOWELCOME) VALUES('WSRRAdmin','','',2, 0);

GO -- remove this line if running through JDBC

INSERT INTO __DBSCHEMA__.DEFAULTPERM SELECT MAX(HASH),1 FROM __DBSCHEMA__.UIUSER;

GO -- remove this line if running through JDBC

CREATE VIEW __DBSCHEMA__.USERVIEWPERM_VW AS
	SELECT perm.USER_ID as USER_ID, users.NAME AS NAME, perm.VIEW_ID AS VIEW_ID, perm.EDIT AS EDIT, users.ISGROUP as ISGROUP
	FROM __DBSCHEMA__.USERVIEWPERM perm
	INNER JOIN __DBSCHEMA__.UIUSER users
	ON perm.USER_ID = users.HASH;
	
GO -- remove this line if running through JDBC

CREATE VIEW __DBSCHEMA__.DEFAULTPERM_VW AS
	SELECT perm.USER_ID as USER_ID, users.NAME AS NAME, perm.EDIT AS EDIT, users.ISGROUP as ISGROUP
	FROM __DBSCHEMA__.DEFAULTPERM perm
	INNER JOIN __DBSCHEMA__.UIUSER users
	ON perm.USER_ID = users.HASH;

GO -- remove this line if running through JDBC

GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.UIUSER          TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.USERVIEWPERM    TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.DEFAULTPERM     TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.UISTATUSFLAG    TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.UIUSERSTORAGE   TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.USERVIEWPERM_VW TO __DBUSER__;
GRANT SELECT,INSERT,UPDATE,DELETE ON __DBSCHEMA__.DEFAULTPERM_VW  TO __DBUSER__;

GO -- remove this line if running through JDBC