
function board_tostring(board)
    local s = ""
    for qx = 0,2 do
        s = s.."+---------+---------+---------+\n"
        for i = 0,2 do
            for qy = 0,2 do
                s = s.."|"
                for j = 0,2 do
                    s = s.." "
                    if board[3*qx + i][3*qy + j] == 0 then
                        s = s.." "
                    else
                        s = s..board[3*qx + i][3*qy + j]
                    end
                    s = s.." "
                end
            end
            s = s.."|\n"
        end
    end
    s = s.."+---------+---------+---------+"
    return s
end

function print_board(board)
    print(board_tostring(board))
end

function pboard_tostring(board)
    -- string with number of possibilities for each square
    local s = ""
    for qx = 0,2 do
        s = s.."|"
        for i = 1,29 do
            s = s.."-"
        end
        s = s.."|\n"
        for i = 0,2 do
            for qy = 0,2 do
                s = s.."|"
                for j = 0,2 do
                    s = s.." "
                    options_count = 0
                    for value, possible in ipairs(board[3*qx + i][3*qy + j]) do
                        if possible == true then
                            options_count = options_count + 1
                        end
                    end
                    s = s..tostring(options_count)
                    s = s.." "
                end
            end
            s = s.."|\n"
        end
    end
    s = s.."|"
    for i = 1,29 do
        s = s.."-"
    end
    s = s.."|\n"
    return s
end

function print_pboard(board)
    -- print number of possibilities for each square
    print(pboard_tostring(board))
end
