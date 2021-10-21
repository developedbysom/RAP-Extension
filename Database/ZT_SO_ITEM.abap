@EndUserText.label : 'Sales Order Item Table'
@AbapCatalog.enhancement.category : #NOT_EXTENSIBLE
@AbapCatalog.tableCategory : #TRANSPARENT
@AbapCatalog.deliveryClass : #A
@AbapCatalog.dataMaintenance : #ALLOWED
define table zt_so_item {
  key client    : mandt not null;
  key so_id     : abap.numc(6) not null;
  key so_item   : abap.numc(2) not null;
  material      : abap.char(40);
  category   : abap.char(100);
  suppilier     : abap.char(10);
  @Semantics.quantity.unitOfMeasure : 'zt_so_item.unit'
  qty           : abap.quan(5,0);
  unit          : abap.unit(3);
  @Semantics.amount.currencyCode : 'zt_so_item.currency_code'
  price         : abap.curr(16,2);
  currency_code : abap.cuky;

}