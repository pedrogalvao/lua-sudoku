require "util"
require "print"


function create_empty_board()
    local board = {}
    for i = 0, 8 do
        board[i] = {}
        for j = 0, 8 do
            board[i][j] = 0
        end
    end
    return board
end


function create_possibilities_board()
    -- one set of booleans for each square indicating what numbers are valid candidates for such square
    local board = {}
    for i = 0, 8 do
        board[i] = {}
        for j = 0, 8 do
            board[i][j] = {}
            for n = 1, 9 do
                board[i][j][n] = true
            end
        end
    end
    return board
end


function write_value(board, possibilities, value, pos_x, pos_y)
    board[pos_x][pos_y] = value
    for n, x in ipairs(possibilities[pos_x][pos_y]) do
        if value == n then
            possibilities[pos_x][pos_y][value] = true
        else
            possibilities[pos_x][pos_y][value] = false
        end
    end
    for pos_x2 = 0,8 do
        -- column
        possibilities[pos_x2][pos_y][value] = false
    end
    for pos_y2 = 0,8 do
        -- line
        possibilities[pos_x][pos_y2][value] = false
    end
    local qx = math.floor(pos_x/3)
    local qy = math.floor(pos_y/3)
    -- quadrant
    for i=0,2 do
        for j=0,2 do
            possibilities[3*qx+i][3*qy+j][value] = false
        end
    end
end


function solution_step(board, possibilities)
    local changed = false
    for pos_x = 0,8 do 
        for pos_y = 0,8 do
            if board[pos_x][pos_y] == 0 then
                local options_count = 0
                local last_value = 0
                for value, possible in ipairs(possibilities[pos_x][pos_y]) do
                    if possible == true then
                        options_count = options_count + 1
                        last_value = value
                    end
                end
                if options_count == 1 then 
                    write_value(board, possibilities, last_value, pos_x, pos_y)
                    changed = true
                end
            end
        end
    end
    return changed
end


function solve_partially(board, possibilities)
    -- attempt to solve using basic strategy: ruling out numbers in the same column line or quadrant
    -- returns the board with full or partial solution and a boolean indicating whether it is solved or not
    local b = copy_board(board)
    local changed = true
    while changed do
        changed = solution_step(b, possibilities)
    end
    for pos_x = 0,8 do
        for pos_y = 0,8 do
            if b[pos_x][pos_y] == 0 then
                return b, false
            end
        end
    end
    return b, true
end


function copy_board_and_write_value(board, possibilities, value, pos_x, pos_y)
    local b = copy_board(board)
    local p = copy_pboard(possibilities)
    write_value(b, p, value, pos_x, pos_y)
    return b, p
end


function copy_board_and_erase_value(board, pos_x, pos_y)
    local b = copy_board(board)
    b[pos_x][pos_y] = 0
    return b
end


function check_is_possible(board, possibilities)
    for pos_x = 0,8 do
        for pos_y = 0,8 do
            if board[pos_x][pos_y] == 0 and count_options(possibilities[pos_x][pos_y]) == 0 then
                -- Found an empty without any possible candidates
                return false
            end
        end
    end
    return true
end


function complete_board(board, possibilities)
    board = solve_partially(board, possibilities)
    for pos_x = 0,8 do
        for pos_y = 0,8 do
            if board[pos_x][pos_y] == 0 and count_options(possibilities[pos_x][pos_y]) == 0 then
                return false
            elseif board[pos_x][pos_y] == 0 then
                for _, n in ipairs(random_array()) do
                    if possibilities[pos_x][pos_y][n] then
                        local board2, p2 = copy_board_and_write_value(board, possibilities, n, pos_x, pos_y)
                        if check_is_possible(board2, p2) then
                            local final_board = complete_board(board2, p2)
                            if final_board then
                                return final_board
                            end
                        end
                    end
                end
                -- print("depth", depth)
                return false
            end
        end
    end
    return board
end


function create_full_board()
    b = create_empty_board()
    p = create_possibilities_board()
    math.randomseed( os.time() + os.clock() * 1000)
    b = complete_board(b, p)
    return b
end


function get_possibilities(board)
    local p = create_possibilities_board()
    for pos_x = 0,8 do
        for pos_y = 0,8 do
            if board[pos_x][pos_y] ~= 0 then
                write_value(board, p, board[pos_x][pos_y], pos_x, pos_y)
            end
        end
    end
    return p
end


function get_all_solutions_aux(board, possibilities, solutions)
    for pos_x = 0,8 do
        for pos_y = 0,8 do
            if board[pos_x][pos_y] == 0 and count_options(possibilities[pos_x][pos_y]) == 0 then
                return false
            elseif board[pos_x][pos_y] == 0 then
                for _, n in ipairs(random_array()) do
                    if (possibilities[pos_x][pos_y][n]) then
                        local board2, p2 = copy_board_and_write_value(board, possibilities, n, pos_x, pos_y)
                        if check_is_possible(board2, p2) then
                            local solved
                            board2, solved = solve_partially(board2, p2)
                            if solved then
                                table.insert(solutions, board2)
                            else
                                local final_board = get_all_solutions_aux(board2, p2, solutions)
                                if final_board then
                                    table.insert(solutions, final_board)
                                end
                            end
                        end
                    end
                end
                return false
            end
        end
    end
    return solutions
end


function get_all_solutions(board)
    local solutions = {}
    get_all_solutions_aux(board, get_possibilities(board), solutions)
    return solutions
end
