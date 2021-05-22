library ieee;
use ieee.std_logic_1164.all;

entity cw8_de2 is
port(
SW: in std_logic_vector(17 downto 0);
KEY: in std_logic_vector(3 downto 0);
LEDR: out std_logic_vector(17 downto 0);
LEDG: out std_logic_vector(7 downto 0);
HEX7, HEX6, HEX5, HEX4: out std_logic_vector(6 downto 0);
HEX3, HEX2, HEX1, HEX0: out std_logic_vector(6 downto 0));
end cw8_de2;

architecture first of cw8_de2 is
component proc1 is
	port (DIN : in std_logic_vector(15 downto 0);
			Resetn, Clock, Run : in std_logic;
			Done : buffer std_logic;
			BusWires : buffer std_logic_vector(15 downto 0);
			ADDR : out std_logic_vector(15 downto 0));
end component;
signal ADDR: std_logic_vector(15 downto 0);
component transcoder_hex is
port(
a: in std_logic_vector(3 downto 0);
en: in std_logic;
h: out std_logic_vector(6 downto 0));
end component;
begin
proc: proc1 port map (SW(15 downto 0), KEY(1), SW(16), SW(17), LEDR(17), LEDR(15 downto 0), ADDR);
transcoder0: transcoder_hex port map (ADDR(3 downto 0), '1', HEX0);
transcoder1: transcoder_hex port map (ADDR(7 downto 4), '1', HEX1);
transcoder2: transcoder_hex port map (ADDR(11 downto 8), '1', HEX2);
transcoder3: transcoder_hex port map (ADDR(15 downto 12), '1', HEX3);
HEX4 <= (others=>'1');
HEX5 <= (others=>'1');
HEX6 <= (others=>'1');
HEX7 <= (others=>'1');


end first;

