get_git_status() {
  inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
  if [ "$inside_git_repo" ]; then;
    upstream=`git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)`
    if [ -z "$upstream" ]; then;
      echo "%{$fg_bold[red]%}(No upstream)%{$reset_color%} "
    else
      count=`git log --oneline @{u}.. | wc -l | awk '{ print $1 }'`
      if [ $count -gt 0 ]; then
        echo "%{$fg_bold[red]%}($count)%{$reset_color%} "
      fi
    fi
  fi
}

PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)$(get_git_status)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
