library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cntrl_unit is 
    port (
        opCode      : in std_logic_vector(5 downto 0);
        RegDst      : out std_logic;
        RegRW       : out std_logic;
        ALUSrc      : out std_logic;
        ALUOp1      : out std_logic;
        ALUOp0      : out std_logic;
        MemRW       : out std_logic;
        Mem2Reg     : out std_logic;
        Branch      : out std_logic
    );
end cntrl_unit;

architecture behavior of cntrl_unit is 
    begin 
        process (opCode) begin
            if (opCode = "000000") then             --arithmetisch/logisch
                RegDst  <= '1';
                RegRW   <= '1';
                ALUSrc  <= '0';
                ALUOp1  <= '1';
                ALUOp0  <= '0';
                MemRW   <= '0';
                Mem2Reg <= '1';
                Branch  <= '0';
            elsif (opCode = "100011") then          --lw
                RegDst  <= '0';
                RegRW   <= '1';
                ALUSrc  <= '1';
                ALUOp1  <= '0';
                ALUOp0  <= '0';
                MemRW   <= '0';
                Mem2Reg <= '0';
                Branch  <= '0';
            elsif (opCode = "101011") then          --sw
                RegDst  <= '0';
                RegRW   <= '0';
                ALUSrc  <= '1';
                ALUOp1  <= '0';
                ALUOp0  <= '0';
                MemRW   <= '1';
                Mem2Reg <= '-';
                Branch  <= '0';    
            elsif (opCode = "000100") then          --beq
                RegDst  <= '0';
                RegRW   <= '0';
                ALUSrc  <= '0';
                ALUOp1  <= '0';
                ALUOp0  <= '1';
                MemRW   <= '0';
                Mem2Reg <= '-';
                Branch  <= '1';
            end if;
        end process;
end behavior;