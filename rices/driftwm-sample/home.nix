{ config, pkgs, inputs, lib, ... }:

let
  driftwmPkg = inputs.driftwm.packages.${pkgs.stdenv.system}.default;
  driftwmConfig = pkgs.writeText "driftwm-config.toml" ''
      # driftwm-sample — config managed via Nix, editable at ~/.config/driftwm/config.toml

      autostart = [
        "wl-paste --type text --watch cliphist store",
        "wl-paste --type image --watch cliphist store",
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1",
        "vorta -d",
        "${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/battery_notify.sh",
        "swayidle -w timeout 300 'brightnessctl -s set 10%' resume 'brightnessctl -r' timeout 330 '${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/lock.sh' timeout 600 'systemctl suspend' before-sleep '${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/lock.sh'",
    ]

    focus_follows_mouse = false

    [input.keyboard]
    repeat_rate = 75
    repeat_delay = 185

    [env]
    QT_QPA_PLATFORMTHEME = "qt6ct"

    [cursor]
    theme = "elementary"

    [decorations]
    bg_color = "#2A2829"
    fg_color = "#E6E1E0"

    [background]
      type = "shader"
      # Swap path below to try any shader from the KDE collection at ~/kde-shader-wallpaper/
      # path = 
"${config.home.homeDirectory}/.local/share/driftwm-sample/wallpapers/cloudy_fractal.glsl"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/002-Blue.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/1993.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/2D_Clouds.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/3D_Clouds.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Abstract_Glassy_Field.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Abstract_Liquid.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Abstract_Patterns6.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Abstract_Plane.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Abstract_Terrain.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/AlienVoxel.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Anaglyph_Sketch.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Auroras.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Base_Warp.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Biomine.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Booting.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Bottom_of_Water.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Bouncing_Circle.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/channelImage.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Channel_Soup.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/CineShader_Lava.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Circuits.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/City_Flythrough.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/clock.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Cloud_Crystal.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Cloud_Fairies.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Colorful_FBM.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Colorful_Lens.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Color_Grid.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/CoreEngine.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Corridor_Travel.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Cosmic_Cycles.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Craziness.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Crazy_Springs.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Crazy_Waves.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Creation.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/CrumpledWave.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/CubeLines.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Cubic_Dispersal.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Curvature.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Cylintrically_Mapped_Hexagons.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Day_74.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Day_79.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Deformed_Bubbles.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Descent3D.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Descent.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Dez.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Digital_Rain.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/DNA_Tracer.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Dodecaplex.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Domain_Warping.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/DVD_Bounce.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/E1M1.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Earthbound2.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Earthbound3.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Earthbound.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Electric_Sinusoid.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Emissive_Ikura.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Endless_Creature.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Ether.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Exit_the_matrix.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fast_FBM.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fast_Ocean.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fireworks.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Flickering_Stars.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Floating_Color_Bubbles.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Flow_Cells.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fluorescent_Light_Digits.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/FlyOnBuckaroo.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fovea.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fractal111Gaz.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fractal_Flythrough.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fractal_Pyramid.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fractal_Tiling.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Fur_Space_3.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Galaxy_Spirals.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Geodesic_Tiling.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Gibson.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Glass_Candy.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Glow_City.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Grey_Liquid.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Grid_Landscape.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/HappyJumping.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Heartfelt.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Hexcore_Fanart.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Holotech_Voronoi.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/HSV_to_RGB.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Hyperspace_Travel.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Hyper_Tunnel.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Hypnoferromagnetism.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Ice_Fire.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/IFS.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Impact.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Industry_II.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Infinite_Pinballs.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Inside_Matrix.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Invaders.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/IO.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Jelly.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Journey.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Juicy.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/kaleidoscope.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Kifings_Tubes.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Kirby.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Laserworld.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Late_Night_Cubi.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Liberation.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Light_Clock.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Lignettes.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Linescape.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Local_PixelZoom.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/LOVE.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Luminescence.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Mandelbox_Sweeper.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Mandelbrot_Pattern_Decoration.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Mandelbulb.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Matrix.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Metaball.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Midgar.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Minkowski_Tube.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Mist.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Molten_Cube.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/MountainBytes.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/mouse2.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/mouse3.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/mouse.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/N64_Logo.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Neon_Futures.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Neon_Lit_Hexagons.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Neon_Parallax.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Neon_Wires.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Net-2D.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Night_Sky.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Noise_Electric.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Noise_Fun.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Noise_Watery.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Oblivion_Radar.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Ocean_Sky.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Octograms.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/OpArt_2.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Paint_1.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Paint_Archipelago.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Palace_of_mind.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Paper_Kaleidoscope.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Patience_2.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Perspex_Web_Lattice.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Pfhrector.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Pixelated_RGB.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Plasma_Storm.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Pretty_Hip.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Procgen_Planet.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Protean.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/PS3_Home.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/PS3_MenuColor.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/PSX.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Psychedelic_Curlnoise.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Radial_Blur_2k18.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Rainbow_AlienNoise.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Rainbow_Storm.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Rainbow_Twister.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Rainier_Mood.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Raymarched_2D_Sierpinski.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Raymarched_Reflections.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Raymarching_Basic.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Reclaim_Streets.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/RGB_Noise_in_Movement.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Rorschach_Test.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Samsa.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Sanctuary.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Satellite_Eye.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Satori.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Seascape.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Seascape_Sailing.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Server_Room.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Shiny_Circle.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Shiny_Galaxy.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Ship_HUD.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Shuffle_Box.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/SIG2014.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Simple.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Simple_Refraction.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Sine_Animation.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Sine_Dunes.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Single_Fractal.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Sin_Wave.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Slug_Ring.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Snail.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Snow_Falling.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Spacebubbles.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Space_Curvature.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/SpaceCurvature.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Space_Donuts.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Spell_Demon_Souls.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Spherical_Polyhedra.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Spiky_Gyroid.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Stained_Lights.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/StarField_Practice.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Star_Nest.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Stars_and_Galaxy.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/String_Theory.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Submerge_3.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Sunset_925.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Sunset_Cyber.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Supah_Relax.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/SuperPlumber.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Synthwave_city.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Taste_of_Noise_15.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Taste_of_Noise_7_mod.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Taste_of_Noise9.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Tetragrammaton.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Text.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/The_Universe_Within.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Torus_Thingy.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Triangle_Grid_Contouring.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Tribute_Marc-AntoineMathieu.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Twisted_Columns.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Twisted_Rings.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/UI_Noise_halo.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/UV_Manipulation.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/VDJ.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Vortex_Dust.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Voxel_Land_2.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Voxel_Tunnel.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Warped_LiquidMetal.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Warping.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Warping_Procedural1.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Waves.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Waves_Portrait.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Wavy_Background_Effect.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Wiggle_Worm.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Wolfenstein.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Worms.frag"
      # path = "${config.home.homeDirectory}/kde-shader-wallpaper/package/contents/ui/Shaders/Xyptonjtroz.frag"

    [output.outline]
    color="#2A2829"

    [mouse]
    decoration_resize_snapped = true
    decoration_fit_snapped = true

    [keybindings]
    "mod+return" = "exec ptyxis -s"
    "mod+d" = "exec noctalia-shell ipc call launcher toggle"
    # "mod+s" = "exec 
${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/window-search.sh"
    "mod+l" = "exec ${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/lock.sh"
    "mod+semicolon" = "spawn ${config.home.homeDirectory}/.local/share/driftwm-sample/scripts/lock.sh"
    "mod+n" = "exec noctalia-shell ipc call notificationHistory toggle"
    "XF86AudioRaiseVolume" = "exec noctalia-shell ipc call volume increase"
    "XF86AudioLowerVolume" = "exec noctalia-shell ipc call volume decrease"
    "XF86AudioMute" = "exec noctalia-shell ipc call volume muteOutput"
    "XF86MonBrightnessUp" = "exec noctalia-shell ipc call brightness increase"
    "XF86MonBrightnessDown" = "exec noctalia-shell ipc call brightness decrease"
    "mod+r" = "reload-config"
    "mod+m" = "fit-window-snapped"
    "mod+period" = "fit-window"

    [gestures.on-window]
    "alt+3-finger-swipe" = "resize-window-snapped"
    "alt+shift+3-finger-swipe" = "resize-window"

    [[outputs]]
    name = "HDMI-A-1"
    transform = "90"

    [[window_rules]]
    app_id = "Alacritty"
    opacity = 0.8
    blur = true

    [[window_rules]]
    app_id = "emacs"
    opacity = 0.90
    blur = true
    decoration = "none"

    [[window_rules]]
    app_id = "Emacs"
    decoration = "none"
    widget = true
  '';
in
{
  imports = [ inputs.noctalia.homeModules.default ./noctalia-shell.nix ];

  home.activation.checkDriftwmConfig = lib.hm.dag.entryBefore ["copyDriftwmConfig"] ''
    /run/current-system/sw/bin/driftwm --config ${driftwmConfig} --check-config || true
  '';

  home.activation.copyDriftwmConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "${config.home.homeDirectory}/.config/driftwm/config.toml" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/driftwm"
      install -m644 "${driftwmConfig}" "${config.home.homeDirectory}/.config/driftwm/config.toml"
    fi
  '';

  home.packages = with pkgs; [
    fuzzel
    swaylock
    swayidle
    wlrctl
    alacritty
    grim
    ffmpeg
    vorta
    polkit_gnome
    elementary-xfce-icon-theme
    everforest-gtk-theme
    ptyxis
    gnome-clocks
    brightnessctl
    libnotify
    wtype
    xwayland
    cliphist
    wl-clipboard
  ];


  home.file = {
    ".local/share/icons/elementary-pastel/index.theme".text = ''
      [Icon Theme]
      Name=elementary-pastel
      Comment=Elementary icons with Mignon-pastel app icons
      Inherits=elementary,Adwaita,hicolor

      Directories=scalable/apps
      ScaledDirectories=scalable@2x/apps

      [scalable/apps]
      Context=Applications
      Size=64
      MinSize=16
      MaxSize=512
      Type=Scalable

      [scalable@2x/apps]
      Context=Applications
      Scale=2
      Size=64
      MinSize=16
      MaxSize=512
      Type=Scalable
    '';

    ".config/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=Adwaita-dark
      gtk-icon-theme-name=elementary-pastel
      gtk-cursor-theme-name=elementary
      gtk-application-prefer-dark-theme=1
    '';

    ".local/share/driftwm-sample/scripts/lock.sh" = {
      text = ''
      #!/bin/sh
      ${pkgs.grim}/bin/grim -l 0 /tmp/lockscreen.png
      ${pkgs.ffmpeg}/bin/ffmpeg -y -i /tmp/lockscreen.png -vf "boxblur=8:2" /tmp/lockblur.png 2>/dev/null
      ${pkgs.swaylock}/bin/swaylock -f -i /tmp/lockblur.png
      '';
      executable = true;
    };

    # ".local/share/driftwm-sample/scripts/battery_notify.sh" = {
    #   text = ''
    #   #!/bin/bash
    #   BATTERY_LOW=15
    #   BATTERY_CRITICAL=5
    #   COOLDOWN=300
    #   STATE_DIR="/tmp/driftwm-battery-notify"
    #   mkdir -p "$STATE_DIR"

    #   check_cooldown() {
    #       local key="$1"
    #       local now=$(date +%s)
    #       local state_file="$STATE_DIR/$key"
    #       if [ -f "$state_file" ]; then
    #           local last=$(cat "$state_file")
    #           [ $((now - last)) -lt $COOLDOWN ] && return 1
    #       fi
    #       echo "$now" > "$state_file"
    #       return 0
    #   }

    #   trap 'rm -rf "$STATE_DIR"; exit 0' EXIT INT TERM

    #   while true; do
    #       bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)
    #       status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -1)

    #       if [ -n "$bat" ] && [ "$status" = "Discharging" ]; then
    #           if [ "$bat" -le "$BATTERY_CRITICAL" ]; then
    #               check_cooldown critical && \\
    #                   notify-send -u critical "Critical Battery" "''${bat}% — plug in immediately"
    #           elif [ "$bat" -le "$BATTERY_LOW" ]; then
    #               check_cooldown low && \\
    #                   notify-send -u normal "Low Battery" "''${bat}% — consider charging soon"
    #           fi
    #       fi

    #       sleep 60
    #   done
    #   '';
    #   executable = true;
    # };

    # ".local/share/driftwm-sample/wallpapers/cloudy_fractal.glsl".source = ./assets/wallpapers/cloudy_fractal.glsl;
    # ".local/share/driftwm-sample/scripts/window-search.sh" = {
    #   text = ''
    #   #!/bin/sh
    #   XDG_DATA_DIRS="''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

    #   lookup_desktop() {
    #       id="$1"
    #       for dir in "$HOME/.local/share/applications" $(printf '%s' "$XDG_DATA_DIRS" | tr ':' ' '); do
    #           for f in "$dir/$id.desktop" "$dir"/*"$id"*.desktop; do
    #               [ -f "$f" ] || continue
    #               name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
    #               icon=$(grep -m1 '^Icon=' "$f" | cut -d= -f2-)
    #               [ -n "$name" ] && printf '%s\t%s' "$name" "''${icon:-$id}" && return
    #           done
    #       done
    #       for dir in "$HOME/.local/share/applications" $(printf '%s' "$XDG_DATA_DIRS" | tr ':' ' '); do
    #           [ -d "$dir" ] || continue
    #           f=$(grep -rl "^StartupWMClass=$id$" "$dir"/*.desktop 2>/dev/null | head -1)
    #           if [ -n "$f" ]; then
    #               name=$(grep -m1 '^Name=' "$f" | cut -d= -f2-)
    #               icon=$(grep -m1 '^Icon=' "$f" | cut -d= -f2-)
    #               [ -n "$name" ] && printf '%s\t%s' "$name" "''${icon:-$id}" && return
    #           fi
    #       done
    #       printf '%s\t%s' "$id" "$id"
    #   }

    #   display=$(mktemp)
    #   lookup=$(mktemp)
    #   trap 'rm -f "$display" "$lookup"' EXIT

    #   i=0
    #   wlrctl toplevel list | while IFS= read -r line; do
    #       app_id="''${line%%: *}"
    #       title="''${line#*: }"
    #       desktop=$(lookup_desktop "$app_id")
    #       app_name="''${desktop%%\t*}"
    #       icon="''${desktop#*\t}"
    #       printf '%s  %s\0icon\x1f%s\n' "$title" "$app_name" "$icon" >> "$display"
    #       printf '%s\t%s\n' "$app_id" "$title" >> "$lookup"
    #       i=$((i + 1))
    #   done

    #   [ -s "$display" ] || exit 0

    #   selected=$(fuzzel --dmenu \
    #       --prompt="Window: " \
    #       --no-run-if-empty \
    #       --index \
    #       < "$display")

    #   [ -z "$selected" ] && exit 0

    #   line_num=$((selected + 1))
    #   match=$(sed -n "''${line_num}p" "$lookup")
    #   sel_app_id="$(printf '%s' "$match" | cut -f1)"
    #   sel_title="$(printf '%s' "$match" | cut -f2)"

    #   exec wlrctl toplevel focus "app_id:$sel_app_id" "title:$sel_title"
    #   '';
    #   executable = true;
    # };


  };

  systemd.user.startServices = "sd-switch";

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${config.home.profileDirectory}/bin/noctalia-shell";
      Restart = "always";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
