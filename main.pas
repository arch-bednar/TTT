program main;

{$mode Delphi}

uses
        sysutils,
        Crt;

type
        TPlayer = packed record
                name: String;
                surname: String;
                age: Integer;
        end;

        TFields = array of array of Char;



{takes reference to TPlayer type (record) and write its fields}
procedure createPlayer(var newPlayer: TPlayer);
var
    firstname: String;
    lastname: String;
    currAge: Integer;
begin
        Write('Press type player name: ');
        Readln(firstname);

        Write('Press type player surname: ');
        Readln(lastname);

        Write('Press enter player age: ');
        Readln(currAge);

        with newPlayer do
        begin
                name := firstname;
                surname := lastname;
                age := currAge;
        end;

        Writeln('New player created');

end;



{fills array at the beggining with empty fields}
function fillArray() : TFields;
var
        tab : TFields;
        row, col: Integer;
begin
        SetLength(tab, 3, 3);

        for row:=Low(tab) to High(tab) do
        begin
            for col:=Low(tab[0]) to High(tab[0]) do
            begin
                tab[row][col] := ' ';
            end;
        end;
        fillArray := tab;
end;



{prints Fields array as a Board of game}
procedure printBoard(Fields: TFields);
var
        row, col, lines: Integer;
begin

        for row:=Low(Fields) to High(Fields) do
        begin

            Write('  ');

            for col:=Low(Fields[row]) to High(Fields[row]) do
            begin
                Write('|', Fields[row][col]);
            end;
            Writeln('|');

            if row < 2 then
            begin
                for lines:=1 to 11 do
                begin
                        Write('-');
                        end;
                        Writeln;
                end;
            end;

            Writeln;
end;



{checks if array Fields is filled}
function isFilled(Fields: TFields): Boolean;
var
        row, col: Integer;
        filled: Boolean = true;
begin
        for row:=Low(Fields) to High(Fields) do
        begin
            for col:=Low(Fields[row]) to High(Fields[row]) do
            begin
                if Fields[row][col] = ' ' then
                        filled := false;
            end;
        end;

        //return statement
        isFilled := filled;
end;




{check vonNeumann neighbourhood}
function vonNeumann(Fields: TFields): Boolean;
var
        row, col: Integer;
        won: Boolean = false;
        rowT, colT: Integer;
        count: Byte = 0;
begin
        for row:= Low(Fields) to High(Fields) do
        begin
                for col:= Low(Fields[row]) to High(Fields[row]) do
                begin
                        if Fields[row][col] = ' ' then
                                continue;

                        for rowT:=row-1 to row+1 do
                        begin
                                if rowT = row then
                                        continue;

                                if (rowT < 0) or (rowT > 2) then
                                        continue;

                                if Fields[rowT][col] = Fields[row][col] then
                                        count := count + 1;
                        end;


                        if count = 2 then
                                won := true;

                        count := 0;
                        for colT:=col-1 to col+1 do
                        begin
                                if colT = col then
                                        continue;

                                if (colT < 0) or (colT > 2) then
                                        continue;

                                if Fields[row][colT] = Fields[row][col] then
                                        count := count + 1;
                        end;

                        if count = 2 then
                                won := true;
                        count:= 0;
                end;
        end;
        vonNeumann:=won;
end;




{checks if won by diagonal}
function diagonal(Fields: TFields): Boolean;
var
        won: Boolean = false;
begin
        if (Fields[1][1] <> ' ') then
        begin

                if (Fields[1][1] = Fields[0][0]) and (Fields[1][1] = Fields[2][2]) then
                        won:=true;

                if (Fields[1][1] = Fields[2][0]) and (Fields[1][1] = Fields[0][2]) then
                        won:=true;

        end;

        diagonal:=won;
end;




{checks if current player won}
function isWon(Fields: TFields; player: Byte): Boolean;
begin
        if vonNeumann(Fields) or diagonal(Fields) then
                isWon := true
        else
                isWon := false;
end;




{checks if is draw}
function isDraw(Fields:TFields): Boolean;
var
        filled: Integer = 0;
        row, col: Integer;
begin
        for row:=Low(Fields) to High(Fields) do
        begin
                for col:=Low(Fields[row]) to High(Fields[row]) do
                begin
                        if (Fields[row][col] = 'X') or (Fields[row][col] = 'O') then
                                Inc(filled);
                end;
        end;

        if filled = 9 then
                isDraw := true
        else
                isDraw := false;
end;



procedure fillCell(var Fields: TFields; var turn: Byte);
var
        changed: Boolean = false;
        row, col: Integer;
        choiceX, choiceY: Byte;
begin

        while not changed do
        begin

        Write('Choose your cell [x,y][0-2, 0-2]: ');
        Readln(choiceX, choiceY);

        if (choiceX >= 0) and (choiceX <= 2) and (choiceY >= 0) and (choiceY <= 2) then
        begin

                if Fields[choiceX][choiceY] = ' ' then
                begin
                        if turn = 0 then
                        begin
                                 Fields[choiceX][choiceY] := 'O';
                                        //turn := 1;
                        end else
                        begin
                                Fields[choiceX][choiceY] := 'X';
                                //turn := 0;
                        end;

                        changed:=true;
                end else
                begin
                        Writeln('Popraw');
                        printBoard(Fields);
                end;

        end else if (choiceX = 3) or (choiceY = 3) then
        begin
                turn := 3;
                changed:=true;
        end else
                Writeln('Popraw');
                printBoard(Fields);
        end;
end;



{procedure for pvp game}
procedure PVP();
var
        newPlayerOne: TPlayer;
        newPlayerTwo: TPlayer;

        Fields: array of array of Char;
        inGame: Boolean = true;
        turn: Byte;
        choice: Integer;
begin
        turn := 0;
        createPlayer(newPlayerOne);
        createPlayer(newPlayerTwo);
        Fields := fillArray();
        printBoard(Fields);
        Writeln(isFilled(Fields));
        Writeln(isDraw(Fields));
        Writeln(isWon(Fields, turn));

        while (turn = 1) or (turn = 0) do
        begin
                fillCell(Fields, turn);
                printBoard(Fields);
                if turn > 1 then
                begin
                        Writeln('Game is stopped');
                        continue;
                end;
                if(isWon(Fields, turn)) then
                begin
                    if turn = 0 then
                        Writeln('Player ' , newPlayerOne.name, ' ', newPlayerOne.surname, ' won!')
                    else
                        Writeln('Player ', newPlayerTwo.name, ' ', newPlayerTwo.surname, ' won!');
                    turn := 3;
                    continue;
                end;

                if(isDraw(Fields)) then
                begin
                        Writeln('Draw');
                        turn := 3;
                        continue;
                end;

                if turn = 0 then
                        turn := 1
                else
                        turn := 0;
        end;
        readln;
end;



{checks x,y}
function check(Fields: TFields; x: Byte; y: Byte): Boolean;
begin

        if Fields[x][y] = ' ' then
                check := true
        else
                check := false;

end;




{computer fills cell}
procedure computerFills(var Fields: TFields);
var
        x,y: Byte;
begin

        x := Random(3);
        y := Random(3);

        while not(check(Fields, x, y)) do
        begin
            x := Random(3);
            y := Random(3);
        end;

        Fields[x][y] := 'O';
end;



{procedure for player vs computer}
procedure PVC();
var
        Player: TPlayer;
        Fields: array of array of Char;
        inGame: Boolean = true;
        turn: Byte = 0;
begin

        createPlayer(Player);
        Fields := fillArray();
        while (turn = 0) or (turn = 1) do
        begin
                case turn of
                        1:
                        {player turn}
                        begin
                            fillCell(Fields, turn);
                            if turn > 1 then
                            begin
                                Writeln('Game is stopped');
                                continue;
                            end;
                        end;
                        {end of player turn}

                        0:
                        {computer turn}
                        begin
                                computerFills(Fields);
                        end;
                        {end of computer turn}
                end;


                printBoard(Fields);


                if (isWon(Fields, turn)) then
                begin
                        if turn = 1 then
                                Writeln('Player ' , Player.name, ' ', Player.surname, ' won!')
                        else
                                Writeln('Computer has won!');
                                turn := 3;
                                continue;
                        end;

                        if(isDraw(Fields)) then
                        begin
                                Writeln('Draw');
                                turn:=3;
                                continue;
                        end;

                        if turn = 0 then
                                turn := 1
                        else
                                turn := 0;

                end;
end;

{main block}
var
        mode: Integer;
begin
        Writeln('Welcome in tictactoe game!');

        Writeln('Please choose game mode');
        Write('[0] - PVP, [1] - Player VS Computer, [2] - Quit');
        Readln(mode);


        case mode of
                0: PVP();
                1: PVC();
                else
                        Writeln('End');
        end;
        readln;
end.
