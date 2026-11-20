    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    // cp_custom_ofp8_edges_widen
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Edge values of the OFP8 source converted to BF16, in both OFP8 formats (vtype.altfmt=0 is E4M3, 1 is E5M2)
    cp_custom_ofp8_edges_widen_e4m3 : coverpoint get_vr_element_zero(ins.hart, ins.issue, ins.current.vs2_val)[7:0]  iff (ins.trap == 0 && get_csr_field(ins.hart, ins.issue, `SAMPLE_BEFORE, CSR_VTYPE, "altfmt") == 0)  {
        bins pos0           = {8'h00};
        bins neg0           = {8'h80};
        bins min_subnorm    = {8'h01};
        bins max_subnorm    = {8'h07};
        bins min_norm       = {8'h08};
        bins pos1           = {8'h38};
        bins neg1           = {8'hB8};
        bins onePulp        = {8'h39};
        bins max_finite     = {8'h7E};
        bins neg_max_finite = {8'hFE};
        bins NaN            = {8'h7F};
        bins negNaN         = {8'hFF};
    }

    cp_custom_ofp8_edges_widen_e4m3_cross : cross std_vec, cp_custom_ofp8_edges_widen_e4m3;

    cp_custom_ofp8_edges_widen_e5m2 : coverpoint get_vr_element_zero(ins.hart, ins.issue, ins.current.vs2_val)[7:0]  iff (ins.trap == 0 && get_csr_field(ins.hart, ins.issue, `SAMPLE_BEFORE, CSR_VTYPE, "altfmt") == 1)  {
        bins pos0           = {8'h00};
        bins neg0           = {8'h80};
        bins min_subnorm    = {8'h01};
        bins max_subnorm    = {8'h03};
        bins min_norm       = {8'h04};
        bins pos1           = {8'h3C};
        bins neg1           = {8'hBC};
        bins onePulp        = {8'h3D};
        bins max_finite     = {8'h7B};
        bins neg_max_finite = {8'hFB};
        bins posinfinity    = {8'h7C};
        bins neginfinity    = {8'hFC};
        bins sNaN           = {8'h7D};
        bins qNaN           = {8'h7E};
        bins negNaN         = {8'hFF};
    }

    cp_custom_ofp8_edges_widen_e5m2_cross : cross std_vec, cp_custom_ofp8_edges_widen_e5m2;

//// end cp_custom_ofp8_edges_widen ////////////////////////////////////////////////////////////////////////////////
