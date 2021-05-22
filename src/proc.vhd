library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity proc1 is
	port (DIN : in std_logic_vector(15 downto 0);
			Resetn, Clock, Run : in std_logic;
			Done : buffer std_logic;
			BusWires : buffer std_logic_vector(15 downto 0);
			ADDR : out std_logic_vector(15 downto 0));
end proc1;

architecture behavior of proc1 is

	CONSTANT mv : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	CONSTANT mvi : STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
	CONSTANT add : STD_LOGIC_VECTOR(2 DOWNTO 0) := "010";
	CONSTANT sub : STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
	CONSTANT jmp : STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";

	COMPONENT dec2to4 IS
	PORT ( W : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	En : IN STD_LOGIC;
	Y : OUT STD_LOGIC_VECTOR(0 TO 3));
	END COMPONENT;
	 
	COMPONENT upcount IS
	 PORT ( Clear, Clock : IN STD_LOGIC;
	 Q : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)); 
	END COMPONENT;
	 
	COMPONENT regn IS
	 GENERIC (n : INTEGER := 16);
	 PORT ( R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	 Rin, Clock : IN STD_LOGIC;
	 Q : BUFFER STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT program_counter is
	port(	D: in std_logic_vector(15 downto 0);
			Resetn, Clock, E, L: in std_logic;
			Q: out std_logic_vector(15 downto 0));
	end COMPONENT;


	signal Rin, Rout : std_logic_vector(0 to 3);
	signal Sum : std_logic_vector(15 downto 0);
	signal Clear, High, IRin, DINout, Ain, Gin, Gout, AddSub, ADDRin, pc_inc : std_logic;
	signal Tstep_Q : std_logic_vector(1 downto 0);
	signal I : std_logic_vector(2 downto 0);
	signal Xreg, Yreg : std_logic_vector(0 to 3);
	signal R0, R1, R2, R3, A, G, Adr: std_logic_vector(15 downto 0);
	signal IR : std_logic_vector(1 to 7);
	signal Sel : std_logic_vector(1 to 6);
begin
	High <= '1';
	Clear <= not(Resetn) or Done or (not(Run) and not(Tstep_Q(1)) and not(Tstep_Q(0)));
	Tstep: upcount port map (Clear, Clock, Tstep_Q);
	I <= IR(1 to 3);
	decX: dec2to4 port map (IR(4 to 5), High, Xreg);
	decY: dec2to4 port map (IR(6 to 7), High, Yreg);
	controlsignals: process (Tstep_Q, I, Xreg, Yreg)
	begin
		Done <= '0'; AddSub <= '0';  DINout <= '0';
		IRin <= '0'; Ain <= '0'; Gin <= '0'; Gout <= '0'; ADDRin <= '0'; pc_inc <= '0';
		Rin <= "0000"; Rout <= "0000";
		case Tstep_Q is
			when "00" =>
				IRin <= '1';
				pc_inc <= Run;
			when "01" =>
				case I is
					when mv =>
						Rout <= Yreg;
						Rin <= Xreg;
						Done <= '1';
					when mvi =>
						DINout <= '1';
						Rin <= Xreg;
						pc_inc <= '1';
						Done <= '1';
					when jmp =>
						Rout <= Xreg;
						ADDRin <= '1';
						Done <= '1';
					when others =>
						Rout <= Xreg;
						Ain <= '1';
				end case;
			when "10" =>
				case I is
					when add =>
						Rout <= Yreg;
						Gin <= '1';
					when others => --sub
						Rout <= Yreg;
						AddSub <= '1';
						Gin <= '1';
				end case;
			when "11" =>
				case I is
					when others => --add i sub
						Gout <= '1';
						Rin <= Xreg;
						Done <= '1';
				end case;
		end case;
	end process;
	
	reg_0: regn port map (BusWires, Rin(0), Clock, R0);
	reg_1: regn port map (BusWires, Rin(1), Clock, R1);
	reg_2: regn port map (BusWires, Rin(2), Clock, R2);
	reg_3: regn port map (BusWires, Rin(3), Clock, R3);
	reg_A: regn port map (BusWires, Ain, Clock, A);
	reg_G: regn port map (Sum, Gin, Clock, G);
	reg_IR: regn generic map(7) port map (DIN(15 downto 9), IRin, Clock, IR);
	
	PC: program_counter port map (BusWires, Resetn, Clock, pc_inc, ADDRin, ADDR);
	
	alu: process (AddSub, A, BusWires)
	begin
		if AddSub = '0' then
			Sum <= A + BusWires;
		else
			Sum <= A - BusWires;
		end if;
	end process;
	
	Sel <= Rout & Gout & DINout;
	
	busmux: process (Sel, R0, R1, R2, R3, G, DIN)
	begin
		case Sel is
			when "100000" => BusWires <= R0;
			when "010000" => BusWires <= R1;
			when "001000" => BusWires <= R2;
			when "000100" => BusWires <= R3;
			when "000010" => BusWires <= G;
			when  others  => BusWires <= DIN;
		end case;
	end process;
end behavior;