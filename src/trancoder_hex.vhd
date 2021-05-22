library ieee;
use ieee.std_logic_1164.all;

entity transcoder_hex is
port(
a: in std_logic_vector(3 downto 0);
en: in std_logic;
h: out std_logic_vector(6 downto 0));
end transcoder_hex;

architecture strukturalna of transcoder_hex is
begin
process(en) begin
	if en='0' then
		h <= "1111111";
	else
		case a is
			when "0000"=> h<="1000000";
			when "0001"=> h<="1111001";
			when "0010"=> h<="0100100";
			when "0011"=> h<="0110000";
			when "0100"=> h<="0011001";
			when "0101"=> h<="0010010";
			when "0110"=> h<="0000010";
			when "0111"=> h<="1111000";
			when "1000"=> h<="0000000";
			when "1001"=> h<="0010000";
			when "1010"=> h<="0001000";
			when "1011"=> h<="0000011";
			when "1100"=> h<="1000110";
			when "1101"=> h<="0100001";
	      when "1110"=> h<="0000110";
			when "1111"=> h<="0001110";
		end case;
	end if;
end process;		
			
end strukturalna;