# Plan de développement pour FP Blocky

## Introduction

FP Blocky est une application Flutter inspirée de Blockly qui vise à enseigner la programmation fonctionnelle à travers une interface visuelle de type "drag-and-drop". L'application utilisera la bibliothèque fpdart pour implémenter les concepts de programmation fonctionnelle en Dart.

## Objectifs

- Créer une interface visuelle de type "drag-and-drop" pour manipuler des blocs représentant des concepts de programmation fonctionnelle
- Permettre la composition visuelle de fonctions et de monades
- Générer du code Dart fonctionnel à partir des compositions visuelles
- Proposer des défis et tutoriels pour apprendre progressivement les concepts

## Architecture du projet

### 1. Structure des composants principaux

```
lib/
├── core/                   # Logique métier et utilitaires
│   ├── models/             # Modèles de données
│   ├── services/           # Services (génération de code, sauvegarde, etc.)
│   └── utils/              # Utilitaires divers
├── features/               # Fonctionnalités principales
│   ├── workspace/          # Espace de travail principal
│   ├── blocks/             # Définition et logique des blocs
│   ├── toolbox/            # Palette d'outils et catégories
│   ├── challenges/         # Système de défis et tutoriels
│   └── code_generation/    # Génération de code Dart
└── widgets/                # Composants UI réutilisables
    ├── blocks/             # Widgets de blocs visuels
    ├── canvas/            # Zone de travail interactive
    └── common/             # Widgets communs
```

## Étapes détaillées de développement

### Phase 1: Fondations et architecture de base

1. **Mise en place de l'architecture**
   - Définir la structure du projet
   - Configurer les dépendances (fpdart, provider/bloc pour la gestion d'état)
   - Créer les modèles de base

2. **Développement du système de blocs**
   - **Concept clé: Modèle de bloc**
     - Créer une classe abstraite `Block` qui servira de base pour tous les types de blocs
     - Implémenter les propriétés communes: identifiant, position, connexions, etc.
   - **Concept clé: Système de connexions**
     - Définir les types de connexions (entrée, sortie)
     - Implémenter la logique de compatibilité entre connexions
   - **Concept clé: Sérialisation**
     - Permettre la sauvegarde et le chargement de l'état des blocs

### Phase 2: Interface utilisateur et interactions

3. **Développement de l'espace de travail**
   - **Concept clé: Canvas interactif**
     - Créer un widget `WorkspaceCanvas` qui servira de zone de travail
     - Implémenter le système de coordonnées et de zoom
   - **Concept clé: Gestion des événements**
     - Gérer les événements tactiles (drag, pinch, etc.)
     - Implémenter la sélection et le déplacement des blocs

4. **Développement de la boîte à outils (Toolbox)**
   - **Concept clé: Catégories de blocs**
     - Organiser les blocs par catégories (Option, Either, Task, etc.)
     - Créer une interface pour naviguer entre les catégories
   - **Concept clé: Drag-and-drop**
     - Permettre de glisser-déposer des blocs depuis la toolbox vers l'espace de travail

### Phase 3: Implémentation des blocs fonctionnels

5. **Création des blocs de base pour fpdart**
   - **Concept clé: Représentation visuelle des monades**
     - Implémenter les blocs pour Option (Some, None)
     - Implémenter les blocs pour Either (Left, Right)
     - Implémenter les blocs pour Task et TaskEither
     - Implémenter les blocs pour IO
   
   - **Concept clé: Opérations sur les monades**
     - Implémenter les blocs pour map, flatMap, fold, etc.
     - Implémenter les blocs pour les combinateurs (ap, chain, etc.)

6. **Système de typage**
   - **Concept clé: Vérification de types**
     - Implémenter un système de vérification de types pour les connexions
     - Visualiser les types compatibles et incompatibles
   - **Concept clé: Inférence de types**
     - Déduire automatiquement les types quand c'est possible

### Phase 4: Génération de code et exécution

7. **Génération de code Dart**
   - **Concept clé: Traduction de blocs en code**
     - Parcourir le graphe de blocs et générer du code Dart équivalent
     - Gérer les imports nécessaires pour fpdart
   - **Concept clé: Formatage du code**
     - Générer du code lisible et bien formaté

8. **Système d'exécution et visualisation**
   - **Concept clé: Exécution du code généré**
     - Exécuter le code généré dans un environnement isolé
     - Afficher les résultats de l'exécution
   - **Concept clé: Visualisation des données**
     - Représenter visuellement les valeurs contenues dans les monades

### Phase 5: Système d'apprentissage

9. **Système de défis et tutoriels**
   - **Concept clé: Progression pédagogique**
     - Créer une série de défis progressifs
     - Organiser les défis par concepts (Option, Either, etc.)
   - **Concept clé: Validation des solutions**
     - Vérifier automatiquement si la solution proposée est correcte
     - Fournir des indices et des explications

10. **Documentation intégrée**
    - **Concept clé: Aide contextuelle**
      - Afficher des informations sur les blocs au survol
      - Fournir des exemples d'utilisation
    - **Concept clé: Glossaire**
      - Créer un glossaire des termes de programmation fonctionnelle

## Implémentation technique détaillée

### 1. Système de blocs

#### Modèle de bloc
```dart
abstract class Block {
  final String id;
  final BlockType type;
  final List<Connection> inputs;
  final List<Connection> outputs;
  
  // Position sur le canvas
  Offset position;
  
  // Méthodes pour la manipulation
  void move(Offset delta);
  bool canConnectTo(Connection other);
  
  // Méthodes pour la génération de code
  String generateCode();
}
```

#### Types de blocs spécifiques
```dart
// Bloc pour Option.of
class OptionOfBlock extends Block {
  dynamic value;
  
  @override
  String generateCode() => 'Option.of($value)';
}

// Bloc pour map
class MapBlock extends Block {
  String functionBody;
  
  @override
  String generateCode() => '.map(($inputType) => $functionBody)';
}
```

### 2. Système de connexions

```dart
enum ConnectionType { input, output }

class Connection {
  final String id;
  final Block parent;
  final ConnectionType type;
  final DataType dataType;
  
  Connection? connectedTo;
  
  bool canConnectTo(Connection other) {
    // Vérifier la compatibilité des types
    return type != other.type && dataType.isCompatibleWith(other.dataType);
  }
}

class DataType {
  final String name;
  final List<DataType> typeParameters;
  
  bool isCompatibleWith(DataType other) {
    // Logique de compatibilité des types
  }
}
```

### 3. Workspace et Canvas

```dart
class WorkspaceCanvas extends StatefulWidget {
  @override
  _WorkspaceCanvasState createState() => _WorkspaceCanvasState();
}

class _WorkspaceCanvasState extends State<WorkspaceCanvas> {
  // Liste des blocs sur le canvas
  List<Block> blocks = [];
  
  // État de l'interaction
  Block? selectedBlock;
  Connection? draggedConnection;
  
  // Gestion du zoom et du pan
  double scale = 1.0;
  Offset offset = Offset.zero;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: CustomPaint(
        painter: WorkspacePainter(blocks, scale, offset),
        child: Stack(
          children: blocks.map((block) => BlockWidget(block)).toList(),
        ),
      ),
    );
  }
  
  // Méthodes pour gérer les interactions
  void _handleScaleStart(ScaleStartDetails details) { /* ... */ }
  void _handleScaleUpdate(ScaleUpdateDetails details) { /* ... */ }
  void _handleBlockDrag(Block block, Offset delta) { /* ... */ }
  void _handleConnectionDrag(Connection connection, Offset position) { /* ... */ }
}
```

### 4. Génération de code

```dart
class CodeGenerator {
  String generateCodeFromBlocks(List<Block> blocks) {
    // Trouver les blocs "racines" (sans connexions d'entrée)
    final rootBlocks = blocks.where((block) => 
      block.inputs.every((input) => input.connectedTo == null));
    
    // Générer le code pour chaque racine
    final codeFragments = rootBlocks.map(_generateCodeForBlock).toList();
    
    // Assembler le code final avec les imports nécessaires
    return '''
import 'package:fpdart/fpdart.dart';

void main() {
  ${codeFragments.join('\n  ')}
}
''';
  }
  
  String _generateCodeForBlock(Block block) {
    // Logique récursive pour générer le code
    // en suivant les connexions entre les blocs
  }
}
```

### 5. Système de défis

```dart
class Challenge {
  final String id;
  final String title;
  final String description;
  final List<Block> availableBlocks;
  final String expectedOutput;
  
  bool validateSolution(List<Block> blocks) {
    final generator = CodeGenerator();
    final code = generator.generateCodeFromBlocks(blocks);
    
    // Exécuter le code et comparer avec expectedOutput
    // (via isolate ou autre mécanisme)
  }
}
```

## Feuille de route et priorités

1. **Sprint 1: Fondations (2-3 semaines)**
   - Mise en place de l'architecture
   - Implémentation des modèles de base
   - Création des widgets de blocs simples

2. **Sprint 2: Interface utilisateur (2-3 semaines)**
   - Développement du canvas interactif
   - Implémentation du drag-and-drop
   - Création de la toolbox

3. **Sprint 3: Blocs fonctionnels (3-4 semaines)**
   - Implémentation des blocs pour Option, Either
   - Implémentation des opérations de base (map, flatMap)
   - Système de connexions typées

4. **Sprint 4: Génération de code (2-3 semaines)**
   - Développement du générateur de code
   - Visualisation du code généré
   - Exécution basique du code

5. **Sprint 5: Système d'apprentissage (3-4 semaines)**
   - Création des premiers défis
   - Implémentation du système de validation
   - Documentation intégrée

6. **Sprint 6: Polissage et tests (2-3 semaines)**
   - Tests utilisateurs
   - Corrections de bugs
   - Améliorations UX/UI

## Conclusion

Ce plan détaille la création d'une application Flutter inspirée de Blockly pour enseigner la programmation fonctionnelle avec fpdart. L'approche visuelle et interactive permettra aux utilisateurs de comprendre et d'expérimenter avec les concepts de programmation fonctionnelle sans se soucier initialement de la syntaxe.

Le développement progressif, en commençant par les fondations et en ajoutant des fonctionnalités de manière incrémentale, permettra d'avoir rapidement une version fonctionnelle qui pourra être testée et améliorée au fil du temps.
