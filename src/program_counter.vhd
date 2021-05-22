library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity program_counter is
port(	D: in std_logic_vector(15 downto 0);
		Resetn, Clock, E, L: in std_logic;
		Q: out std_logic_vector(15 downto 0));
end program_counter;

architecture behavior of program_counter is
	signal Count: std_logic_vector(15 downto 0);
begin
	process(Clock)
	begin
		if (Clock'event and Clock = '1') then
			if (Resetn = '0') then
				Count <= (others => '0');
			elsif (L = '1') then
				Count <= D;
			elsif (E = '1') then
				Count <= Count + 1;
			end if;
		end if;
	end process;
	Q <= Count;
end behavior;