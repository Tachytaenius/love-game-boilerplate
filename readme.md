# LÖVE game boilerplate library

This repository contains a runnable example program, the actual library is in `lib/`.
Said program is intended to serve as part of the documentation for now.

This is a boilerplate library for LÖVE games.
It features:

- Fixed timestep
- Settings
- GUI
- Screenshots
- Boxed assets
- An input system for different types of commands

## `ui.current` Variables

- `type`: The name of the UI type the UI is an instance of.
- `causesPause`: Pauses the game.
- `ignorePausePress`: Prevent pause command from destroying interface.
- `draw` (function): Draws UI elements that SUIT can't do.
- `mouseX` & `mouseY`: Mouse cursor position.

## Notes

- Some config options are sent straight to their respective systems and not to the config module.
