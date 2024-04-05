
function copy_board(board)
    local board_copy = {}
    for pos_x = 0,8 do
        board_copy[pos_x] = {}
        for pos_y = 0,8 do
            board_copy[pos_x][pos_y] = board[pos_x][pos_y]
        end
    end
    return board_copy
end


function copy_pboard(board)
    local board_copy = {}
    for pos_x = 0,8 do
        board_copy[pos_x] = {}
        for pos_y = 0,8 do
            board_copy[pos_x][pos_y] = {}
            for n = 1,9 do
                board_copy[pos_x][pos_y][n] = board[pos_x][pos_y][n]
            end
        end
    end
    return board_copy
end


function random_array()
    local a = {}
    for i=1,9 do
        local pos = math.random(1, #a+1)
        table.insert(a, pos, i)
    end
    return a
end


function count_options(opt)
    local options_count = 0
    for value, possible in ipairs(opt) do
        if possible == true then
            options_count = options_count + 1
        end
    end
    return options_count
end
