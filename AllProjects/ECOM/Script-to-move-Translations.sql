-- This script moves translations from QA to prod,
-- To move translations from DEV to QA change "@ecom_qa" as "@ecom_dev"

-- Run below connected as SUP_WEB

-- Change the appcode as needed

DELETE FROM MESSAGE_TRNSLN /*Non-English translation*/
WHERE message_id IN (SELECT message_id
                     FROM MESSAGE_ID_XREF
                     WHERE appcode IN ('SDA'));
 
DELETE FROM MESSAGE /*English translation*/
WHERE message_id IN (SELECT message_id
                     FROM MESSAGE_ID_XREF
                     WHERE appcode IN ('SDA'));
 
DELETE FROM MESSAGE_ID_XREF /*MNEMONICS */
WHERE appcode IN ('SDA');
 
COMMIT;
 
INSERT INTO MESSAGE_ID_XREF
SELECT * FROM MESSAGE_ID_XREF@ecom_qa
WHERE appcode IN ('SDA');
 
INSERT INTO MESSAGE
SELECT * FROM MESSAGE@ecom_qa
WHERE message_id IN (SELECT message_id 
                     FROM MESSAGE_ID_XREF@ecom_qa
                     WHERE appcode IN ('SDA'));
 
INSERT INTO MESSAGE_TRNSLN
SELECT * FROM MESSAGE_TRNSLN@ecom_qa
WHERE message_id IN (SELECT message_id
                     FROM MESSAGE_ID_XREF@ecom_qa
                     WHERE appcode IN ('SDA')) ;

COMMIT;

