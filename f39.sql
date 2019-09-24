select 
('['+hlt_LPUDoctor.PCOD+']'+hlt_LPUDoctor.FAM_V+' '+left (hlt_LPUDoctor.IM_V,1)+'. '+left(hlt_LPUDoctor.OT_V,1)+'.') as 'fiovr_codvr',
count (hlt_SMTAP.SMTAPID)																						 as 'all_cnt',
sum (
case when oms_smo.TEL not like '8-3812%' 
			and hlt_mkab.rf_smoid<>0 
	then 1 
	else 0 
	end
	)																												as 'selo_cnt',
sum (
case when datediff(mm, hlt_mkab.date_bd, getdate())<=204
	then 1
	else 0
	end
	)																												as '<17',
sum (																												
case when datediff(mm, hlt_mkab.date_bd, getdate())>=720
	then 1
	else 0
	end
	)																												as '>60',
sum (
case when oms_kl_ReasonType.CODE=3.0--Обращение по заболеванию
		and oms_kl_ReasonType.CODE=1.0--Посещение по заболеванию
		and oms_kl_VisitPlace.Code=1--Поликлиника 
	then 1 
	else 0 
	end
	)																												as 'cnt_zab_pol',
sum (
case when datediff(mm, hlt_mkab.date_bd, getdate())<=204
		and oms_kl_ReasonType.CODE=3.0--Обращение по заболеванию
		and oms_kl_ReasonType.CODE=1.0--Посещение по заболеванию
		and oms_kl_VisitPlace.Code=1--Поликлиника 
	then 1
	else 0
	end
	)																												as 'cnt_zab_<17_pol',
sum (
case when datediff(mm, hlt_mkab.date_bd, getdate())>=720
		and oms_kl_ReasonType.CODE=3.0--Обращение по заболеванию
		and oms_kl_ReasonType.CODE=1.0--Посещение по заболеванию
		and oms_kl_VisitPlace.Code=1--Поликлиника 
	then 1
	else 0
	end
	)																												as 'cnt_zab_>60_pol',
sum (
case when oms_kl_ReasonType.CODE=2.6--Посещение по другим обстоятельствам
		and oms_kl_VisitPlace.Code=1--Поликлиника 
	then 1 
	else 0 
	end
	)																												as 'cnt_prof',
sum (
case when oms_kl_ReasonType.CODE=2.6--Посещение по другим обстоятельствам
		and oms_kl_VisitPlace.Code=1--Поликлиника 
	then 1 
	else 0 
	end
	)																																																																								
from hlt_tap
left join hlt_mkab					on hlt_TAP.rf_MKABID=hlt_MKAB.MKABID
left join oms_kl_ProfitType			on hlt_TAP.rf_kl_ProfitTypeID=oms_kl_ProfitType.kl_ProfitTypeID
left join oms_SMO					on hlt_MKAB.rf_SMOID=oms_smo.SMOID
inner join hlt_SMTAP				on hlt_TAP.TAPID=hlt_SMTAP.rf_TAPID
left join hlt_LPUDoctor				on hlt_SMTAP.rf_LPUDoctorID=hlt_LPUDoctor.LPUDoctorID
left join oms_kl_ReasonType			on hlt_tap.rf_kl_ReasonTypeID=oms_kl_ReasonType.kl_ReasonTypeID
left join oms_kl_VisitPlace			on hlt_tap.rf_kl_VisitPlaceID=oms_kl_VisitPlace.kl_VisitPlaceID
where 1=1
and hlt_tap.DateClose >= convert (date, '01.09.2019')
and hlt_tap.DateClose <= convert (date, '30.09.2019')
and hlt_tap.IsClosed = 1  
and oms_kl_profittype.CODE=1
group by ('['+hlt_LPUDoctor.PCOD+']'+hlt_LPUDoctor.FAM_V+' '+left (hlt_LPUDoctor.IM_V,1)+'. '+left(hlt_LPUDoctor.OT_V,1)+'.')


--select * from oms_kl_ReasonType
--select * from oms_kl_VisitPlace
--select * from oms_kl_ProfitType
