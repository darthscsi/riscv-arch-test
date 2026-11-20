    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    // cp_custom_ofp8_edges_bf16
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Edge values of the BF16 source converted to OFP8, in both OFP8 formats (vtype.altfmt=0 is E4M3, 1 is E5M2)
    cp_custom_ofp8_edges_bf16_frm : coverpoint get_csr_field(ins.hart, ins.issue, `SAMPLE_BEFORE, CSR_FCSR, "frm")  iff (ins.trap == 0 )  {
        bins rne = {3'b000};
        bins rtz = {3'b001};
        bins rdn = {3'b010};
        bins rup = {3'b011};
        bins rmm = {3'b100};
    }

    cp_custom_ofp8_edges_bf16_e4m3 : coverpoint get_vr_element_zero_widen(ins.hart, ins.issue, ins.current.vs2_val)[15:0]  iff (ins.trap == 0 && get_csr_field(ins.hart, ins.issue, `SAMPLE_BEFORE, CSR_VTYPE, "altfmt") == 0)  {
        bins pos0                       = {16'h0000};
        bins neg0                       = {16'h8000};
        bins pos1                       = {16'h3F80};
        bins neg1                       = {16'hBF80};
        bins posinfinity                = {16'h7F80};
        bins neginfinity                = {16'hFF80};
        bins canonicalQNaN              = {16'h7FC0};
        bins sNaN                       = {16'h7F81};
        bins max_finite                 = {16'h43E0};
        bins neg_max_finite             = {16'hC3E0};
        bins below_overflow_tie         = {16'h43E7};
        bins overflow_tie               = {16'h43E8};
        bins neg_overflow_tie           = {16'hC3E8};
        bins above_overflow_tie         = {16'h43E9};
        bins overflow                   = {16'h4460};
        bins neg_overflow               = {16'hC460};
        bins source_max                 = {16'h7F7F};
        bins onePhalfulp                = {16'h3F88};
        bins onePulpPhalfulp            = {16'h3F98};
        bins neg_onePhalfulpPlsb        = {16'hBF89};
        bins min_norm                   = {16'h3C80};
        bins tininess_tie               = {16'h3C78};
        bins below_tininess_tie         = {16'h3C77};
        bins min_subnorm                = {16'h3B00};
        bins half_min_subnorm           = {16'h3A80};
        bins above_half_min_subnorm     = {16'h3A81};
        bins neg_above_half_min_subnorm = {16'hBA81};
        bins source_min_subnorm         = {16'h0001};
    }

    cp_custom_ofp8_edges_bf16_e4m3_cross : cross std_vec, cp_custom_ofp8_edges_bf16_e4m3, cp_custom_ofp8_edges_bf16_frm;

    cp_custom_ofp8_edges_bf16_e5m2 : coverpoint get_vr_element_zero_widen(ins.hart, ins.issue, ins.current.vs2_val)[15:0]  iff (ins.trap == 0 && get_csr_field(ins.hart, ins.issue, `SAMPLE_BEFORE, CSR_VTYPE, "altfmt") == 1)  {
        bins pos0                       = {16'h0000};
        bins neg0                       = {16'h8000};
        bins pos1                       = {16'h3F80};
        bins neg1                       = {16'hBF80};
        bins posinfinity                = {16'h7F80};
        bins neginfinity                = {16'hFF80};
        bins canonicalQNaN              = {16'h7FC0};
        bins sNaN                       = {16'h7F81};
        bins max_finite                 = {16'h4760};
        bins neg_max_finite             = {16'hC760};
        bins below_overflow_tie         = {16'h476F};
        bins overflow_tie               = {16'h4770};
        bins neg_overflow_tie           = {16'hC770};
        bins above_overflow_tie         = {16'h4771};
        bins overflow                   = {16'h47E0};
        bins neg_overflow               = {16'hC7E0};
        bins source_max                 = {16'h7F7F};
        bins onePhalfulp                = {16'h3F90};
        bins onePulpPhalfulp            = {16'h3FB0};
        bins neg_onePhalfulpPlsb        = {16'hBF91};
        bins min_norm                   = {16'h3880};
        bins tininess_tie               = {16'h3870};
        bins below_tininess_tie         = {16'h386F};
        bins min_subnorm                = {16'h3780};
        bins half_min_subnorm           = {16'h3700};
        bins above_half_min_subnorm     = {16'h3701};
        bins neg_above_half_min_subnorm = {16'hB701};
        bins source_min_subnorm         = {16'h0001};
    }

    cp_custom_ofp8_edges_bf16_e5m2_cross : cross std_vec, cp_custom_ofp8_edges_bf16_e5m2, cp_custom_ofp8_edges_bf16_frm;

//// end cp_custom_ofp8_edges_bf16 ////////////////////////////////////////////////////////////////////////////////
