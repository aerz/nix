{ ... }:
{
  programs.fzf = rec {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    defaultCommand = "fd --hidden --no-ignore-vcs --exclude .git --exclude node_modules -td -tf";
    # ctrl+t
    fileWidgetCommand = defaultCommand;
    fileWidgetOptions = [
      "--bind=ctrl-/:toggle-preview"
      "--preview='bat -n --color=always --line-range :500 {}'"
    ];
    # alt+c
    changeDirWidgetCommand = "fd --hidden --no-ignore-vcs --exclude .git --exclude node_modules -td";
    changeDirWidgetOptions = [
      "--bind=ctrl-/:toggle-preview"
      "--preview 'eza --tree --level=3 --group-directories-first --color=always -F {}'"
    ];
    # theme
    defaultOptions = [
      "--color=fg:-1,fg+:#dde4e0,bg:-1,bg+:#282a2e"
      "--color=hl:#81a2be,hl+:#6aaee9,info:#f0c674,marker:#b5bd68"
      "--color=prompt:#b294bb,spinner:#81a2be,pointer:#cc6666,header:#8abeb7"
      "--color=border:#373b41,label:#aeaeae,query:#dde4e0"
      "--prompt='. '"
    ];
  };
}
