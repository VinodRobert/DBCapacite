/****** Object:  View [dbo].[REPORT_DEF]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[REPORT_DEF] 
AS 
SELECT TOP 100 PERCENT cfg.Id, BORGS.BORGID, ISNULL(REPORT_LINK.RepOrg, cfg.OrgId) AS configorgid, cfg.Report, config.RepDesc,    
  headpic.logo AS headpic, 
  CASE WHEN headpic.logo is null then cast(0 as bit) else config.HeadPic_ON end as HeadPic_ON, 
  config.HeadText, 
  config.HeadText_LCRN, config.HeadText_bold, config.HeadText_uline, config.HeadText_size, 
  orgpicL.logo AS orgpicL, 
  CASE WHEN orgpicL.logo is null then cast(0 as bit) else config.OrgPicL_ON end as OrgPicL_ON, 
  orgpicR.logo AS orgpicR, 
  CASE WHEN orgpicR.logo is null then cast(0 as bit) else config.OrgPicR_ON end as OrgPicR_ON, 
  config.Org_LCRN, 
  config.StatPic_ON, 
  config.TaxColumn_ON, 
  config.TaxTotal_ON, config.WordMoney_ON, config.BankDetails_ON, config.FootText_bold, config.FootText_uline, config.FootText_size, 
  footpic.LOGO AS footpic, 
  case when footpic.LOGO is null then cast(0 as bit) else config.FootPic_ON end as FootPic_ON, 
  config.FootText_LCRN, config.FootText, config.Allocation_ON, config.Statement_detail, config.opt1_ON, 
  config.opt2_ON, config.opt3_ON, config.opt4_ON, config.opt5_ON, config.opt6_ON, config.opt7_ON, config.opt8_ON, config.opt9_ON, config.opt10_ON, config.opt11_ON, config.opt12_ON, 
  config.opt_ShowRegON, config.HeadTitle,  config.ShowProforma_ON, config.ShowVatPercent_ON, config.RcmRemoveFromTotal_ON, config.RcmMessage,
  config.WHTSHOW, config.WHTTEXT
FROM REPORT_CONFIG AS cfg 
  LEFT OUTER JOIN BORGS ON BORGS.BORGID = cfg.OrgId OR cfg.OrgId = 0 
  LEFT OUTER JOIN REPORT_LINK ON BORGS.BORGID = REPORT_LINK.OrgId AND cfg.Report = REPORT_LINK.Report 
  LEFT OUTER JOIN REPORT_CONFIG AS config ON ISNULL(REPORT_LINK.RepOrg, cfg.OrgId) = config.OrgId 
  LEFT OUTER JOIN LOGOS AS orgpicL ON isnull(REPORT_LINK.OrgPicLLogo, config.OrgPicLLogo) = orgpicL.NAME 
  LEFT OUTER JOIN LOGOS AS orgpicR ON isnull(REPORT_LINK.OrgPicRLogo, config.OrgPicRLogo) = orgpicR.NAME 
  LEFT OUTER JOIN LOGOS AS headpic ON isnull(REPORT_LINK.HeadPicLogo, config.HeadPicLogo) = headpic.NAME 
  LEFT OUTER JOIN LOGOS AS footpic ON config.FootPicLogo = footpic.NAME 
WHERE cfg.Id = ISNULL(config.Id, -1) 
OR (config.OrgId = ISNULL(REPORT_LINK.RepOrg, -1) AND config.Report = cfg.Report) 
ORDER BY cfg.Report, BORGS.BORGID, configorgid DESC
		