@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for Sales Order'

@UI:{
headerInfo:{
typeName: 'Sales Order',
typeNamePlural: 'Sales Orders',
title:{type: #STANDARD,value: 'so_id'}
    }
}

@ObjectModel:{semanticKey: ['so_id'],representativeKey: 'so_id'}

define root view entity ZI_SO_HEADER
  as select from ztso_hdr as hdr
  composition [0..*] of zi_so_items as _item
{
      @UI.facet: [
              {
              id:'GeneralData',
              type: #COLLECTION,
              position: 10,
              label: 'Sales Order Header'
              },
              {
               type:#FIELDGROUP_REFERENCE,
               position: 10,
               targetQualifier: 'GeneralData1',
               parentId: 'GeneralData',
               isSummary: true,
               isPartOfPreview: true
              },
              {
               type:#FIELDGROUP_REFERENCE,
               position: 20,
               targetQualifier: 'GeneralData2',
               parentId: 'GeneralData',
               isSummary: true,
               isPartOfPreview: true
               },
               {
                id:'Item',
                purpose: #STANDARD,
                type: #LINEITEM_REFERENCE,
                label: 'Sales Order Item',
                position: 10,
                targetElement: '_item'
               }
           ]

      @UI:{
        lineItem: [{position: 10,importance: #HIGH,label: 'Sales Order#' }],
        selectionField: [{position: 10 }],
        fieldGroup: [{qualifier: 'GeneralData1',position: 10,importance: #HIGH }]
      }
      @EndUserText:{label: 'Sales Order'}
  key hdr.so_id,

      @UI:{
        lineItem: [{position: 20,importance: #HIGH,label: 'Sales Org' }],
        selectionField: [{position: 20 }],
        fieldGroup: [{qualifier: 'GeneralData1',position: 20,importance: #HIGH }]
      }
      @EndUserText:{label: 'Sales Org'}
      hdr.sales_org,

      @UI:{
        lineItem: [{position: 30,importance: #HIGH,label: 'Division' }],
        fieldGroup: [{qualifier: 'GeneralData1',position: 30,importance: #HIGH }]
      }
      @EndUserText:{label: 'Division'}
      hdr.div,

      @UI:{
        lineItem: [{position: 40,importance: #HIGH,label: 'Dist. Channel' }],
        fieldGroup: [{qualifier: 'GeneralData1',position: 40,importance: #HIGH }]
      }
      @EndUserText:{label: 'Dist. Channel'}
      hdr.dist_ch,

      @Semantics.user.createdBy: true
      hdr.created_by,      
  
      @Semantics.systemDateTime.createdAt: true      
      hdr.created_dt,
      
      _item // Make association public
}