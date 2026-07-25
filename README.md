# gmtk-2026

game core: ???
game pillars: ???

core loop: a games core in motion

feature set: the mechanics & mechanics in a games design. The things inside the core loop that help move
- tiles that have a countdown before they disappear
- time limit before everything goes forwards one time step
- bombs
- enemies that move in predictable (or unpredictable) patterns
- every level has a goal!

## todo

- [ ] level design
- [ ] level select
- [ ] main menu
- [ ] settings
- [ ] music and sfx
- [ ] boss
- [ ] itch.io page
- [ ] figure out how to check what mode the level is when won in player
- [x] jumpy item
- [x] more enemy types
- [x] bomb range indicator
- [x] tutorial with npc
- [x] fix timestep issues
- [x] bombo
- [x] making enemies fall
- [x] treasure collection
- [x] timer in the corner
- [x] usable items
- [x] coloring the tiles
- [x] press r to restart
- [x] hold shift to speed up
- [x] item pickup display
- [x] die when hitting enemy
- [x] make the tiles fall
- [x] infinity tiles
- [x] better tile system

## ideas

### clock/timestep order of operations

1. pre_timestep: runs after clock advances
	- enemies move first
	- bomb goes off
2. timestep: runs one process frame after clock advances
	- player steps on current tile
	- player checks current tile for panic
	- everything else that happens every timestep
3. pre_move_missed: runs after timer reaches zero
	- player falls down if current tile is disabled
	- player steps off current tile
4. move_missed: runs after timer reaches zero and clock advances
	- lowkey nothing
