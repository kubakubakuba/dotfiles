# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "iota"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

#  hardware.pulseaudio.configFile = pkgs.writeText "default.pa" ''
#    load-module module-bluetooth-policy
#    load-module module-bluetooth-discover
    ## module fails to load with 
    ##   module-bluez5-device.c: Failed to get device path from module arguments
    ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    # load-module module-bluez5-device
    # load-module module-bluez5-discover
#  '';

#  services.blueman.enable = true;

#  hardware.pulseaudio = {
#    enable = true;
#    package = pkgs.pulseaudioFull;
#  };

#  systemd.user.services.mpris-proxy = {
#    description = "Mpris proxy";
#    after = [ "network.target" "sound.target" ];
#    wantedBy = [ "default.target" ];
#    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
#  };

  #gnupg pinentry fix
  services.pcscd.enable = true;
  programs.gnupg.agent = {
   enable = true;
   pinentryFlavor = "curses";
   enableSSHSupport = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "cz";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "cz-lat2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment.etc = {
	"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
		bluez_monitor.properties = {
			["bluez5.enable-sbc-xq"] = true,
			["bluez5.enable-msbc"] = true,
			["bluez5.enable-hw-volume"] = true,
			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
		}
	'';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #fix for Steam
  hardware.opengl.driSupport32Bit = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jakub = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Jakub Pelc";
    extraGroups = [ "networkmanager" "wheel" "plugdev" ];
    packages = with pkgs; [
	brave
	kate
	discord
	vscode
	steam
	
	#rtl sdr stuff
	libusb
	rtl-sdr
	gqrx
	avahi

	rpi-imager
	tigervnc

	filezilla
	vlc
	obs-studio

	ntfs3g #to mount NTFS storage
    ];
  };

  # RTL SDR
  #boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ];
  services.udev.packages = [ pkgs.rtl-sdr ];
  hardware.rtl-sdr.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  #####virtualbox
  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "jakub" ];

  #virtualisation.virtualbox.host.enableExtensionPack = true;

  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.draganddrop = true;
  #####

  ##### virt manager (quemu)
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  #####

  #####distrobox
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  environment.systemPackages = with pkgs; [
    	neovim
	netcat
	wget
	curl
	zip
	unzip
	git
	gnumake
	cmake
	gcc
	python3
	zsh
	kitty
	graphviz
	nodejs_21
	libz
	gnupg
	pinentry-curses

	libreoffice
	ffmpeg
	imagemagick
	yt-dlp
	texliveFull

	htop
	postgresql_16_jit

	distrobox

	gtk4
	pkg-config
  ];

  #disable keyboard backlight from turning on after sleep
  systemd.services.disable-keyboard-backlight = {
    enable = true;
    description = "Disable keyboard backlight on resume";
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      /run/current-system/sw/bin/echo 0 > "/sys/devices/platform/thinkpad_acpi/leds/tpacpi::kbd_backlight/brightness"
    '';
    wantedBy = [
      "sleep.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];
    after = [
      "sleep.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
