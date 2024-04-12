# Dwayne Herzberg (22000086)

## Structure du Répertoire

- `src/` : Contient tous les fichiers source VHDL pour les composants principaux du projet.
- `test/` : Contient les bancs d'essai VHDL utilisés pour simuler les composants.
- `wave/` : Destiné à stocker les fichiers wave générés lors des simulations.
- `makefile` : Script pour automatiser la compilation, la simulation des fichiers VHDL.

## Utilisation

Le projet utilise un `makefile` pour simplifier le processus de construction. Voici les commandes disponibles dans le makefile :

- `make compile` : Compile tous les fichiers sources et de test VHDL.
- `make elaborate` : Élabore le banc d'essai.
- `make simulate` : Exécute la simulation et génère des fichiers VCD dans le répertoire `wave`.
- `make all` : Exécute toutes les commandes ci-dessus séquentiellement.
- `make clean` : Nettoie les fichiers générés.

Pour **realiser une simulation complète et générer des formes d'onde**, exécutez simplement :

```bash
make simulate TESTBENCH=test_nomEntite
```

## Avancement du Projet

| Chemin du fichier                         | Description                                               |
|-------------------------------------------|-----------------------------------------------------------|
| `src/condition_management_unit.vhd`       | TP2 Unité de gestion des conditions                       |
| `src/control_unit.vhd`                    | TP2 Unité de contrôle                                     |
| `src/etages.vhd`                          | Implémente les étages de pipeline du processeur.          |
| `src/proc.vhd.bak`                        | Chemin de données du TP1                                  |
| `src/proc.vhd`                            | Chemin de données du TP2                                  |

Tous les composants du TP1 et TP2 ont été réalisés et testés individuellement. Cependant, les tests globaux du processeur (chemin de données) n'ont pas encore été effectués. Actuellement, une erreur se présente lors des tests du chemin de données au niveau de l'étage DE : les opérandes Op1 et Op2 restent à zéro.

### Bancs d'Essai

- `test/test_etagesDE.vhd`, Banc d'essai pour l'étape DE du pipeline.
  nom de l'entité : test_etageDE
  Simple test de comportement. Voir la forme d'onde dans le dossier wave.

- `test/test_etagesFE.vhd`, Banc d'essai pour l'étape FE du pipeline.
  nom de l'entité : test_etageFE
  Simple test de comportement. Voir la forme d'onde dans le dossier wave.

- `test/test_etagesEX.vhd`, Banc d'essai pour l'étape EX du pipeline.
  nom de l'entité : test_etageEX
  Test basé sur vérification par assertion.

- `test/test_etagesME.vhd`, Banc d'essai pour l'étape ME du pipeline.
  nom de l'entité : test_etageME
  Test basé sur vérification par assertion.

- `test/test_etagesRE.vhd`, Banc d'essai pour l'étape RE du pipeline.
  nom de l'entité : test_etageRE
  Test basé sur vérification par assertion.

- `test/test_control_unit.vhd`, Banc d'essai pour l'unité de contrôle.
  nom de l'entité : test_controlUnit
  Test basé sur vérification par assertion.

- `test/test_dataPath.vhd`, Banc d'essai pour l'intégration du chemin de données.
  nom de l'entité : test_dataPath
  Test basé sur vérification par assertion. NON FINI
