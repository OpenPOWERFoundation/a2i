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

library ieee,ibm,support,tri;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ibm.std_ulogic_function_support.all;
use support.power_logic_pkg.all;
use tri.tri_latches_pkg.all;

entity xuq_cpl_fctr is
generic(
    expand_type                     : integer   := 2;
    threads                         : integer   := 4;
    clockgate                       : integer   range 0 to 1       := 1;
    passthru                        : integer   range 0 to 1       := 1;
    delay_width                     : integer   := 4);
port(
   nclk                             : in  clk_logic;

   forcee : in  std_ulogic;
   thold_b                          : in  std_ulogic;
   sg                               : in  std_ulogic;
   d_mode                           : in  std_ulogic;
   delay_lclkr                      : in  std_ulogic;
   mpw1_b                           : in  std_ulogic;
   mpw2_b                           : in  std_ulogic;

   scin                             : in  std_ulogic;
   scout                            : out std_ulogic;

   din                              : in  std_ulogic_vector(0 to threads-1);
   dout                             : out std_ulogic_vector(0 to threads-1);
   delay                            : in  std_ulogic_vector(0 to delay_width-1);

   vd                               : inout power_logic;
   gd                               : inout power_logic

);

-- synopsys translate_off
-- synopsys translate_on

end xuq_cpl_fctr;
architecture xuq_cpl_fctr of xuq_cpl_fctr is

type DELAY_ARR                                     is array (0 to threads-1) of std_ulogic_vector(0 to delay_width-1);
subtype s2                                         is std_ulogic_vector(0 to 1);
signal delay_q,            delay_d                 : DELAY_ARR;
constant delay_offset                              : integer := 0;
constant scan_right                                : integer := delay_offset                   + delay_q(0)'length*threads;    
signal siv                                         : std_ulogic_vector(0 to scan_right-1);
signal sov                                         : std_ulogic_vector(0 to scan_right-1);
signal set,zero_b,act                              : std_ulogic_vector(0 to threads-1);

begin
   
threads_gen : for t in 0 to threads-1 generate
signal delay_m1                                 : std_ulogic_vector(0 to delay_width-1);
begin

   set(t)            <= din(t);
   zero_b(t)         <= or_reduce(delay_q(t));
   delay_m1          <= std_ulogic_vector(unsigned(delay_q(t)) - 1);

   clockgate_0 : if clockgate = 0 generate
      act(t)            <= '1';

      with s2'(set(t) & zero_b(t)) select
         delay_d(t)     <= delay          when "11",
                           delay          when "10",
                           delay_m1       when "01",
                           delay_q(t)     when others;
   end generate;
   clockgate_1 : if clockgate = 1 generate
      act(t)            <= set(t) or zero_b(t);

      with set(t) select
         delay_d(t)     <= delay          when '1',
                           delay_m1       when others;
   end generate;
   
   passthru_gen_1 : if passthru = 1 generate
      dout(t)           <= zero_b(t) or din(t);
   end generate;
   passthru_gen_0 : if passthru = 0 generate
      dout(t)           <= zero_b(t);
   end generate;

   delay_latch : tri_rlmreg_p
   generic map (width => delay_q(0)'length, init => 0, expand_type => expand_type, needs_sreset => 1)
   port map (nclk    => nclk, vd => vd, gd => gd,
               act     => act(t),
               forcee => forcee,
               d_mode  => d_mode, delay_lclkr => delay_lclkr,
               mpw1_b  => mpw1_b, mpw2_b  => mpw2_b,
               thold_b => thold_b,
               sg      => sg,
               scin    => siv(delay_offset+delay_q(0)'length*t to delay_offset+delay_q(0)'length*(t+1)-1),
               scout   => sov(delay_offset+delay_q(0)'length*t to delay_offset+delay_q(0)'length*(t+1)-1),
               din     => delay_d(t),
               dout    => delay_q(t));

end generate;
 
siv(0 to scan_right-1)           <= sov(1 to scan_right-1) & scin;
scout                            <= sov(0);

end architecture xuq_cpl_fctr;
