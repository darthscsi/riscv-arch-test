    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    // cp_custom_ofp8_edges_f32
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    // Edge values of the binary32 source converted to OFP8, in both OFP8 formats (vtype.altfmt=0 is E4M3, 1 is E5M2)
    cp_custom_ofp8_edges_f32_frm : coverpoint get_csr_field(ins.hart, ins.issue, `SAMPLE_BEFORE, CSR_FCSR, "frm")  iff (ins.trap == 0 )  {
        bins rne = {3'b000};
        bins rtz = {3'b001};
        bins rdn = {3'b010};
        bins rup = {3'b011};
        bins rmm = {3'b100};
    }

    cp_custom_ofp8_edges_f32_e4m3 : coverpoint get_vr_element_zero_eew(ins.hart, ins.issue, ins.current.vs2_val, 32)[31:0]  iff (ins.trap == 0 && get_csr_field(ins.hart, ins.issue, `SAMPLE_BEFORE, CSR_VTYPE, "altfmt") == 0)  {
        bins pos0                       = {32'h00000000};
        bins neg0                       = {32'h80000000};
        bins pos1                       = {32'h3F800000};
        bins neg1                       = {32'hBF800000};
        bins posinfinity                = {32'h7F800000};
        bins neginfinity                = {32'hFF800000};
        bins canonicalQNaN              = {32'h7FC00000};
        bins sNaN                       = {32'h7F800001};
        bins max_finite                 = {32'h43E00000};
        bins neg_max_finite             = {32'hC3E00000};
        bins below_overflow_tie         = {32'h43E7FFFF};
        bins overflow_tie               = {32'h43E80000};
        bins neg_overflow_tie           = {32'hC3E80000};
        bins above_overflow_tie         = {32'h43E80001};
        bins overflow                   = {32'h44600000};
        bins neg_overflow               = {32'hC4600000};
        bins source_max                 = {32'h7F7FFFFF};
        bins onePhalfulp                = {32'h3F880000};
        bins onePulpPhalfulp            = {32'h3F980000};
        bins neg_onePhalfulpPlsb        = {32'hBF880001};
        bins min_norm                   = {32'h3C800000};
        bins tininess_tie               = {32'h3C780000};
        bins below_tininess_tie         = {32'h3C77FFFF};
        bins min_subnorm                = {32'h3B000000};
        bins half_min_subnorm           = {32'h3A800000};
        bins above_half_min_subnorm     = {32'h3A800001};
        bins neg_above_half_min_subnorm = {32'hBA800001};
        bins source_min_subnorm         = {32'h00000001};
    }

    cp_custom_ofp8_edges_f32_e4m3_cross : cross std_vec, cp_custom_ofp8_edges_f32_e4m3, cp_custom_ofp8_edges_f32_frm;

    cp_custom_ofp8_edges_f32_e5m2 : coverpoint get_vr_element_zero_eew(ins.hart, ins.issue, ins.current.vs2_val, 32)[31:0]  iff (ins.trap == 0 && get_csr_field(ins.hart, ins.issue, `SAMPLE_BEFORE, CSR_VTYPE, "altfmt") == 1)  {
        bins pos0                       = {32'h00000000};
        bins neg0                       = {32'h80000000};
        bins pos1                       = {32'h3F800000};
        bins neg1                       = {32'hBF800000};
        bins posinfinity                = {32'h7F800000};
        bins neginfinity                = {32'hFF800000};
        bins canonicalQNaN              = {32'h7FC00000};
        bins sNaN                       = {32'h7F800001};
        bins max_finite                 = {32'h47600000};
        bins neg_max_finite             = {32'hC7600000};
        bins below_overflow_tie         = {32'h476FFFFF};
        bins overflow_tie               = {32'h47700000};
        bins neg_overflow_tie           = {32'hC7700000};
        bins above_overflow_tie         = {32'h47700001};
        bins overflow                   = {32'h47E00000};
        bins neg_overflow               = {32'hC7E00000};
        bins source_max                 = {32'h7F7FFFFF};
        bins onePhalfulp                = {32'h3F900000};
        bins onePulpPhalfulp            = {32'h3FB00000};
        bins neg_onePhalfulpPlsb        = {32'hBF900001};
        bins min_norm                   = {32'h38800000};
        bins tininess_tie               = {32'h38700000};
        bins below_tininess_tie         = {32'h386FFFFF};
        bins min_subnorm                = {32'h37800000};
        bins half_min_subnorm           = {32'h37000000};
        bins above_half_min_subnorm     = {32'h37000001};
        bins neg_above_half_min_subnorm = {32'hB7000001};
        bins source_min_subnorm         = {32'h00000001};
    }

    cp_custom_ofp8_edges_f32_e5m2_cross : cross std_vec, cp_custom_ofp8_edges_f32_e5m2, cp_custom_ofp8_edges_f32_frm;

//// end cp_custom_ofp8_edges_f32 ////////////////////////////////////////////////////////////////////////////////
