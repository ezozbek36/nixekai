{...}: {
  powerManagement = {
    enable = true;
  };

  services.thermald = {
    enable = true;
  };

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    pd.enable = true;
    settings = {
      # ============================================
      # AC Mode: Plugged In - Go Fast
      # ============================================
      # Run CPU at full speed all the time when charging
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      # Allow CPU to use its entire speed range (0-100%)
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;

      # Turn on Turbo Boost for extra speed bursts
      CPU_BOOST_ON_AC = 1;

      # ============================================
      # Battery Mode: Smart Power Saving
      # ============================================
      # Let the CPU slow down when idle to save battery
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Be efficient, but still responsive when you need it
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";

      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 100;

      # Keep Turbo Boost enabled so single-threaded tasks stay snappy
      CPU_BOOST_ON_BAT = 1;

      # ============================================
      # Platform Power Profiles
      # ============================================
      # What gets applied when you switch power modes in your desktop environment
      PLATFORM_PROFILE_ON_AC = "performance"; # Plugged in: go fast
      PLATFORM_PROFILE_ON_BAT = "balanced"; # On battery: be smart

      # ============================================
      # Fine-Tuning for Responsiveness
      # ============================================
      # Intel's dynamic boosting - helps CPU react quickly to sudden workloads
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;

      # ============================================
      # Device-Level Power Savings
      # ============================================
      # PCIe power management: gentle when plugged in, aggressive on battery
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # WiFi power saving: off when charging (better latency), on for battery life
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Let USB devices sleep when not in use, but keep Bluetooth awake
      # (prevents annoying mouse/keyboard disconnects)
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_BTUSB = 1;

      # Hard drive power management: always on when plugged in, auto on battery
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";

      # Audio chip power saving: disabled when charging, enabled on battery
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      # Let the kernel automatically manage device power states
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };
}
