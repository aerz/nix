function C -d "Copy stdin into clipboard"
    switch (uname)
        case Darwin
            pbcopy
        case Linux
            wl-copy
        case '*'
            return 1
    end
end
