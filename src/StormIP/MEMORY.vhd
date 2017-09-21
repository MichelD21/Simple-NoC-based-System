-- ######################################################
-- #          < STORM SoC by Stephan Nolting >          #
-- # ************************************************** #
-- #             Internal Memory Component              #
-- # ************************************************** #
-- # Last modified: 04.03.2012                          #
-- ######################################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MEMORY is
	generic	(
				MEM_SIZE      : natural := 256;  -- memory cells
				LOG2_MEM_SIZE : natural := 8;    -- log2(memory cells)
				OUTPUT_GATE   : boolean := FALSE -- output and-gate, might be necessary for some bus systems
			);
	port	(
				-- Wishbone Bus --
				WB_CLK_I      : in  STD_LOGIC; -- memory master clock
				WB_RST_I      : in  STD_LOGIC; -- high active sync reset
				WB_CTI_I      : in  STD_LOGIC_VECTOR(02 downto 0); -- cycle indentifier
				WB_TGC_I      : in  STD_LOGIC_VECTOR(06 downto 0); -- cycle tag
				WB_ADR_I      : in  STD_LOGIC_VECTOR(LOG2_MEM_SIZE-1 downto 0); -- adr in
				WB_DATA_I     : in  STD_LOGIC_VECTOR(31 downto 0); -- write data
				WB_DATA_O     : out STD_LOGIC_VECTOR(31 downto 0); -- read data
				WB_SEL_I      : in  STD_LOGIC_VECTOR(03 downto 0); -- data quantity
				WB_WE_I       : in  STD_LOGIC; -- write enable
				WB_STB_I      : in  STD_LOGIC; -- valid cycle
				WB_ACK_O      : out STD_LOGIC; -- acknowledge
				WB_HALT_O     : out STD_LOGIC; -- throttle master
				WB_ERR_O      : out STD_LOGIC  -- abnormal cycle termination
			);
end MEMORY;

architecture Behavioral of MEMORY is

	--- Buffer ---
	signal WB_ACK_O_INT : STD_LOGIC;
	signal WB_DATA_INT  : STD_LOGIC_VECTOR(31 downto 0);

	--- Memory Type ---
	type MEM_FILE_TYPE is array (0 to MEM_SIZE - 1) of STD_LOGIC_VECTOR(31 downto 0);

	--- INIT MEMORY IMAGE ---
	------------------------------------------------------
	signal MEM_FILE : MEM_FILE_TYPE :=
	(
        000000 => x"E10F1000",
000001 => x"E3C11080",
000002 => x"E121F001",
000003 => x"EB000000",
000004 => x"EAFFFFFE",
000005 => x"E3E01A01",
000006 => x"E3A02B01",
000007 => x"E5113FDB",
000008 => x"E5012FDF",
000009 => x"E5113FDB",
000010 => x"E3130B01",
000011 => x"1A000003",
000012 => x"E1A02001",
000013 => x"E5123FDB",
000014 => x"E3130B01",
000015 => x"0AFFFFFC",
000016 => x"E3A03C06",
000017 => x"E3A02B01",
000018 => x"E3E01A01",
000019 => x"E2833003",
000020 => x"E2822003",
000021 => x"E5013FDF",
000022 => x"E5012FDF",
000023 => x"E5113FDB",
000024 => x"E3130B01",
000025 => x"1A000003",
000026 => x"E1A02001",
000027 => x"E5123FDB",
000028 => x"E3130B01",
000029 => x"0AFFFFFC",
000030 => x"E3A03D1B",
000031 => x"E3A02D13",
000032 => x"E3E01A01",
000033 => x"E2833008",
000034 => x"E2822008",
000035 => x"E5013FDF",
000036 => x"E5012FDF",
000037 => x"E5113FDB",
000038 => x"E3130B01",
000039 => x"1A000003",
000040 => x"E1A02001",
000041 => x"E5123FDB",
000042 => x"E3130B01",
000043 => x"0AFFFFFC",
000044 => x"E3E01A01",
000045 => x"E3A03C06",
000046 => x"E3A02B01",
000047 => x"E5013FDF",
000048 => x"E5012FDF",
000049 => x"E5113FDB",
000050 => x"E3130B01",
000051 => x"1A000003",
000052 => x"E1A02001",
000053 => x"E5123FDB",
000054 => x"E3130B01",
000055 => x"0AFFFFFC",
000056 => x"E3E01A01",
000057 => x"E3A03C06",
000058 => x"E3A02B01",
000059 => x"E5013FDF",
000060 => x"E5012FDF",
000061 => x"E5113FDB",
000062 => x"E3130B01",
000063 => x"1A000003",
000064 => x"E1A02001",
000065 => x"E5123FDB",
000066 => x"E3130B01",
000067 => x"0AFFFFFC",
000068 => x"E3E01A01",
000069 => x"E3A03C06",
000070 => x"E3A02B01",
000071 => x"E5013FDF",
000072 => x"E5012FDF",
000073 => x"E5113FDB",
000074 => x"E3130B01",
000075 => x"1A000003",
000076 => x"E1A02001",
000077 => x"E5123FDB",
000078 => x"E3130B01",
000079 => x"0AFFFFFC",
000080 => x"E3A03E7F",
000081 => x"E3A02E4F",
000082 => x"E3E01A01",
000083 => x"E283300F",
000084 => x"E282200F",
000085 => x"E5013FDF",
000086 => x"E5012FDF",
000087 => x"E5113FDB",
000088 => x"E3130B01",
000089 => x"1A000003",
000090 => x"E1A02001",
000091 => x"E5123FDB",
000092 => x"E3130B01",
000093 => x"0AFFFFFC",
000094 => x"E3A03C06",
000095 => x"E3A02B01",
000096 => x"E3E01A01",
000097 => x"E2833002",
000098 => x"E2822002",
000099 => x"E5013FDF",
000100 => x"E5012FDF",
000101 => x"E5113FDB",
000102 => x"E3130B01",
000103 => x"1A000003",
000104 => x"E1A02001",
000105 => x"E5123FDB",
000106 => x"E3130B01",
000107 => x"0AFFFFFC",
000108 => x"E3A03E67",
000109 => x"E3A02E47",
000110 => x"E3E01A01",
000111 => x"E2833003",
000112 => x"E2822003",
000113 => x"E5013FDF",
000114 => x"E5012FDF",
000115 => x"E5113FDB",
000116 => x"E3130B01",
000117 => x"1A000003",
000118 => x"E1A02001",
000119 => x"E5123FDB",
000120 => x"E3130B01",
000121 => x"0AFFFFFC",
000122 => x"E3A03E67",
000123 => x"E3A02E47",
000124 => x"E3E01A01",
000125 => x"E2833004",
000126 => x"E2822004",
000127 => x"E5013FDF",
000128 => x"E5012FDF",
000129 => x"E5113FDB",
000130 => x"E3130B01",
000131 => x"1A000003",
000132 => x"E1A02001",
000133 => x"E5123FDB",
000134 => x"E3130B01",
000135 => x"0AFFFFFC",
000136 => x"E3A03E66",
000137 => x"E3A02E46",
000138 => x"E3E01A01",
000139 => x"E2833001",
000140 => x"E2822001",
000141 => x"E5013FDF",
000142 => x"E5012FDF",
000143 => x"E5113FDB",
000144 => x"E3130B01",
000145 => x"1A000003",
000146 => x"E1A02001",
000147 => x"E5123FDB",
000148 => x"E3130B01",
000149 => x"0AFFFFFC",
000150 => x"E3A03E67",
000151 => x"E3A02E47",
000152 => x"E3E01A01",
000153 => x"E2833002",
000154 => x"E2822002",
000155 => x"E5013FDF",
000156 => x"E5012FDF",
000157 => x"E5113FDB",
000158 => x"E3130B01",
000159 => x"1A000003",
000160 => x"E1A02001",
000161 => x"E5123FDB",
000162 => x"E3130B01",
000163 => x"0AFFFFFC",
000164 => x"E3A03E77",
000165 => x"E3A02E47",
000166 => x"E3E01A01",
000167 => x"E2833004",
000168 => x"E2822004",
000169 => x"E3A00000",
000170 => x"E5013FDF",
000171 => x"E5012FDF",
000172 => x"E1A0F00E",
others => x"F0013007"
    );
	------------------------------------------------------

begin

	-- STORM data/instruction memory -----------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------
		MEM_FILE_ACCESS: process(WB_CLK_I)
		begin
			--- Sync Write ---
			if rising_edge(WB_CLK_I) then

				--- Data Read/Write ---
				if (WB_STB_I = '1') then
					if (WB_WE_I = '1') then
						MEM_FILE(to_integer(unsigned(WB_ADR_I))) <= WB_DATA_I;
					end if;
					WB_DATA_INT <= MEM_FILE(to_integer(unsigned(WB_ADR_I)));
				end if;

				--- ACK Control ---
				if (WB_RST_I = '1') then
					WB_ACK_O_INT <= '0';
				elsif (WB_CTI_I = "000") or (WB_CTI_I = "111") then
					WB_ACK_O_INT <= WB_STB_I and (not WB_ACK_O_INT);
				else
					WB_ACK_O_INT <= WB_STB_I;
				end if;

			end if;
		end process MEM_FILE_ACCESS;

		--- Output Gate ---
		WB_DATA_O <= WB_DATA_INT when (OUTPUT_GATE = FALSE) or ((OUTPUT_GATE = TRUE) and (WB_STB_I = '1')) else (others => '0');

		--- ACK Signal ---
		WB_ACK_O  <= WB_ACK_O_INT;

		--- Throttle ---
		WB_HALT_O <= '0'; -- yeay, we're at full speed!

		--- Error ---
		WB_ERR_O  <= '0'; -- nothing can go wrong ;)



end Behavioral;