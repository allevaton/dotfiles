function jira
    set -l token_file ~/.config/fish/secrets/jira-token
    if not test -f $token_file
        mkdir -p (dirname $token_file)
        op read "op://Employee/SidelineSwap Jira/linear jira sync" > $token_file
        or begin
            echo "Failed to fetch Jira token from 1Password" >&2
            return 1
        end
        chmod 600 $token_file
    end
    env JIRA_API_TOKEN=(cat $token_file) command jira $argv
end
