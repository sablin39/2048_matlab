%Window Setup:
%The GUI is created using the uifigure function, which opens a new window.
%It listens to key press events through the KeyPressFcn property, which is linked to the onKeyPress function for handling user inputs.

%Tile Representation:
%The game board is displayed as a 4x4 grid of labels (uilabel).
%Each label represents a tile on the game board. The position and size of each label are set during creation.

%Dynamic Updates:
%The updateBoardDisplay function updates the labels to reflect the current state of the game board.
%When a tile's value changes, its corresponding label's text is updated.

%User Input Handling:
%The onKeyPress function captures arrow key inputs and translates them into game moves ('w', 'a', 's', 'd').
%After processing a move, it updates the board and checks the game status.

function gui()
    % Create the UI figure and configure key press function
    fig = uifigure('Name', '2048 Game', 'KeyPressFcn', @onKeyPress);
    gridSize = 4;
    tileLabels = cell(gridSize);
    [board, ~] = game2048Logic(); % Initialize the game board

    % Create labels for the tiles
    for i = 1:gridSize
        for j = 1:gridSize
            tileLabels{i, j} = uilabel(fig, ...
                                       'Text', '', ...
                                       'BackgroundColor', [0.8 0.8 0.8], ...
                                       'HorizontalAlignment', 'center', ...
                                       'FontSize', 24, ...
                                       'Position', [100*j, 500-100*i, 90, 90]);
        end
    end

    updateBoardDisplay();

    % Function to handle key presses
    function onKeyPress(src, event)
        switch event.Key
            case 'uparrow'
                move = 'w';
            case 'downarrow'
                move = 's';
            case 'leftarrow'
                move = 'a';
            case 'rightarrow'
                move = 'd';
            otherwise
                return; % Ignore other keys
        end

        [board, gameStatus] = game2048Logic(move, board);

        if gameStatus.isNewTileAdded
            updateBoardDisplay();
        end

        if gameStatus.isGameOver
            uialert(fig, 'Game Over!', 'End Game');
        end
    end

    % Function to update the board display
    function updateBoardDisplay()
        for i = 1:gridSize
            for j = 1:gridSize
                if board(i, j) == 0
                    tileLabels{i, j}.Text = '';
                    tileLabels{i, j}.BackgroundColor = [0.8 0.8 0.8];
                else
                    tileLabels{i, j}.Text = num2str(board(i, j));
                    % Optional: Update color based on tile value
                end
            end
        end
    end
end


