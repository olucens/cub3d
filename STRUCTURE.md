## Structure

```
cub3d/
├── Makefile
├── STRUCTURE.md
│
├── includes/
│   ├── cub3d.h         # Main header: all function prototypes
│   ├── defines.h       # Constants, key codes, game settings, and all struct definitions
│   ├── colors.h        # Color-related macros
│   ├── render.h        # Render subsystem prototypes
│   └── tests.h         # Test suite prototypes
│
├── Libft/              # Custom C standard library (libft, ft_printf, get_next_line)
│
├── maps/               # Sample .cub scene files
│
├── textures/           # XPM wall texture files
│
└── src/
    │
    ├── core/
    │   ├── main.c          # Entry point: validates args, registers MLX hooks, starts event loop
    │   ├── ft_error.c      # Error reporting helpers
    │   ├── exit_game.c     # Clean exit with full resource deallocation
    │   ├── cub_free.c      # Memory cleanup for game structs
    │   └── statusPrints.c  # Colored status output (success, error, fail)
    │
    ├── init/
    │   ├── init_data.c         # Top-level initialization: parse → test → graphics
    │   ├── init_graphics.c     # MLX connection, window creation, texture loading
    │   ├── init_rgb.c          # Convert t_rgb struct to packed integer color
    │   └── cleanup_graphics.c  # Destroy MLX images and connection on exit
    │
    ├── input/
    │   ├── key_press.c     # Key press and release event handlers
    │   ├── move_player.c   # Movement calculation and wall collision detection
    │   └── update.c        # Per-frame callback: process input and trigger render
    │
    ├── parser/
    │   ├── parser.c            # Entry point: reads the .cub file and dispatches parsers
    │   ├── parser_utils.c      # Shared parsing helpers (string trimming, field lookup)
    │   ├── check_map.c         # Map-level validation
    │   ├── check_map_grid.c    # Grid structure and character validation
    │   ├── check_border.c      # Border closure check
    │   ├── check_textures.c    # Texture path and RGB color validation
    │   ├── dfs.c               # Depth-first search to verify the map is fully enclosed
    │   └── map_to_matrix.c     # Convert string map grid to a 2D integer matrix
    │
    ├── render/
    │   ├── display_game.c      # Main render function: per-column DDA raycasting loop
    │   ├── draw_wall.c         # Texture sampling and wall column pixel writing
    │   ├── draw_utils.c        # Pixel buffer write and texture pixel read helpers
    │   ├── init_render_data.c  # Initialize per-ray t_render_data before each cast
    │   └── close_game.c        # Window close event handler
    │
    └── utils/
        ├── t_pos.c         # t_pos (2D float vector) arithmetic helpers
        └── time_utils.c    # gettimeofday wrapper for frame timing

tests/
├── tests.c             # Test runner
├── tests_maps.c        # Map parsing tests
├── tests_init.c        # Initialization tests
├── tests_utils.c       # Test utility helpers
├── validator.c         # Assertion helpers for parsed data
├── main_test.c         # Test entry point (called from init_data before graphics init)
├── test_data_free.c    # Memory cleanup for test structures
├── map0.c              # Test map data (case 0)
├── map1.c              # Test map data (case 1)
├── map2.c              # Test map data (case 2)
└── test_maps/          # Corresponding .cub files for test cases
```

## Program Lifecycle

1. `main()` receives the path to a `.cub` file as its only argument and calls `init_data()`.
2. `init_data()` calls the parser, runs the test suite against the parsed data, and on success calls `init_graphics()`.
3. The parser reads the file, validates the extension, extracts the four texture paths and the two RGB color values, then converts the map grid to an integer matrix. A DFS traversal confirms the map is fully enclosed.
4. `init_graphics()` creates the MLX connection and window, loads XPM textures into `t_image` structs, and allocates an off-screen pixel buffer.
5. Back in `main()`, MLX hooks are registered for key press, key release, window close, and the per-frame `update()` callback. The MLX event loop starts.
6. Each frame: `update()` processes the current key state, updates the player position and direction, then calls `display_game()`. The renderer casts one ray per screen column using DDA, samples the wall texture at the hit point, fills floor and ceiling with solid color, and flushes the completed buffer to the window.
