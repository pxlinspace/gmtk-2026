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

- [ ] treasure collection
- [ ] making enemies fall
- [ ] more enemy types
- [ ] level design
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

### later
- [ ] tutorial with npc
- [ ] level select
- [ ] main menu
- [ ] settings
- [ ] music and sfx
- [ ] itch.io page
- [ ] boss??

## ideas

### player timestep order of operations

1. check current tile for any items
2. emit stepped on for current tile
  if player presses move:
	3. check validity of tile in that direction
	4. move player to that tile
	5. emit stepped off for previous tile
	6. next timestep
  if player waits until countdown runs out:
	3. emit stepped off for current tile
	4. check current tile validity again for fall check
	5. next timestep
