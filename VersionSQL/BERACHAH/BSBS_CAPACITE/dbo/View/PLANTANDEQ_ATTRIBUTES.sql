/****** Object:  View [dbo].[PLANTANDEQ_ATTRIBUTES]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW PLANTANDEQ_ATTRIBUTES AS SELECT PLANTANDEQ.* , A26.VALUE [Attribute.DPR Entry], A27.VALUE [Attribute.LOC] FROM PLANTANDEQ  LEFT OUTER JOIN ATTRIBVALUE A26 on A26.TABLENAME = 'PLANTANDEQ' and A26.ATTRIBUTE = 'DPR Entry' and A26.COLKEY = PLANTANDEQ.PENUMBER and A26.ARRAYINDEX = 0 LEFT OUTER JOIN ATTRIBVALUE A27 on A27.TABLENAME = 'PLANTANDEQ' and A27.ATTRIBUTE = 'LOC' and A27.COLKEY = PLANTANDEQ.PENUMBER and A27.ARRAYINDEX = 0