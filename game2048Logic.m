function [board, gameStatus] = game2048Logic(operation, board)
    % Define the initial game status
    gameStatus = struct('isGameOver', false, 'isNewTileAdded', false, 'score', 0);

    % Initialize the game board if needed
    if nargin < 2 || isempty(board)
        board = zeros(4,4);
        board = addNewTile(board);
        board = addNewTile(board);
        return;
    end

    % Execute the operation
    if isValidMove(board, operation)
        [board, score] = makeMove(board, operation);
        board = addNewTile(board);
        gameStatus.isNewTileAdded = true;
        gameStatus.score = score;
        if isGameOver(board)
            gameStatus.isGameOver = true;
        end
    end
end

function board = addNewTile(board)
    [emptyX, emptyY] = find(board == 0);
    if isempty(emptyX)
        return;
    end
    idx = randi(length(emptyX));
    board(emptyX(idx), emptyY(idx)) = 2 * (randi([1,2]));
end

function valid = isValidMove(board, move)
    tempBoard = makeMove(board, move);
    valid = ~isequal(board, tempBoard);
end

function [board, score] = makeMove(board, move)
    score = 0;
    for i = 1:4
        if move == 'w' || move == 's'
            line = board(:, i);
        else
            line = board(i, :);
        end

        [line, tempScore] = processLine(line, move);
        score = score + tempScore;

        if move == 's' || move == 'd'
            line = fliplr(line);
        end

        if move == 'w' || move == 's'
            board(:, i) = line';
        else
            board(i, :) = line;
        end
    end
end

function [line, score] = processLine(line, move)
    line = line(line ~= 0);  % Remove zeros
    [line, score] = mergeTiles(line);  % Merge tiles
    line(end+1:4) = 0;  % Fill with zeros
    if move == 's' || move == 'd'
        line = fliplr(line);
    end
end

function [line, score] = mergeTiles(line)
    score = 0;
    for j = 1:length(line)-1
        if line(j) == line(j+1)
            line(j) = 2 * line(j);
            score = score + line(j);  % Update score
            line(j+1) = 0;
        end
    end
    line = line(line ~= 0);  % Remove zeros after merge
end

function over = isGameOver(board)
    over = isempty(find(board == 0, 1)) && ...
           ~isValidMove(board, 'w') && ...
           ~isValidMove(board, 's') && ...
           ~isValidMove(board, 'a') && ...
           ~isValidMove(board, 'd');
end
