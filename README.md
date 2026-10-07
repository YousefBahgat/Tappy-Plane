# ✈️ Tappy Plane

A simple 2D arcade game inspired by the classic **Flappy Bird** gameplay style, built with **Godot 4.7**.

The player controls a small plane and must keep flying while avoiding incoming pipes. The goal is to survive as long as possible, pass through as many pipe gaps as possible, and achieve the highest score.

This project started as a learning project and evolved into a complete small game covering gameplay, UI, scene management, signals, saving data, input handling, and scene transitions.

---

## 🎮 Gameplay

The gameplay is simple:

- Tap / click to make the plane fly upward.
- The plane continuously falls due to gravity.
- Avoid hitting the pipes.
- Passing a pipe successfully gives you **1 point**.
- The game ends when the plane dies.
- Your **High Score** is saved locally.
- The main goal is to survive as long as possible and beat your high score.

---

## 🕹️ Controls

| Input | Action |
|---|---|
| Mouse Click | Fly |
| Touch | Fly |
| Keyboard Action | Fly |

The game uses Godot's **Input Map**, so the input action can be configured from:

`Project Settings → Input Map`

---

## 🛠️ Built With

- **Godot 4.x**
- **GDScript**
- 2D Nodes
- `CharacterBody2D`
- `Area2D`
- `Control`
- `CanvasLayer`
- `AnimationPlayer`
- Signals
- Autoloads / Globals
- `PackedScene`
- `FileAccess`

---

## 🧩 Main Systems

### 1. Scene Management

The game is divided into separate scenes, including:

- Main Menu
- Game
- Loading Screen
- Complex Change / Transition Scene

Scenes are changed using `PackedScene` references and Godot's SceneTree.

For example:

```gdscript
get_tree().change_scene_to_packed(game)
```

A global scene manager is used to handle navigation between scenes and reduce direct dependencies between the Main Menu and Game scenes.

---

### 2. Autoloads / Globals

The project uses **Autoloads**, which can also be called **Globals**.

They provide systems that need to be accessible from different scenes.

Examples include:

- Scene / Game Manager
- Signal Hub
- Score Manager
- Complex Change / Transition Manager

An Autoload is conceptually similar to a singleton because it provides globally accessible functionality.

However, Godot does not strictly enforce the classic singleton pattern because multiple instances can technically exist.

---

### 3. Signal Hub

The project uses a **Signal Hub**, also known as a:

- Signal Bus
- Event Hub
- Event Bus

Instead of making gameplay objects directly depend on UI objects, important events are sent through the Signal Hub.

For example:

```gdscript
signal tappy_died

func emit_tappy_died() -> void:
    tappy_died.emit()
```

Tappy can emit the event:

```gdscript
signal_hub.emit_tappy_died()
```

And the Game UI can listen for it:

```gdscript
func _ready() -> void:
    signal_hub.tappy_died.connect(on_tappy_died)

func on_tappy_died() -> void:
    game_over()
```

This keeps different parts of the game loosely coupled and easier to maintain.

---

### 4. Score System

The project uses a dedicated **Score Manager**.

When the player successfully passes a pipe:

```gdscript
score_manager.add_point()
```

The Score Manager increases the score and notifies the Signal Hub:

```gdscript
var score: int = 0

func add_point() -> void:
    score += 1
    signal_hub.emit_point_scored(score)
```

The Game UI listens for the score signal and updates the displayed score.

The score uses four digits:

```gdscript
"%04d" % score
```

Examples:

```text
0  → 0000
1  → 0001
12 → 0012
```

---

### 5. High Score

The game also keeps track of the player's highest score.

When the player dies:

```gdscript
if score > high_score:
    high_score = score
```

The high score is displayed on the Main Menu.

---

### 6. Saving the High Score

The high score is saved locally using Godot's `FileAccess`.

The save path is:

```gdscript
const SAVE_PATH = "user://tappy_save.dat"
```

The project uses:

```gdscript
FileAccess
```

to write and read the saved score.

The score is stored with:

```gdscript
store_32()
```

and loaded with:

```gdscript
get_32()
```

The save file contains binary data, while Godot handles the encoding and decoding.

The project also checks whether the save file exists before attempting to read it.

This allows the high score to remain available after closing and reopening the game.

---

### 7. Input Handling

The project explores Godot's input event system, including:

- `_input()`
- `_gui_input()`
- `_unhandled_input()`

One important lesson was that UI elements can **consume mouse and touch input**.

For example, a full-screen `Control` node with its Mouse Filter set to `Stop` can prevent the input from reaching `_unhandled_input()`.

For UI elements that should not consume gameplay input, the Mouse Filter can be set to:

```text
Ignore
```

This allows the input to continue through the UI.

The project also uses:

```gdscript
Input.is_action_just_pressed("fly")
```

for directly polling an input action when appropriate.

---

### 8. UI and CanvasLayer

The game UI is built using Godot's `Control` nodes.

Important UI elements include:

- Score
- High Score
- Game Over
- Margins
- Labels
- Label Settings

The project uses `CanvasLayer` to keep UI elements in **screen space** instead of world space.

This is useful because gameplay objects are part of the game world, while the interface should remain fixed to the screen.

The project also uses CanvasLayer ordering to control which UI elements appear above others.

---

### 9. Game Over and Pause

When Tappy dies, the game tree is paused.

The Game UI needs to continue processing while the rest of the game is paused, so its **Process Mode** is configured appropriately.

This allows the Game Over interface to continue working even while gameplay is stopped.

When returning to the Main Menu, the game is unpaused:

```gdscript
get_tree().paused = false
```

---

### 10. Loading Screen

The project includes a simple loading transition between scenes.

The flow is:

```text
Main Menu
    ↓
Loading Screen
    ↓
Game
```

And when returning to the Main Menu:

```text
Game
    ↓
Loading Screen
    ↓
Main Menu
```

The loading screen waits before changing to the next scene:

```gdscript
await get_tree().create_timer(1.0).timeout
game_manager.change_to_next()
```

The `await` pauses only the current function while waiting. It does **not** freeze the entire application.

---

### 11. Fade-to-Black Transition

The project also includes a more advanced scene transition.

Instead of immediately changing scenes, the game performs:

```text
Fade to Black
      ↓
Change Scene
      ↓
Fade from Black
```

A full-screen `ColorRect` is placed over the game and starts transparent.

An `AnimationPlayer` controls its opacity:

```text
Transparent
     ↓
Black
     ↓
Transparent
```

The scene changes while the screen is completely black.

This creates a smoother transition between scenes.

The transition scene is registered as an **Autoload / Global**, allowing different scenes to request transitions without directly depending on each other.

An `AnimationPlayer` method-call track is also used to call:

```gdscript
change_to_next()
```

at the correct moment while the screen is black.

The transition scene is configured to **Always** process so it can continue working even when the game tree is paused after Tappy dies.

---

## 🏗️ Project Architecture

A simplified view of the architecture:

```text
                    ┌──────────────────┐
                    │    Main Menu     │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │ Scene / Game     │
                    │     Manager      │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │ Loading / Fade   │
                    │    Transition    │
                    └────────┬─────────┘
                             │
                             ▼
                    ┌──────────────────┐
                    │      Game        │
                    └────────┬─────────┘
                             │
                 ┌───────────┼───────────┐
                 ▼           ▼           ▼
              Tappy        Pipes       Game UI
                 │           │           │
                 └──────┬────┴───────────┘
                        ▼
                 ┌──────────────┐
                 │  Signal Hub  │
                 └──────┬───────┘
                        │
             ┌──────────┴──────────┐
             ▼                     ▼
      ┌──────────────┐      ┌──────────────┐
      │ Score Manager│      │ Other Systems│
      └──────────────┘      └──────────────┘
```

---

## 📁 Project Concepts

This project demonstrates the following Godot concepts:

- Scenes and scene instancing
- `PackedScene`
- `load()` vs `preload()`
- Scene changing
- Autoloads / Globals
- Singleton-like architecture
- Signals
- Signal Hub / Signal Bus
- Decoupled communication
- UI Controls
- CanvasLayer
- CanvasItem
- Node2D vs Control coordinate systems
- Mouse Filters
- Input propagation
- `_input()`
- `_gui_input()`
- `_unhandled_input()`
- Process Mode
- Pausing the SceneTree
- `AnimationPlayer`
- Animation tracks
- Method Call tracks
- Scene transitions
- `await`
- `FileAccess`
- Local save files
- Binary data
- Score systems
- High score systems

---

## 🧠 Important Architecture Lessons

### Avoiding Circular Scene Dependencies

Directly preloading scenes from each other can create circular dependencies.

For example:

```text
Main → Game
Game → Main
```

This can lead to circular reference problems.

Using a global scene manager avoids this problem:

```text
Main ───────┐
            ▼
       Game Manager
            ▲
            │
Game ───────┘
```

Both scenes communicate with the manager instead of directly depending on each other.

---

### `load()` vs `preload()`

The project also demonstrates the difference between:

```gdscript
load()
```

and:

```gdscript
preload()
```

`preload()` loads the resource earlier, while `load()` loads it when the code requests it.

This becomes important when deciding how and when scenes and resources should be loaded.

---

## ⚙️ Running the Project

### Requirements

- [Godot 4.7](https://godotengine.org/)

### Steps

1. Clone the repository:

```bash
git clone <https://github.com/YousefBahgat/Tappy-Plane/>
```

2. Open the project in Godot.

3. Import the project if necessary.

4. Open the main scene.

5. Press **Play**.

---

## 🎯 What I Learned

This project started as a simple Flappy Bird-style game, but it became a practical project for learning how to structure a complete Godot game.

The main lessons include:

### Game Architecture

How to organize different systems and allow them to communicate without unnecessary dependencies.

### Autoloads / Globals

How to create globally accessible managers and systems.

### Signals

How to communicate between objects without tightly coupling them.

### Scene Management

How to move between scenes safely and avoid circular scene dependencies.

### UI Architecture

How to separate gameplay objects from screen-space UI.

### Input

How Godot processes input and how UI nodes can affect input propagation.

### Game State

How pausing the SceneTree affects different nodes and why Process Mode matters.

### Saving Data

How to save and load persistent data using `FileAccess`.

### Transitions

How to create smooth scene transitions using `AnimationPlayer`.

---

## 🚧 Future Improvements

Possible additions for future versions:

- 🔊 Sound effects
- 🎵 Background music
- 🏆 Online leaderboards
- 🎨 Multiple plane skins
- 🌄 Different backgrounds
- 🌙 Day / night mode
- 💥 Better death effects
- ✨ Particle effects
- 🥇 Medal system
- ⚙️ Settings menu
- 📱 Improved mobile controls
- 🎮 Controller support
- 🏅 Achievements
- 📊 More detailed statistics

---

## 📌 Project Status

**Completed learning project.**

The core gameplay loop, scoring, high score system, local saving, UI, scene management, signals, input handling, loading screen, and fade-to-black transitions are implemented.

The project can also be used as a foundation for adding more gameplay features and polish in the future.

---

## 📚 Purpose of the Project

This project was created primarily for **learning and practicing Godot 4.7 game development**.

It focuses on understanding the underlying concepts behind a small complete game rather than only making the game work.

---

## 👨‍💻 Author

**Eng.Yousef Bahgat**

Built with ❤️ and **Godot 4.7**.

---

## 📄 License

```text
MIT License
```
