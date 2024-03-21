# Définir le compilateur VHDL
VHDL_COMPILER=ghdl

# Définir les fichiers VHDL à compiler
VHDL_FILES=\
combi.vhd \
mem.vhd \
proc.vhd \
reg_bank.vhd \
etages.vhd \
test_etagesFE.vhd \
test_etagesDE.vhd

# Cible par défaut
all: test

# Règle pour construire le fichier de test
test: $(VHDL_FILES)
	$(VHDL_COMPILER) -a $(VHDL_FILES)
	$(VHDL_COMPILER) -e test_etageDE
	$(VHDL_COMPILER) -r test_etageDE --vcd=test_etages.vcd

gtkwave:
	gtkwave test_etages.vcd

# Règle pour nettoyer les fichiers générés
clean:
	rm -f *.o *.vcd work-obj93.cf

