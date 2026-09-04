## Concept

A 2D Space Invaders clone. The player must defeat all invaders before losing all their lives or Earth sustaining too much damage.

The fewer enemies that remain, the faster the formation moves

## Main Mechanics - Mechanics and Gameplay loop

# Player

- The player moves horizontally and shoots missile up at the alien formation.
- Player missiles can delete enemy bullets
- The player dies in one hit.
- The player has 3 lives.
- When losing a life, the game pauses for a short moment before continuing.

# Enemies
- There are 3 enemies types. With the only difference being the sprites. Besides that, they are fundamentally the same.
- All enemies die in one hit, with the exception of the ovni mothership.
- The aliens move in a formation. The formation moves from side to side, moving downwards when it reaches the edge of the screen, and then reversing direction. (goes right -> all lines move down -> goes left...)
- An ovni mothership occasionally flies behind the alien formation.
- Enemies give points when dying.
- An enemy can only shoot when there is no other enemy directly lower than it.

# Boss

The final boss is significantly different from the normal enemies.

- The boss moves freely rather than following the alien formation's grid-based movement.
- The boss has a health bar and requires multiple hits to defeat.
- The boss can shoot from multiple parts of its body.
- The boss may bleed when damaged.
- The boss may have a more realistic art style compared to the normal enemies.

# Win Condition

- The player kill all aliens and defeat the final boss.

# Lose Condition

- The player loses all life
- Earth is shoot 3 times (2 times on shield, once directly)
- Aliens reach Earth (not shield - shields breaks when reached)

# Core Gameplay Loop

Move -> Aim -> Shoot -> Protect Earth shooting at bullets -> Kill enemies -> Formation moves faster -> Repeat

## Visual / Audio Style

Simple pixel art, soft and moody. Drawn by me.

Enemies have biblical inspirations. As in being sad aliens invading Earth. Each enemy has only 2 sprites that toggle when moving.

Audio should be retro arcades inspired, with a anxiety (when faster) inducing sound accompanying the movement of the alien formation.

The last enemy will be a boss portraying a biblically accurate alien with realistic art style maybe.

## Story

Humanity has been being attacked (being invaded) by aliens for quite some time now. War has brought death and destruction, but humanity managed to push them back with great sacrifices.

The player is the only one left capable of fighting the last invasion attempt. Also, the aliens are crying and we don't know why.

The last enemy will be a boss portraying a biblically accurate alien with realistic art style maybe.

## Timeline

Dialog appears -> "we are all counting on you or something" -> aliens appear -> fight! -> player kills 3 waves -> Boss appears, ominous music -> idk.

## Other

Boss roars
Would be dope if there is some help in the boss, like, the Earth is shoot because you didn't manage to protect it but then a dialog appears just before the Earth is hit and saves you or something. Music changes, etc.
I will use Dialogic 2 for dialogs.

Formation {Base Enemy > Unique Enemy.}
Formation controls the enemy position and if its allowed to fire.
