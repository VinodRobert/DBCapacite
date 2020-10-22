/****** Object:  View [dbo].[bs_EDSETS_EDS_VALUES]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW dbo.bs_EDSETS_EDS_VALUES
AS
SELECT     NTM.edshid, ISNULL(NTM.edsvalue, 0) AS NTM, ISNULL(OT1.edsvalue, 0) AS OT1, ISNULL(OT2.edsvalue, 0) AS OT2, ISNULL(OT3.edsvalue, 0) AS OT3, 
                      ISNULL(OT4.edsvalue, 0) AS OT4, ISNULL(OT5.edsvalue, 0) AS OT5
FROM         (SELECT     edshid, edsvalue
                       FROM          edsets
                       WHERE      edscode = 'NTM') NTM LEFT OUTER JOIN
                          (SELECT     edshid, edsvalue
                            FROM          edsets
                            WHERE      edscode = 'OT1') OT1 ON NTM.edshid = OT1.edshid LEFT OUTER JOIN
                          (SELECT     edshid, edsvalue
                            FROM          edsets
                            WHERE      edscode = 'OT2') OT2 ON NTM.edshid = OT2.edshid LEFT OUTER JOIN
                          (SELECT     edshid, edsvalue
                            FROM          edsets
                            WHERE      edscode = 'OT3') OT3 ON NTM.edshid = OT3.edshid LEFT OUTER JOIN
                          (SELECT     edshid, edsvalue
                            FROM          edsets
                            WHERE      edscode = 'OT4') OT4 ON NTM.edshid = OT4.edshid LEFT OUTER JOIN
                          (SELECT     edshid, edsvalue
                            FROM          edsets
                            WHERE      edscode = 'OT5') OT5 ON NTM.edshid = OT5.edshid