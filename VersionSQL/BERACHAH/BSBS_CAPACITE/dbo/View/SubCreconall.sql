/****** Object:  View [dbo].[SubCreconall]    Committed by VersionSQL https://www.versionsql.com ******/

 


CREATE VIEW dbo.SubCreconall
AS
SELECT OrgID [Org ID]
	,SC.SubNumber [Subcontractor Code]
	,C.CONTRNUMBER [Contract Number]
	,C.CONTRNAME [Contract Name]
	,A.ActNumber [Activity]
	,A.ActName [Activty Name]
	,ValNo [Valuation Number]
	,Certno [Certificate Number]
	,ContValue [Contract Value]
	,WorkDoneTot [Work Done Total]
	,WorkDonePrev [Work Done Previous]
	,WorkDoneThisMonth [Work Done Current]
	,EscalationTot [Escalation Total]
	,EscalationPrev [Escalation Previous]
	,EscalationThisMonth [Escalation Current]
	,MOSTot [Materials On Site]
	,MOSPrev [Materials On Site Previous]
	,MOSThisMonth [Materials On Site Current]
	,AdditionalTot [Additional Total]
	,AdditionalPrev [Additional Previous]
	,AdditionalThisMonth [Additional Current]
	,BFWDTot [Brought Forward Total]
	,BFWDPrev [Brought Forward Previous]
	,BFWDThisMonth [Brought Forward Current]
	,VATTot [VAT Total]
	,VATPrev [VAT Previous]
	,VATThisMonth [VAT Current]
	,DiscountTot [Discount Total]
	,DiscountPrev [Discount Previous]
	,DiscountThisMonth [Discount Current]
	,AdvancePerc [Advance %]
	,AdvanceTot [Advance Total]
	,AdvancePrev [Advance Previous]
	,AdvanceThisMonth [Advance Current]
	,RetentionTot [Retention Total]
	,RetentionPrev [Retention Previous]
	,RetentionThisMonth [Retention Current]
	,ContraTot [Contra Total]
	,ContraPrev [Contra Previous]
	,ContraThisMonth [Contra Current]
	,WithholdTot [WHT Total]
	,WithholdPrev [WHT Previous]
	,WithholdThisMonth [WHT Current]
	,WithholdPerc [WHT %]
	,AmountDue [Amount Due]
	,PrevPaid [Previously Paid]
	,TotDue [Total Due]
	,VATPerc [VAT Percentage]
	,VATAmount [VAT Amount]
	,Paid [Paid]
	,Disc [Discount %]
	,case when Posted=0 then 'Unposted' else 'Posted' end [Posting Status]
	,Remark 
	,RetPerc [Retention %]
	,PostDate [Last Post Date]
	,PostRef [Posting Reference]
	,Orderno [Order Number]
	,Ledger [GL Ledger Code]
	,exchrate [Exchange Rate Used]
	,currency [Currency]
	,ContraAlloc [Contra Allocation]
	,WCATOT [WCA Total]
	,WCATHISMONTH [WCA Current]
	,WCAPREV [WCA Previous]
	,UIFTOT [UIF Total]
	,UIFTHISMONTH [UIF Current]
	,UIFPREV [UIF Previous]
	,SDLPERC [SDL %]
	,SDLTOT [SDL Total]
	,SDLTHISMONTH [SDL Current]
	,SDLPREV [SDL Previous]
	,UIFPERC [UIF %]
	,WCAPERC [WCA %]
	,case when SELFINVOICE=0 then 'As per Subie Master' else case when SELFINVOICE=1 then 'Yes' else 'No' end end [Self Invoicing Status]
	,PACKAGE [Package Number]
	,RETRELEASEDATE [Retention Release Date]
FROM SUBCRECONS SR
left outer join CONTRACTS C on C.CONTRID=SR.contract
left outer join ACTIVITIES A on A.ActID=SR.Activity
left outer join Subcontractors SC on SC.SubID=SR.SUBConNumber
where LPosted=0
--========================================
--Insert the function into the UDR tables
--========================================