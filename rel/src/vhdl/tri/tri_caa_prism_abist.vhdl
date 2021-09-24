-- © IBM Corp. 2020
-- Licensed under the Apache License, Version 2.0 (the "License"), as modified by
-- the terms below; you may not use the files in this repository except in
-- compliance with the License as modified.
-- You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
--
-- Modified Terms:
--
--    1) For the purpose of the patent license granted to you in Section 3 of the
--    License, the "Work" hereby includes implementations of the work of authorship
--    in physical form.
--
--    2) Notwithstanding any terms to the contrary in the License, any licenses
--    necessary for implementation of the Work that are available from OpenPOWER
--    via the Power ISA End User License Agreement (EULA) are explicitly excluded
--    hereunder, and may be obtained from OpenPOWER under the terms and conditions
--    of the EULA.  
--
-- Unless required by applicable law or agreed to in writing, the reference design
-- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
-- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License
-- for the specific language governing permissions and limitations under the License.
-- 
-- Additional rights, including the ability to physically implement a softcore that
-- is compliant with the required sections of the Power ISA Specification, are
-- available at no cost under the terms of the OpenPOWER Power ISA EULA, which can be
-- obtained (along with the Power ISA) here: https://openpowerfoundation.org. 

--
--  Description: A2 Core ABIST Engine
--
library ieee, ibm;
use ieee.std_logic_1164.all;
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_function_support.all;
library support;
USE support.power_logic_pkg.all;
library tri;
use tri.tri_latches_pkg.all;


entity tri_caa_prism_abist is
generic(expand_type     : integer := 1 );    -- 0=ibm (Umbra), 1=non-ibm, 2=ibm (CDP)
Port   (vdd                             : INOUT power_logic;
        gnd                             : INOUT power_logic;
        nclk                            : In    clk_logic;
        scan_dis_dc_b                   : In    std_ulogic;
        lcb_clkoff_dc_b                 : In    std_ulogic;
        lcb_mpw1_dc_b                   : In    std_ulogic;
        lcb_mpw2_dc_b                   : In    std_ulogic;
        lcb_delay_lclkr_dc              : In    std_ulogic;
        lcb_delay_lclkr_np_dc           : In    std_ulogic;
        lcb_act_dis_dc                  : In    std_ulogic;
        lcb_d_mode_dc                   : In    std_ulogic;
        gptr_thold                      : In    std_ulogic;
        gptr_scan_in                    : In    std_ulogic;
        gptr_scan_out                   : Out   std_ulogic;
        abist_thold                     : In    std_ulogic;
        abist_sg                        : In    std_ulogic;
        abist_scan_in                   : In    std_ulogic;
        abist_scan_out                  : Out   std_ulogic;
        -- LBIST + ABIST Engine Controls
        abist_done_in_dc                : In    std_ulogic;
        abist_done_out_dc               : Out   std_ulogic;
        abist_mode_dc                   : In    std_ulogic;
        abist_start_test                : In    std_ulogic;
        lbist_mode_dc                   : In    std_ulogic;
        lbist_ac_mode_dc                : In    std_ulogic;
        -- ABIST Outputs
        abist_waddr_0                   : Out   std_ulogic_vector(0 to 9);
        abist_waddr_1                   : Out   std_ulogic_vector(0 to 9);
        abist_grf_wenb_0                : Out   std_ulogic;      
        abist_grf_wenb_1                : Out   std_ulogic;      
        abist_raddr_0                   : Out   std_ulogic_vector(0 to 9);
        abist_raddr_1                   : Out   std_ulogic_vector(0 to 9);
        abist_grf_renb_0                : Out   std_ulogic;
        abist_grf_renb_1                : Out   std_ulogic;
        abist_g8t_wenb                  : Out   std_ulogic;
        abist_g8t1p_renb_0              : Out   std_ulogic;
        abist_g6t_r_wb                  : Out   std_ulogic;
        abist_di_g6t_2r                 : Out   std_ulogic_vector(0 to 3);
        abist_di_0                      : Out   std_ulogic_vector(0 to 3);
        abist_di_1                      : Out   std_ulogic_vector(0 to 3);
        abist_dcomp                     : Out   std_ulogic_vector(0 to 3);
        abist_dcomp_g6t_2r              : Out   std_ulogic_vector(0 to 3);
        abist_bw_0                      : Out   std_ulogic;
        abist_bw_1                      : Out   std_ulogic;
        abist_wl32_g8t_comp_ena         : Out   std_ulogic;
        abist_wl64_g8t_comp_ena         : Out   std_ulogic;
        abist_wl128_g8t_comp_ena        : Out   std_ulogic;
        abist_wl144_comp_ena            : Out   std_ulogic;
        abist_wl256_comp_ena            : Out   std_ulogic;
        abist_wl512_comp_ena            : Out   std_ulogic;
        abist_ena_dc                    : Out   std_ulogic;
        abist_raw_dc_b                  : Out   std_ulogic
);

-- synopsys translate_off




-- synopsys translate_on
end entity tri_caa_prism_abist;

architecture tri_caa_prism_abist of tri_caa_prism_abist is

signal unused             : std_ulogic;
-- synopsys translate_off
-- synopsys translate_on

begin

        gptr_scan_out                   <= '0';
        abist_scan_out                  <= '0';
        abist_done_out_dc               <= '0';
        abist_waddr_0                   <= "0000000000";
        abist_waddr_1                   <= "0000000000";
        abist_grf_wenb_0                <= '0';      
        abist_grf_wenb_1                <= '0';      
        abist_raddr_0                   <= "0000000000";
        abist_raddr_1                   <= "0000000000";
        abist_grf_renb_0                <= '0';
        abist_grf_renb_1                <= '0';
        abist_g8t_wenb                  <= '0';
        abist_g8t1p_renb_0              <= '0';
        abist_g6t_r_wb                  <= '0';
        abist_di_g6t_2r                 <= "0000";
        abist_di_0                      <= "0000";
        abist_di_1                      <= "0000";
        abist_dcomp                     <= "0000";
        abist_dcomp_g6t_2r              <= "0000";
        abist_bw_0                      <= '0';
        abist_bw_1                      <= '0';
        abist_wl32_g8t_comp_ena         <= '0';
        abist_wl64_g8t_comp_ena         <= '0';
        abist_wl128_g8t_comp_ena        <= '0';
        abist_wl144_comp_ena            <= '0';
        abist_wl256_comp_ena            <= '0';
        abist_wl512_comp_ena            <= '0';
        abist_ena_dc                    <= '0';
        abist_raw_dc_b                  <= '0';

        unused <= or_reduce(scan_dis_dc_b & lcb_clkoff_dc_b & lcb_mpw1_dc_b & lcb_mpw2_dc_b &
                            lcb_delay_lclkr_dc & lcb_delay_lclkr_np_dc & lcb_act_dis_dc & lcb_d_mode_dc &
                            gptr_thold & gptr_scan_in & abist_thold & abist_sg & abist_scan_in &
                            abist_done_in_dc & abist_mode_dc & abist_start_test &
                            lbist_mode_dc & lbist_ac_mode_dc );

end tri_caa_prism_abist;
