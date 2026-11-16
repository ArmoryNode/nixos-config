{ stdenv, bash, makeFontsConf, dejavu_fonts, winpodx }:
winpodx.packages.${stdenv.hostPlatform.system}.default.overrideAttrs (old: {
  preCheck = (old.preCheck or "") + ''
    # Test fixtures must use Nix's shell rather than sandbox-unavailable paths.
    substituteInPlace tests/test_arch_release_artifact.py \
      --replace-fail '#!/bin/bash' '#!${bash}/bin/bash'
    substituteInPlace tests/test_install_sh_provision.py \
      --replace-fail '#!/usr/bin/env bash' '#!${bash}/bin/bash'
    # Wrapped text can occupy less than two line spacings, depending on the font.
    substituteInPlace tests/test_launcher.py \
      --replace-fail 'assert label.height() >= 2 * label.fontMetrics().lineSpacing()' \
        'assert label.height() >= label.fontMetrics().boundingRect(0, 0, label.width(), 0, label.alignment() | Qt.TextFlag.TextWordWrap, label.text()).height() > label.fontMetrics().lineSpacing()'
    export FONTCONFIG_FILE=${makeFontsConf { fontDirectories = [ dejavu_fonts ]; }}
  '';
})
