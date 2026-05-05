alias cx=codex
alias cl=claude
alias oc=opencode

function zc { # claude code with glm
  ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
    API_TIMEOUT_MS="3000000" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.7-flash" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.7" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.7" \
    claude "$@"
}

export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000
