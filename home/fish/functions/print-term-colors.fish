function print-term-colors -d "Show all terminal colors (0-255)"
    for i in (seq 0 255)
        echo (tput setaf $i)"This is color 󱓻 $i"(tput sgr0)
    end
end
