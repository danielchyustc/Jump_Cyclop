M = {}
M.width = display.contentWidth
M.height = display.contentHeight
M.centerX = display.contentWidth*0.5
M.centerY = display.contentHeight*0.5
M.plankWidth  = display.contentWidth*0.2
M.plankHeight = display.contentHeight*0.03
M.plankCornerRadius = display.contentWidth*0.01
M.gravity = display.contentHeight*0.1
M.basicPlankForce = -display.contentHeight*0.75
M.playerSize = display.contentWidth*0.08
M.holeRadius = display.contentWidth*0.12
M.savePointRadius = display.contentWidth*0.12
M.spikeWidth = display.contentWidth*0.05
M.spikeHeight = display.contentWidth*0.05
M.playerWidth=display.contentWidth*0.08

M.PLAY = {"PLAY","开始"}
M.SETTINGS = {"SETTINGS","设置"}
M.backgroundMusicOn = {"background music: on","背景音乐：开"}
M.backgroundMusicOff = {"background music: off","背景音乐：关"}
M.jumpsoundOn = {"jump sound: on","弹跳音效：开"}
M.jumpsoundOff = {"jump sound: off","弹跳音效：关"}
M.version = {"version: ","版本："}
M.level = {"level","关卡"}
M.MENU = {"MENU","菜单"}
M.RESUME = {"RESUME","继续"}
M.RESTART = {"RESTART","重玩"}
M.FAILED = {"FAILED","过关失败"}
M.SUCCEEDED = {"SUCCEEDED","过关成功"}
M.NEXT = {"NEXT","下一关"}
M.BACK = {"BACK","返回"}
M.EASY = {"EASY","简单"}
M.HARD = {"HARD","困难"}
return M