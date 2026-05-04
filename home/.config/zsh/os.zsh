function __dotfiles_detect_os {
  DOTFILES_OS=unknown
  DOTFILES_OS_ID=
  DOTFILES_OS_ID_LIKE=

  if [[ -r /etc/os-release ]]; then
    local key value

    while IFS='=' read -r key value; do
      value=${value#\"}
      value=${value%\"}

      case "$key" in
        ID)
          DOTFILES_OS_ID=$value
          ;;
        ID_LIKE)
          DOTFILES_OS_ID_LIKE=$value
          ;;
      esac
    done < /etc/os-release
  fi

  case "$DOTFILES_OS_ID" in
    arch)
      DOTFILES_OS=arch
      ;;
    ubuntu)
      DOTFILES_OS=ubuntu
      ;;
    *)
      case " $DOTFILES_OS_ID_LIKE " in
        *" arch "*)
          DOTFILES_OS=arch
          ;;
        *" ubuntu "*)
          DOTFILES_OS=ubuntu
          ;;
      esac
      ;;
  esac

  export DOTFILES_OS DOTFILES_OS_ID DOTFILES_OS_ID_LIKE
}

__dotfiles_detect_os
unfunction __dotfiles_detect_os
