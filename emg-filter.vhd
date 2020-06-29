LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;
USE IEEE.Std_logic_signed.ALL;
-- Butterwort Bandpass FIR filter for EMG Denoising
   
ENTITY EMG_RI IS 
     GENERIC (
          input_width : INTEGER := 8;-- set input width by user  
          output_width : INTEGER := 16;-- set output width by user  
          coef_width : INTEGER := 8;-- set coefficient width by user  
          tap : INTEGER := 11;-- set filter order  
          guard : INTEGER := 0);-- log2(tap)+1  
     PORT (
          Din : IN std_logic_vector(input_width - 1 DOWNTO 0);-- input data  
          Clk : IN std_logic;-- input clk  
          reset : IN std_logic;-- input reset  
          Dout : OUT std_logic_vector(output_width - 1 DOWNTO 0));-- output data  
END EMG_RI;
ARCHITECTURE behavioral OF EMG_RI IS
     COMPONENT N_bit_Reg
          GENERIC (
               input_width : INTEGER := 8
          );
          PORT (
               Q : OUT std_logic_vector(input_width - 1 DOWNTO 0);
               Clk : IN std_logic;
               reset : IN std_logic;
               D : IN std_logic_vector(input_width - 1 DOWNTO 0)
          );
     END COMPONENT;
     TYPE Coeficient_type IS ARRAY (1 TO tap) OF std_logic_vector(coef_width - 1 DOWNTO 0);
     -----------------------------------Butterworth filter coefficients----------------------------------------------------------------  
     CONSTANT coeficient : coeficient_type := (X"29", X"00", X"85", X"00", X"7B", X"00", X"D7");
     ----------------------------------------------------------------------------------------------                                     
     TYPE shift_reg_type IS ARRAY (0 TO tap - 1) OF std_logic_vector(input_width - 1 DOWNTO 0);
     SIGNAL shift_reg : shift_reg_type;
     TYPE mult_type IS ARRAY (0 TO tap - 1) OF std_logic_vector(input_width + coef_width - 1 DOWNTO 0);
     SIGNAL mult : mult_type;
     TYPE ADD_type IS ARRAY (0 TO tap - 1) OF std_logic_vector(input_width + coef_width - 1 DOWNTO 0);
     SIGNAL ADD : ADD_type;
BEGIN
     shift_reg(0) <= Din;
     mult(0) <= Din * coeficient(1);
     ADD(0) <= Din * coeficient(1);
     GEN_FIR :
     FOR i IN 0 TO tap - 2 GENERATE
     BEGIN
          -- N-bit reg unit  
          N_bit_Reg_unit : N_bit_Reg GENERIC MAP(input_width => 8)
          PORT MAP(
               Clk => Clk,
               reset => reset,
               D => shift_reg(i),
               Q => shift_reg(i + 1)
          );
          -- filter multiplication  
          mult(i + 1) <= shift_reg(i + 1) * coeficient(i + 2);
          -- filter conbinational addition  
          ADD(i + 1) <= ADD(i) + mult(i + 1);
     END GENERATE GEN_FIR;
     Dout <= ADD(tap - 1);
END ARCHITECTURE;

LIBRARY IEEE;
USE IEEE.Std_logic_1164.ALL;

-- N-bit Register in VHDL 
ENTITY N_bit_Reg IS
     GENERIC (
          input_width : INTEGER := 8
     );
     PORT (
          Q : OUT std_logic_vector(input_width - 1 DOWNTO 0);
          Clk : IN std_logic;
          reset : IN std_logic;
          D : IN std_logic_vector(input_width - 1 DOWNTO 0)
     );
END N_bit_Reg;
ARCHITECTURE Behavioral OF N_bit_Reg IS
BEGIN
     PROCESS (Clk, reset)
     BEGIN
          IF (reset = '1') THEN
               Q <= (OTHERS => '0');
          ELSIF (rising_edge(Clk)) THEN
               Q <= D;
          END IF;
     END PROCESS;
END Behavioral;