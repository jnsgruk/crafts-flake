{ modulesPath, flake, pkgs, ... }: {
  imports = [ "${modulesPath}/virtualisation/qemu-vm.nix" ];
  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.overlays = [ flake.outputs.overlay ];

  # These values are tuned such that the VM performs on Github Actions runners.
  virtualisation = {
    forwardPorts = [{ from = "host"; host.port = 2222; guest.port = 22; }];
    cores = 2;
    memorySize = 5120;
    diskSize = 10240;
  };

  # Root user without password and enabled SSH for playing around
  networking.firewall.enable = false;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  users.extraUsers.root.password = "password";
  virtualisation.lxd.enable = true;

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "craft-test";
      runtimeInputs = with pkgs; [ unixtools.xxd git snapcraft charmcraft rockcraft ];
      text = builtins.readFile ./craft-test;
    })
  ];
}
