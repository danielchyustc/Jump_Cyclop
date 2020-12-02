local M = {}
M.sounds = {
	--backgroundMusic = audio.loadStream("music/backgroundMusic.mp3"),
	
	-- jumpSound = audio.loadStream("music/jump.m4a")
	jumpSound = audio.loadStream("music/phaseJump3.mp3")
	
}

    M.sounds[1] = audio.loadStream("music/music01.mp3")
	M.sounds[2] = audio.loadStream("music/music02.mp3")
	M.sounds[3] = audio.loadStream("music/music03.mp3")
	M.sounds[4] = audio.loadStream("music/music04.mp3")
	M.sounds[5] = audio.loadStream("music/music05.mp3")
	M.sounds[6] = audio.loadStream("music/music06.mp3")
	M.sounds[7] = audio.loadStream("music/music07.mp3")
	M.sounds[8] = audio.loadStream("music/music08.mp3")
	M.sounds[9] = audio.loadStream("music/music09.mp3")
	M.sounds[10] = audio.loadStream("music/music10.mp3")
	M.sounds[11] = audio.loadStream("music/music11.mp3")

function M.playBGMusic(x)
	M.backgroundMusic = audio.play(M.sounds[x],{ channel = 10, loops = -1, fadein = 0 } )
end

function M.stopBGMusic(  )
	audio.stop(M.backgroundMusic)
end

function M.jump(  )
	audio.play(M.sounds.jumpSound )
	print("A")
end

return M