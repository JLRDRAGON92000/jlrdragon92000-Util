#!/usr/bin/lua5.2

local tArgs={...};
if (#tArgs<2) then
	error("Not enough arguments\nUsage: chargen <number of chars> <starting seed> [output file]",0);
end

local nChars=tonumber(tArgs[1]);	-- Number of characters to generate.
local sSeedSt=tostring(tArgs[2]);	-- Seed to start with.
local sFinished="";			-- String to put the characters in.

-- Convert the seed starter into a seed
local tSeedStN={string.byte(sSeedSt)};
local nSeedF=0;
math.randomseed(os.time()+83.0485950);
for i,nChar in ipairs(tSeedStN) do
	local nCharF=(os.time()*math.random())/(nChar*1.064);
	nSeedF=nSeedF+nCharF;
end
nSeedF=math.floor(nSeedF/(math.random()+1));

-- Generate the string
math.randomseed(nSeedF);
for i=1,nChars,1 do
	local nRandCurrent=math.random(32,126);
	local sRandChar=string.char(nRandCurrent);
	sFinished=sFinished..sRandChar;
end

-- Print it to standard out
io.write(sFinished);

-- If user specified a path for a file, write the file
if (#tArgs>=3) then
	local sOutpath=tArgs[3];
	local tOutfile=io.open(sOutpath,"w+");
	tOutfile:write(sFinished);
	tOutfile:close();
end
