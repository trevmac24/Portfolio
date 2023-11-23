with cte AS (
	select distinct
		vpt.PERSONNUM,
		vpt.PERSONFULLNAME,
		vpt.INPUNCHDTM,
		vpt.STARTDTM,
		vpt.OUTPUNCHDTM,
		vpt.ENDDTM,
		vpt.LABORLEVELNAME1 as 'Company',
		vpt.LABORLEVELNAME2 as 'Business Unit',
		vpt.LABORLEVELNAME3 as 'Department',
		vpt.LABORLEVELNAME4 as 'Job',
		vpt.LABORLEVELNAME5 as 'Reports to Postion',
		vpt.laborlevelname7 as 'Proj_Act',
		reverse(substring(reverse(vpt.ORGPATHTXT), 1, (charindex('/', reverse(vpt.ORGPATHTXT), 1) - 1))) as 'Org Job',
		case
			when 
			(vpt.PAYCODENAME is null and vpt.STARTDTM is not null
			and vpt.TIMEINSECONDS <> '0'
			and vpt.STARTREASON <> 'paidschedulednewshift' and vpt.ENDREASON <> 'paidScheduledOut') 
			then 'H'
			when
			( STARTREASON = 'paidschedulednewshift' or ENDREASON = 'paidScheduledOut')
			then 'S'
			else 'Z'
		end as [Type],
		vpt.TIMEINSECONDS / 3600.00 as 'Hours'

	from VP_TIMESHTPUNCHV42 vpt

	where vpt.TIMESHEETITEMTYPE = 'totaledspan'
	--and (convert(nvarchar,vpt.ENDDTM,101) >= DATEADD(day, -1, convert(date, GETDATE())))
	and vpt.STARTDTM >= '10/08/2023'
	--and (convert(nvarchar,vpt.ENDDTM,101) < convert(date, GETDATE()))
	and vpt.ENDDTM <= '10/21/2023'
)

Select
	PERSONNUM,
	PERSONFULLNAME,
	convert(nvarchar,STARTDTM,101) as 'In Date',
	case when (cte.[Type] in ('H','Z')) then (convert(nvarchar,INPUNCHDTM,8)) when (cte.[Type] = 'S') then (convert(nvarchar,STARTDTM,8)) end as 'Actual In Punch',
	convert(nvarchar,STARTDTM,8) as 'Rounded In Punch',
	convert(nvarchar,ENDDTM,101) as 'Out Date',
	case when (cte.[Type] in ('H','Z')) then (convert(nvarchar,OUTPUNCHDTM,8)) when (cte.[Type] = 'S') then (convert(nvarchar,ENDDTM,8)) end as 'Actual Out Punch',
	convert(nvarchar,ENDDTM,8)   as 'Rounded Out Punch',
	Company,
	[Business Unit],
	[Department],
	[Job],
	[Reports to Postion],
	[Proj_Act],
	[Org Job],
	cte.[Type],
	[Hours]

from cte