# Définir le compilateur VHDL
VHDL_COMPILER=ghdl

# Directories
TEST_FOLDER=./test
SRC_FOLDER=./src
WAVE_FOLDER=./wave

# Manually specified source files in the precise order required
SRC_FILES=\
    $(SRC_FOLDER)/combi.vhd \
    $(SRC_FOLDER)/mem.vhd \
    $(SRC_FOLDER)/reg_bank.vhd \
    $(SRC_FOLDER)/control_unit.vhd \
    $(SRC_FOLDER)/etages.vhd \
    $(SRC_FOLDER)/condition_management_unit.vhd \
    $(SRC_FOLDER)/proc.vhd

# Test files
TEST_FILES=$(wildcard $(TEST_FOLDER)/*.vhd)

TESTBENCH ?= testbench

.PHONY: compile
compile:
	$(VHDL_COMPILER) -i --workdir=$(TEST_FOLDER) $(SRC_FILES) $(TEST_FILES)

.PHONY: elaborate
elaborate: compile
	$(VHDL_COMPILER) -m --workdir=$(TEST_FOLDER) $(TESTBENCH)

.PHONY: simulate
simulate: elaborate
	$(VHDL_COMPILER) -r --workdir=$(TEST_FOLDER) $(TESTBENCH) --vcd=$(WAVE_FOLDER)/$(TESTBENCH).vcd

.PHONY: all
all: simulate

.PHONY: clean
clean:
	rm -f $(TEST_FOLDER)/*.o $(TEST_FOLDER)/*.cf $(WAVE_FOLDER)/*.vcd
