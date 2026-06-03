# cub3D — Raycasting 3D Engine in C

A first-person 3D renderer built from scratch in C using the raycasting technique, modeled after the original Wolfenstein 3D engine.

---

## About

cub3D parses a custom `.cub` scene file that defines wall textures, floor and ceiling colors, and a 2D map grid. It renders the scene in real time using the DDA (Digital Differential Analysis) raycasting algorithm, producing a textured 3D perspective view at 1280×960 pixels. The project demonstrates low-level graphics programming, custom file parsing, collision detection, and frame-rate-controlled game loop design — all implemented without any game engine.

---

## Features

- Real-time raycasting renderer at ~60 FPS
- Four directional wall textures (North, South, East, West) loaded from XPM files
- Configurable floor and ceiling colors defined as RGB values in the map file
- WASD movement with collision detection against walls and void cells
- Left/right arrow key rotation
- Custom `.cub` map format with full validation: extension check, border closure (DFS), player position, texture paths, and color values
- Unit test suite that runs on every startup to validate parsed data
- Memory-safe: all allocations tracked and freed on exit

---

## Build & Run

**Requirements:** MiniLibX (MLX), GCC, Make. On Linux, MLX links against `libXext` and `libX11`.

**On macOS via Docker (recommended for local development):**

```sh
# One-time setup
brew install tigervnc-viewer

# Build and start the container, then open a shell inside it
./run.sh

# Inside the container shell
cd cub3d
make
./cub3d maps/stdMap.cub
```

Connect TigerVNC Viewer to `localhost:5900` to see the display.

**On a native Linux system with MLX installed:**

```sh
cd cub3d
make
./cub3d maps/stdMap.cub
```

**Other Makefile targets:**

| Target    | Effect                                      |
|-----------|---------------------------------------------|
| `make`    | Build the `cub3d` binary                    |
| `make re` | Full rebuild from scratch                   |
| `make clean`  | Remove object files                     |
| `make fclean` | Remove object files and the binary      |

---

## How It Works

1. **Argument validation and initialization** — `main()` checks that exactly one argument is provided, allocates the `t_game` struct, and calls `init_data()`.

2. **Parsing** — `parse_cub_file()` reads the `.cub` file, validates its extension, parses texture paths (`NO`, `SO`, `WE`, `EA`) and RGB color values (`F`, `C`), then converts the map grid strings into a 2D integer matrix. A depth-first search (DFS) confirms the map is fully enclosed by walls.

3. **Data validation** — The built-in test suite runs against the parsed data to verify all fields are populated and structurally correct before any graphics are initialized.

4. **Graphics initialization** — `init_graphics()` creates an MLX connection and window, loads the four XPM wall textures into `t_image` structs, and allocates an off-screen pixel buffer for frame rendering.

5. **Game loop** — MLX hooks register key press/release handlers and a per-frame `update()` callback. Each frame reads the current key state, computes the new player position, checks it against the map matrix for collision, and rotates the camera direction and plane vectors accordingly.

6. **Rendering** — `display_game()` iterates over every screen column. For each column it initializes a ray direction, runs DDA to find the nearest wall hit, calculates the projected wall height from the perpendicular distance, samples the correct texture column, and writes pixels into the buffer. Floor and ceiling are filled with solid color. The completed buffer is pushed to the window in a single MLX call.

---

## Tech Stack

C (C99) · MiniLibX · POSIX (open/read/close, gettimeofday) · Custom Libft (libft, ft\_printf, get\_next\_line) · XPM textures · Make · Docker + VNC (macOS dev environment)

### [Structure](STRUCTURE.md)

*Built as part of the 42 Berlin curriculum.*
