function psgrep --description 'grep ps aux output, keeping the header'
    ps aux | head -1
    ps aux | grep $argv
end
