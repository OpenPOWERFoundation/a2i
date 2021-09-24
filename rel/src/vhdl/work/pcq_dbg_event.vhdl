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
--  Description: Pervasive Core Event Bus Mux
--
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
library support;
use support.power_logic_pkg.all;
library tri;
use tri.tri_latches_pkg.all;

entity pcq_dbg_event is
generic(expand_type        : integer := 2  -- 0 = ibm (Umbra), 1 = non-ibm, 2 = ibm (MPG)
);
port(
    vd                     : inout power_logic;
    gd                     : inout power_logic;
    event_mux_ctrls        : in    std_ulogic_vector(0 to 23);
    fu_event_data          : in    std_ulogic_vector(0 to 7);
    iu_event_data          : in    std_ulogic_vector(0 to 7);
    mm_event_data          : in    std_ulogic_vector(0 to 7);
    xu_event_data          : in    std_ulogic_vector(0 to 7);
    lsu_event_data         : in    std_ulogic_vector(0 to 7);
    trace_bus_data         : in    std_ulogic_vector(0 to 7);
    --------------------------------------------------------
    event_bus              : out   std_ulogic_vector(0 to 7)
);
-- synopsys translate_off

-- synopsys translate_on
end pcq_dbg_event;

architecture pcq_dbg_event of pcq_dbg_event is
--=====================================================================
-- Signal Declarations
--=====================================================================
-- Event Mux Signals
signal event_signals_per_bit            : std_ulogic_vector(0 to 7);


begin


--=====================================================================
-- Event Bus Mux Logic
--=====================================================================
  with event_mux_ctrls(0 to 2)   select  -- CESR(40:42)
      event_signals_per_bit(0) <= xu_event_data(0)      when "000",
                                  iu_event_data(0)      when "001",
                                  fu_event_data(0)      when "010",
                                  mm_event_data(0)      when "011",
                                  lsu_event_data(0)     when "100",
                                  xu_event_data(4)      when "101",
                                  iu_event_data(4)      when "110",
                                  trace_bus_data(0)     when others;

  with event_mux_ctrls(3 to 5)   select  -- CESR(43:45)
      event_signals_per_bit(1) <= xu_event_data(1)      when "000",
                                  iu_event_data(1)      when "001",
                                  fu_event_data(1)      when "010",
                                  mm_event_data(1)      when "011",
                                  lsu_event_data(1)     when "100",
                                  xu_event_data(5)      when "101",
                                  iu_event_data(5)      when "110",
                                  trace_bus_data(1)     when others;

  with event_mux_ctrls(6 to 8)   select  -- CESR(46:48)
      event_signals_per_bit(2) <= xu_event_data(2)      when "000",
                                  iu_event_data(2)      when "001",
                                  fu_event_data(2)      when "010",
                                  mm_event_data(2)      when "011",
                                  lsu_event_data(2)     when "100",
                                  xu_event_data(6)      when "101",
                                  iu_event_data(6)      when "110",
                                  trace_bus_data(2)     when others;

  with event_mux_ctrls(9 to 11)  select  -- CESR(49:51)
      event_signals_per_bit(3) <= xu_event_data(3)      when "000",
                                  iu_event_data(3)      when "001",
                                  fu_event_data(3)      when "010",
                                  mm_event_data(3)      when "011",
                                  lsu_event_data(3)     when "100",
                                  xu_event_data(7)      when "101",
                                  iu_event_data(7)      when "110",
                                  trace_bus_data(3)     when others;

  with event_mux_ctrls(12 to 14) select  -- CESR(52:54)
      event_signals_per_bit(4) <= xu_event_data(4)      when "000",
                                  iu_event_data(4)      when "001",
                                  fu_event_data(4)      when "010",
                                  mm_event_data(4)      when "011",
                                  lsu_event_data(4)     when "100",
                                  xu_event_data(0)      when "101",
                                  iu_event_data(0)      when "110",
                                  trace_bus_data(4)     when others;

  with event_mux_ctrls(15 to 17) select  -- CESR(55:57)
      event_signals_per_bit(5) <= xu_event_data(5)      when "000",
                                  iu_event_data(5)      when "001",
                                  fu_event_data(5)      when "010",
                                  mm_event_data(5)      when "011",
                                  lsu_event_data(5)     when "100",
                                  xu_event_data(1)      when "101",
                                  iu_event_data(1)      when "110",
                                  trace_bus_data(5)     when others;

  with event_mux_ctrls(18 to 20) select  -- CESR(58:60)
      event_signals_per_bit(6) <= xu_event_data(6)      when "000",
                                  iu_event_data(6)      when "001",
                                  fu_event_data(6)      when "010",
                                  mm_event_data(6)      when "011",
                                  lsu_event_data(6)     when "100",
                                  xu_event_data(2)      when "101",
                                  iu_event_data(2)      when "110",
                                  trace_bus_data(6)     when others;

  with event_mux_ctrls(21 to 23) select  -- CESR(61:63)
      event_signals_per_bit(7) <= xu_event_data(7)      when "000",
                                  iu_event_data(7)      when "001",
                                  fu_event_data(7)      when "010",
                                  mm_event_data(7)      when "011",
                                  lsu_event_data(7)     when "100",
                                  xu_event_data(3)      when "101",
                                  iu_event_data(3)      when "110",
                                  trace_bus_data(7)     when others;


--=====================================================================
-- Outputs
--=====================================================================
  event_bus(0 to 7)  <=  event_signals_per_bit(0 to 7);


-----------------------------------------------------------------------
end pcq_dbg_event;
