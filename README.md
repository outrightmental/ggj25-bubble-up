[![CI distro](https://github.com/outrightmental/ggj25-bubble-up/actions/workflows/ci_distro.yaml/badge.svg)](https://github.com/outrightmental/ggj25-bubble-up/actions/workflows/ci_distro.yaml)

# Bubble Up!

## [Play Bubble Up!](https://bubbleup.game.outright.io/)

Made for the [Global Game Jam 2025](https://globalgamejam.org/)

## Development

Built in [Godot Engine](https://godotengine.org/) with [GDScript](https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/gdscript_basics.html).

### Continuous Integration

To streamline collaboration, whenever a commit arrives to the main branch of this repository, continuous integration (CI)
will automatically [build and deploy](.github/workflows/ci_distro.yaml) the game to [web distro](https://bubbleup.game.outright.io/).
To further accelerate development and avoid caching issues, web distro is on AWS S3 behind a CloudFront CDN.

## Planning

[Project Planning Board](https://github.com/orgs/outrightmental/projects/3)

[Game Design Document](https://docs.google.com/document/d/1g5JiKOtvELIJ4hxtOLf85_iAelxOdMFgVLmL_Qs7VBM/edit?tab=t.0)
