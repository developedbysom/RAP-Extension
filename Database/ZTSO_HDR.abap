@EndUserText.label : 'Sales Order Header Tbale'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #ALLOWED
define table ZTSO_HDR {
  key client : mandt not null;
  key so_id  : abap.numc(6) not null;
  sales_org  : abap.numc(4);
  div        : abap.numc(2);
  dist_ch    : abap.numc(2);
  created_by : syuname;
  created_dt : timestampl;
}