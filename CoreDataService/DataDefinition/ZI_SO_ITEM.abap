@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for Sales Order Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable:true

@ObjectModel:{semanticKey: ['so_id', 'so_item']}

define view entity zi_so_item
  as select from zt_so_item as item
  association to parent ZI_SO_HDR as _hdr on $projection.so_id = _hdr.so_id
{

      @UI.facet: [
         {
          type: #COLLECTION,
          position: 10,
          id:'item',
          label: 'Order Item'
       },
       {
          type:#FIELDGROUP_REFERENCE,
          position: 10,
          targetQualifier: 'item1',
          parentId: 'item',
          isSummary: true,
          isPartOfPreview: true
       }]

      @UI:{
          lineItem: [{position: 10,importance: #HIGH,label: 'Sales Order#' }],
          fieldGroup: [{qualifier: 'item1',position: 10,importance: #HIGH }]
            }
      @EndUserText:{label: 'Sales Order'}
  key item.so_id,

      @UI:{
          lineItem: [{position: 20,importance: #HIGH,label: 'Order Item' }],
          fieldGroup: [{qualifier: 'item1',position: 20,importance: #HIGH }]
          }
      @EndUserText:{label: 'Order Item'}
  key item.so_item,

      @UI:{
             lineItem: [{position: 30,importance: #HIGH,label: 'Product' }],
             fieldGroup: [{qualifier: 'item1',position: 30,importance: #HIGH }]
             }
      @EndUserText:{label: 'Product'}

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
        item.material,

      @UI:{
       lineItem: [{position: 40,importance: #HIGH,label: 'Category' }],
       fieldGroup: [{qualifier: 'item1',position: 35,importance: #HIGH }]
       }
      @EndUserText:{label: 'Category'}
        item.category,

      @UI:{
            lineItem: [{position: 45, importance: #HIGH,label: 'Supplier' }],
            fieldGroup: [{qualifier: 'item1',position: 32,importance: #HIGH }]
            }
      @EndUserText:{label: 'Supplier'}
        item.suppilier,

      @UI: {

      lineItem: [ { position: 50, importance: #HIGH ,label: 'Quantity'} ],
        fieldGroup: [{qualifier: 'item1',position: 50,importance: #HIGH }]
      }
      @EndUserText:{label: 'Sales Qty'}
      @Semantics.quantity.unitOfMeasure: 'unit'
         item.qty,

      @Consumption.valueHelpDefinition: [ {
            entity: {
              name: 'I_UnitOfMeasure',
              element: 'UnitOfMeasure'
            }
          } ]
      item.unit,

      @UI: {
      lineItem: [ { position: 60, importance: #HIGH ,label: 'Price'} ],
      fieldGroup: [{qualifier: 'item1',position: 60,importance: #HIGH }]
      }
      @EndUserText:{label: 'Price'}
      @Semantics.amount.currencyCode : 'currency_code'
      item.price,

      @Consumption.valueHelpDefinition: [{
                entity:{
                name:'I_Currency',
                element:'Currency'
                }
             }]
      item.currency_code,
      //Association
      _hdr
}
