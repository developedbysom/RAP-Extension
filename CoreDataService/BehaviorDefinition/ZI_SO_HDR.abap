managed;// implementation in class zbp_i_so_hdr unique;
//strict;

define behavior for ZI_SO_HDR //alias <alias_name>
persistent table ZT_SO_HDR
lock master
//authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  association _item { create; }
}

define behavior for zi_so_item //alias <alias_name>
persistent table ZT_SO_ITEM
lock dependent by _hdr
//authorization dependent by _hdr
//etag master <field_name>
{
  update;
  delete;
  field ( readonly ) so_id;
  association _hdr;
}