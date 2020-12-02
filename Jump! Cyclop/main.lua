local composer=require("composer")
local perspective=require "perspective"

local loadsave=require("loadsave")
local path1=system.pathForFile("levels.json",system.DocumentsDirectory)
local path2=system.pathForFile("k.json",system.DocumentsDirectory)
local path3=system.pathForFile("levelDif.json",system.DocumentsDirectory)
local fhd1=io.open(path1)
local fhd2=io.open(path2)
local fhd3=io.open(path3)
local levels,levelDif,k
if fhd1 then
	print("Files exists levels.json"..path1)
	fhd1:close()
	levels=loadsave.loadTable("levels.json",system.DocumentsDirectory)
else
	print("File does not exist!")
	levels={true,true,true,true,true,true,true,true,true,true}
	loadsave.saveTable(levels,"levels.json",system.DocumentsDirectory)
	levels=loadsave.loadTable("levels.json",system.DocumentsDirectory)
end
if fhd2 then
	print("Files exists k.json"..path2)
	fhd2:close()
	k=loadsave.loadTable("k.json",system.DocumentsDirectory)
else
	print("File does not exist!")
	k={true,true,2}
	loadsave.saveTable(k,"k.json",system.DocumentsDirectory)
	k=loadsave.loadTable("k.json",system.DocumentsDirectory)
end
if fhd3 then
	print("Files exists levelDif.json"..path3)
	fhd3:close()
	levelDif=loadsave.loadTable("levelDif.json",system.DocumentsDirectory)
else
	print("File does not exist!")
	levelDif={1,1,1,1,1,1,1,1,1,1}
	loadsave.saveTable(levelDif,"levelDif.json",system.DocumentsDirectory)
	levelDif=loadsave.loadTable("levelDif.json",system.DocumentsDirectory)
end



composer.gotoScene("enter")