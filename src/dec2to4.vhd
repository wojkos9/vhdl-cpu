LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY dec2to4 IS
PORT ( W : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
En : IN STD_LOGIC;
Y : OUT STD_LOGIC_VECTOR(0 TO 3));
END dec2to4;

ARCHITECTURE Behavior OF dec2to4 IS
BEGIN
 PROCESS (W, En)
 BEGIN
 IF En = '1' THEN
 CASE W IS
 WHEN "00" => Y <= "1000";
 WHEN "01" => Y <= "0100";
 WHEN "10" => Y <= "0010";
 WHEN "11" => Y <= "0001";
 END CASE;
 ELSE
 Y <= "0000";
 END IF;
 END PROCESS;
END Behavior;