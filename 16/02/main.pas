program Day_16;

uses strutils, sysutils;
// uses sysutils;

const
    START_INPUT = '10111100110001111';
    // MAX_LENGTH = 272;
    MAX_LENGTH = 35651584;

var
    // reverse: boolean;
    data: ansistring;
    chunk: ansistring;
    checksum: ansistring;
    readData: longint;
    tmp: ansistring;
    chunksize: longint;
    joiners: ansistring;
    joinerIndex: longint;


function flipBits(const str: string): ansistring;
var    
    s: ansistring;
begin
    s:=copy(str, 1, length(str));
    s:=StringReplace(s, '0', 'N', [rfReplaceAll]);
    s:=StringReplace(s, '1', 'E', [rfReplaceAll]);
    s:=StringReplace(s, 'N', '1', [rfReplaceAll]);
    s:=StringReplace(s, 'E', '0', [rfReplaceAll]);
        
    flipBits:=s;
end;

function generateJoiners(): integer;
var
    size: integer;
begin
    size:=Round(MAX_LENGTH / length(START_INPUT)) + 1;
    joiners:='0';
    joinerIndex:=1;

    while(length(joiners) < size) do
    begin
        joiners:=concat(joiners, '0', flipBits(ReverseString(joiners)));
    end;    
        
    generateJoiners:= 0;
end;

function getChunksize(const input: integer): integer;
var
    i: integer;
begin
    i:=input;

    while((i and 1) = 0) do
    begin
        i:=Round(i / 2);
    end;

    getChunksize:=Round(input / i);
end;

function generateData(): ansistring;
var    
    reversed: ansistring;
    copied: ansistring;
    flipped: ansistring;
begin
    copied:=copy(START_INPUT, 1, length(START_INPUT));
    reversed:=ReverseString(copied);
    flipped:=flipBits(reversed);
    
    generateData:=concat(START_INPUT, joiners[joinerIndex], flipped);
    joinerIndex:=joinerIndex+1;
end;


function generateChecksum(const chunk: ansistring): ansistring;
var
    count: longint;
    i: longint;
begin
    count:=0;
    i:=0;
    while(i <= length(chunk)) do
    begin
        if chunk[i] = '1' then
            count:=count+1;

        i:=i+1;
    end;

    // write(chunk);
    // writeln('Generating checksum for chunk:');
    // writeln(chunk);
    // writeln('Count of "1"s is: ', count);
    // write('Count of "1"s is: ');
    // if((count and 1 ) = 0) then
    //     writeln('even')
    // else
    //     writeln('odd');


    if((count and 1) = 0) then
        generateChecksum:='1'
    else
        generateChecksum:='0';
end;


begin    
    readData:=0;
    chunksize:=getChunksize(MAX_LENGTH);
    data:='';
    checksum:='';

    generateJoiners();

    // writeln(chunksize);
    // exit();

    while(length(checksum) < Round(MAX_LENGTH / chunksize)) do
    begin
        while(length(data) < chunksize) do
        begin
            tmp:=generateData();
            readData:=readData+length(tmp);
            data:=concat(data, tmp);
        end;

        // writeln('Data before:');
        // writeln(data);

        chunk:=copy(data, 1, chunksize);        
        data:=copy(data, chunksize+1, length(data));

        // writeln('Chunk:');
        // writeln(chunk);

        // writeln('Data after:');
        // writeln(data);
        
        checksum:=concat(checksum, generateChecksum(chunk));
        
    end;

    writeln();
    writeln();
    writeln(checksum);
    
end.