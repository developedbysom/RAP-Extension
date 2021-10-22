CLASS zcl_ce_get_products DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .

    TYPES t_product_range TYPE RANGE OF zzce_so_sepmra_i_product_e-Product.
    TYPES t_business_data TYPE STANDARD TABLE OF zzce_so_sepmra_i_product_e. "zz_so_products.

    METHODS get_products
      IMPORTING
        it_filter_cond   TYPE if_rap_query_filter=>tt_name_range_pairs   OPTIONAL
        top              TYPE i OPTIONAL
        skip             TYPE i OPTIONAL
      EXPORTING
        et_business_data TYPE  t_business_data
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS zcl_ce_products IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_business_data TYPE TABLE OF zzce_so_sepmra_i_product_e.
    DATA lt_filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
    DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .
    ranges_table = VALUE #( (  sign = 'I' option = 'GT' low = 'HT-1200' ) ).
    lt_filter_conditions = VALUE #( ( name = 'PRODUCT'  range = ranges_table ) ).

    TRY.
        me->get_products(
          EXPORTING
            it_filter_cond   = lt_filter_conditions
            top              = 3
            skip             = 1
          IMPORTING
            et_business_data = lt_business_data
        ).
        out->write( lt_business_data ).

      CATCH cx_root INTO DATA(exception).
        out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_products.

    DATA: lt_business_data TYPE TABLE OF zzce_so_sepmra_i_product_e,
          lo_http_client   TYPE REF TO if_web_http_client,
          lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
          lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
          lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA: lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
          lo_filter_node      TYPE REF TO /iwbep/if_cp_filter_node,
          lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node.



    TRY.

        " Create http client
        " Details depend on your connection settings

*        DATA(lo_destination) = cl_http_destination_provider=>create_by_cloud_destination(
*          i_name       = 'NORTHWIND'
*          i_authn_mode = if_a4c_cp_service=>service_specific ).

        DATA(lo_destination) = cl_http_destination_provider=>create_by_url(
          i_url = 'https://sapes5.sapdevcenter.com' ).


        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination
          ).

        lo_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
          EXPORTING
            iv_service_definition_name = 'ZSC_ES5_PRODUCTS'
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/ZPDCDS_SRV/' ).


        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'SEPMRA_I_PRODUCT_E' )->create_request_for_read( ).


        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).

        LOOP AT it_filter_cond ASSIGNING FIELD-SYMBOL(<lfs_cond>).
          lo_filter_node = lo_filter_factory->create_by_range( iv_property_path = <lfs_cond>-name
                                                               it_range         = <lfs_cond>-range ).
          IF lo_filter_node_root IS INITIAL.
            lo_filter_node_root = lo_filter_node.
          ELSE.
            lo_filter_node_root = lo_filter_node_root->and( lo_filter_node ).
          ENDIF.
        ENDLOOP.


        IF lo_filter_node_root IS NOT INITIAL.
          lo_request->set_filter( lo_filter_node_root ).
        ENDIF.

        IF top > 0.
          lo_request->set_top( top ).
        ENDIF.

        lo_request->set_skip( skip ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).

        lo_response->get_business_data( IMPORTING et_business_data = et_business_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

     CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

    ENDTRY.
  ENDMETHOD.

  METHOD if_rap_query_provider~select.

    DATA business_data TYPE TABLE OF zzce_so_sepmra_i_product_e.
    DATA(top)     = io_request->get_paging( )->get_page_size( ).
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).

    TRY.
        DATA(filter_condition) = io_request->get_filter( )->get_as_ranges( ).

        get_products(
          EXPORTING
            it_filter_cond   = filter_condition
            top              = CONV i( top )
            skip             = CONV i( skip )
          IMPORTING
            et_business_data = business_data
        ).
        io_response->set_total_number_of_records( lines( business_data ) ).
        io_response->set_data( business_data ).

      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception(
                            exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.