{ config, pkgs, imports, ... }:
{
	services.xserver.enable = true;
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;

	# Exclude some KDE stuff
	environment.plasma6.excludePackages = with pkgs.kdePackages; [
		plasma-browser-integration
	];

	# Make it look like GNOME
	#qt = {
		# enable = true;
		# platformTheme = "gnome";
		# style = "adwaita-dark";
	#};
	#programs.dconf.enable = true;
}