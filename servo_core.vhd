library ieee;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity servo_core is
	port(
	clk		: in std_logic;
	sw			: in std_logic_vector(2 downto 0);
	degree_in: in std_logic_vector(7 downto 0);
	pwm_out	: out std_logic
	);
end servo_core;

architecture behavioral of servo_core is
	signal derajat			: INTEGER;
	signal count_180khz	: INTEGER:=0;
	signal count_PWM		: INTEGER:=0;
	signal clk_180khz		: std_logic:='0';
	signal pwm_reg			: std_logic:='0'; 
begin

--derajat<=0;
derajat<=50  when sw<="000" else
			60  when sw<="001" else
			70  when sw<="010" else
			80  when sw<="011" else
			90  when sw<="100" else
			100  when sw<="101" else
			180  when sw<="110" else
			0;
			

clk_div_180kHz:process(clk) begin
						if(rising_edge(clk))then
							if(count_180khz=139)then
								clk_180khz 		<= NOT(clk_180khz);
								count_180khz	<= 0;
							else
								count_180khz	<= count_180khz+1;
							end if;
						end if;
					end process;

servo_ctrl:		process(clk_180khz) begin
						if(rising_edge(clk_180khz))then
							if(count_pwm=3601)then
								pwm_reg		<= '1';
								count_pwm	<= 0;
							elsif(count_pwm<181+derajat)then
								pwm_reg		<='1';
								count_pwm	<=count_pwm+1;
							elsif(count_pwm=181+derajat)then
								pwm_reg		<='0';
								count_pwm	<=count_pwm+1;
							else
								count_pwm	<=count_pwm+1;
							end if;
						end if;
					end process;

					pwm_out<=pwm_reg;

end behavioral;