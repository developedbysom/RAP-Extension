managed ; // implementation in class zbp_i_so_header unique;
//strict;

define behavior for ZI_SO_HEADER //alias <alias_name>
persistent table ZTSO_HDR
lock master
//authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  association _item { create; }
}

define behavior for zi_so_items //alias <alias_name>
persistent table ZTSO_ITEM
lock dependent by _hdr
//authorization dependent by _hdr
//etag master <field_name>
{
  update;
  delete;
  field ( readonly ) so_id;
  association _hdr;
}