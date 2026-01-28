# MATLAB Snake Game

A fully functional implementation of the classic "Snake" arcade game, running entirely within a MATLAB figure window. This game features collision detection, increasing difficulty (speed), and a "Maximized" full-screen experience.

## 📋 Prerequisites

* **Software:** MATLAB (Recommended version R2018b or later for full window support).
* **Hardware:** A keyboard with a **Number Pad (Numpad)** is required for the default controls.

## 🚀 Setup & Installation

1.  **Save the Script:**
    * Create a new MATLAB script file (e.g., `SnakeGame.m`).
    * Paste the provided game code into the file and save it.

2.  **Prepare your Keyboard:**
    * Ensure your **NumLock** key is turned **ON**. The game specifically listens for Numpad key codes.

3.  **Run the Game:**
    * Open the script in MATLAB.
    * Press `F5` or click the **Run** button.
    * The game window will open in "Maximized" mode automatically.

## 🎮 Controls

**Important:** This game uses the **Numpad** for navigation.

| Action | Key (Numpad) |
| :--- | :--- |
| **Start / Pause** | `Numpad 1` |
| **Move UP** | `Numpad 8` |
| **Move DOWN** | `Numpad 5` |
| **Move LEFT** | `Numpad 4` |
| **Move RIGHT** | `Numpad 6` |
| **Restart (Game Over)** | `Numpad 0` |

> **Note:** `Numpad 5` is used for **Down**, not `2`.

## 🕹️ Gameplay Rules

1.  **Objective:** Control the green snake using the Numpad keys to eat the orange food dots.
2.  **Growth:** Every time the snake eats, it grows in length.
3.  **Speed:** The snake moves faster as it gets longer (Adaptive difficulty).
4.  **Game Over:** You lose if:
    * You hit the walls (the edge of the grid).
    * You run into your own tail.
5.  **Winning:** You win if you fill the entire grid with the snake body.

## ⚙️ Customization (Optional)

If you wish to modify the game parameters, look for these variables at the top of the script:

* **Grid Size:** Change `Ngrid = 3;` to a higher number (e.g., `Ngrid = 10;`) for a larger playing field.
* **Colors:** Modify the `green` and `orange` RGB vectors to change the theme.

## 🐞 Troubleshooting

* **Snake won't move:** Check that **NumLock** is on. If you are using a laptop without a Numpad, you will need to edit the `validKeys` and `inputs` section in the code to use standard numbers (e.g., change `'numpad8'` to `'8'` or `'uparrow'`).
* **Game is too fast/slow:** The speed is calculated automatically in the `Initialize pause buffers` section.
