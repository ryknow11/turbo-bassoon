select
'
    <ExternalKey>31000454451</ExternalKey>
    <DocDate>2017-04-03</DocDate>
    <RestrictnInternalKey>'|| AACM.ID ||'</RestrictnInternalKey>
    <DocType>'|| D.METAOBJECTNAME ||'</DocType>
    <RestrictionAnswerType>3</RestrictionAnswerType>
    <IpInternalKey>'|| D.PARENT_ID ||'</IpInternalKey>
    <DeloNum>'|| i_ip.IP_DOC_NUMBER ||'</DeloNum>
    <AuthorName>'|| coalesce(MVV.bank_name, '') ||'</AuthorName>
    <AuthorBIK>'|| coalesce(MVV.bic_bank, '') ||'</AuthorBIK>
    <ORGN>'|| coalesce (MVV.bank_orgn, '') ||'</ORGN>
    <INN>'|| coalesce(MVV.bank_inn, '') ||'</INN>
    <KPP>'|| coalesce(MVV.bank_kpp, '') ||'</KPP>
    <DetMvvAccountDatum>
		<MvvAccountDatum>
			<Acc>'|| MVV.acc ||'</Acc>
			<CurrencyCode>'|| MVV.currency_code ||'</CurrencyCode>
			<AccountKindCode>02</AccountKindCode>
			<ArrestAmount>'|| MVVDA.summa ||'</ArrestAmount>
			<ArrestAmountRub>'|| coalesce(MVVDA.summa_rub, MVVDA.summa, '') ||'</ArrestAmountRub>
			<ArrestRecoveryState>7</ArrestRecoveryState>
		</MvvAccountDatum>
    </DetMvvAccountDatum>
'
from document D join O_IP_ACT_ARREST_ACCMONEY AACM
on D.id = AACM.id
join doc_ip_doc IP
on D.parent_id = IP.ID
join i_ip
on D.parent_id = i_ip.ip_id
join datum_link_oip DLIOP
on D.id = DLIOP.doc_id
join MVV_DATUM_ACCOUNT MVV
on MVV.id = DLIOP.datum_id
join MVV_DATUM_AVAILABILITY_ACC MVVDA
on MVVDA.id = DLIOP.datum_id
where AACM.id = 28281009265263

