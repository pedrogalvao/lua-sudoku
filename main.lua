require "sudoku"
require "print"


function create_puzzle()
    
    local complete_board = create_full_board()
    local incomplete_board = copy_board(complete_board)
    local solutions = {}

    -- Remove as many numbers as possible while keeping only one solution to the puzzle
    for _, x in ipairs(random_array()) do
        for _, y in ipairs(random_array()) do
            local pos_x, pos_y = x-1, y-1
            if incomplete_board[pos_x][pos_y] ~= 0 then
                local next_incomplete_board, _ = copy_board_and_erase_value(incomplete_board, pos_x, pos_y)
                solutions = get_all_solutions(next_incomplete_board)
                if #solutions == 1 then
                    incomplete_board = next_incomplete_board
                end
            end
        end
    end
    return incomplete_board, complete_board
end

print("Creating new sudoku puzzle...")
local puzzle, solution = create_puzzle()

local puzzle_file = io.open("puzzle.txt", "w")
puzzle_file:write(board_tostring(puzzle))
puzzle_file:close()

local solution_file = io.open("solution.txt", "w")
solution_file:write(board_tostring(solution))
solution_file:close()

print("Sudoku puzzle generated:")
print_board(puzzle)
print("Solution saved to 'solution.txt'")
