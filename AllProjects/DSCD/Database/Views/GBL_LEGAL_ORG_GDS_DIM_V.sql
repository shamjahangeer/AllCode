create or replace view scd.gbl_legal_org_gds_dim_v as
select GLODDL_ORG_ID org_id, GLODDL_ORG_LEVEL_CODE org_level_code,
GLODDL_DD1_ORG_ID dd1_org_id, b1.glo_alternate_name dd1_org_alternate_name,
GLODDL_DD2_ORG_ID dd2_org_id, b2.glo_alternate_name dd2_org_alternate_name,
GLODDL_DD3_ORG_ID dd3_org_id, b3.glo_alternate_name dd3_org_alternate_name,
GLODDL_DD4_ORG_ID dd4_org_id, b4.glo_alternate_name dd4_org_alternate_name,
GLODDL_DD5_ORG_ID dd5_org_id, b5.glo_alternate_name dd5_org_alternate_name,
GLODDL_DD6_ORG_ID dd6_org_id, b6.glo_alternate_name dd6_org_alternate_name,
GLODDL_DD7_ORG_ID dd7_org_id, b7.glo_alternate_name dd7_org_alternate_name,
GLODDL_DD8_ORG_ID dd8_org_id, b8.glo_alternate_name dd8_org_alternate_name,
GLODDL_DD9_ORG_ID dd9_org_id, b9.glo_alternate_name dd9_org_alternate_name,
GLODDL_DD10_ORG_ID dd10_org_id, b10.glo_alternate_name dd10_org_alternate_name
from gbl_lgl_org_drill_down_layers a,
gbl_legal_orgs b,
gbl_legal_orgs b1,
gbl_legal_orgs b2,
gbl_legal_orgs b3,
gbl_legal_orgs b4,
gbl_legal_orgs b5,
gbl_legal_orgs b6,
gbl_legal_orgs b7,
gbl_legal_orgs b8,
gbl_legal_orgs b9,
gbl_legal_orgs b10
where a.GLODDL_ORG_ID = b.glo_org_id
and a.GLODDL_DD1_ORG_ID = b1.glo_org_id
and a.GLODDL_DD2_ORG_ID = b2.glo_org_id
and a.GLODDL_DD3_ORG_ID = b3.glo_org_id
and a.GLODDL_DD4_ORG_ID = b4.glo_org_id
and a.GLODDL_DD5_ORG_ID = b5.glo_org_id
and a.GLODDL_DD6_ORG_ID = b6.glo_org_id
and a.GLODDL_DD7_ORG_ID = b7.glo_org_id
and a.GLODDL_DD8_ORG_ID = b8.glo_org_id
and a.GLODDL_DD9_ORG_ID = b9.glo_org_id
and a.GLODDL_DD10_ORG_ID = b10.glo_org_id
;
