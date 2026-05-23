{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    btop
  ];

  home.file."${config.xdg.configHome}/btop/btop.conf" = {
    text = ''
      color_theme = "nord"
      theme_background = false
      truecolor = true
      vim_keys = true
      rounded_corners = true
      terminal_sync = true
      graph_symbol = "braille"
      shown_boxes = "cpu mem net proc"
      update_ms = 2000
      proc_sorting = "cpu lazy"
      proc_reversed = false
      proc_tree = false
      proc_colors = true
      proc_gradient = true
      proc_per_core = false
      proc_mem_bytes = true
      proc_cpu_graphs = true
      proc_left = false
      proc_filter_kernel = false
      proc_follow_detailed = true
      proc_aggregate = false
      keep_dead_proc_usage = false
      cpu_graph_upper = "Auto"
      cpu_graph_lower = "Auto"
      cpu_invert_lower = true
      cpu_single_graph = false
      cpu_bottom = false
      show_uptime = true
      show_cpu_watts = false
      check_temp = true
      cpu_sensor = "Auto"
      show_coretemp = true
      temp_scale = "celsius"
      base_10_sizes = false
      show_cpu_freq = true
      freq_mode = "first"
      clock_format = "%X"
      background_update = true
      custom_cpu_name = ""
      disks_filter = ""
      mem_graphs = true
      mem_below_net = false
      show_swap = true
      swap_disk = true
      show_disks = true
      only_physical = true
      use_fstab = true
      show_io_stat = true
      io_mode = false
      io_graph_combined = false
      net_auto = true
      show_battery = true
    '';
  };

  home.file."${config.xdg.configHome}/btop/themes/nord.theme" = {
    text = ''
      # Nord theme for btop (https://www.nordtheme.com)
      theme[main_bg]="#2E3440"
      theme[main_fg]="#D8DEE9"
      theme[title]="#8FBCBB"
      theme[hi_fg]="#5E81AC"
      theme[selected_bg]="#4C566A"
      theme[selected_fg]="#ECEFF4"
      theme[inactive_fg]="#4C566A"
      theme[proc_misc]="#5E81AC"
      theme[cpu_box]="#4C566A"
      theme[mem_box]="#4C566A"
      theme[net_box]="#4C566A"
      theme[proc_box]="#4C566A"
      theme[div_line]="#4C566A"
      theme[temp_start]="#81A1C1"
      theme[temp_mid]="#88C0D0"
      theme[temp_end]="#ECEFF4"
      theme[cpu_start]="#81A1C1"
      theme[cpu_mid]="#88C0D0"
      theme[cpu_end]="#ECEFF4"
      theme[free_start]="#81A1C1"
      theme[free_mid]="#88C0D0"
      theme[free_end]="#ECEFF4"
      theme[cached_start]="#81A1C1"
      theme[cached_mid]="#88C0D0"
      theme[cached_end]="#ECEFF4"
      theme[available_start]="#81A1C1"
      theme[available_mid]="#88C0D0"
      theme[available_end]="#ECEFF4"
      theme[used_start]="#81A1C1"
      theme[used_mid]="#88C0D0"
      theme[used_end]="#ECEFF4"
      theme[download_start]="#81A1C1"
      theme[download_mid]="#88C0D0"
      theme[download_end]="#ECEFF4"
      theme[upload_start]="#81A1C1"
      theme[upload_mid]="#88C0D0"
      theme[upload_end]="#ECEFF4"
    '';
  };
}
