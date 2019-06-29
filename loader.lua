--[[
INSTALLATION:
Put the .lua file in the VLC subdir /lua/extensions, by default:
* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\extensions\
* Windows (current user): %APPDATA%\VLC\lua\extensions\
* Linux (all users): /usr/share/vlc/lua/extensions/
* Linux (current user): ~/.local/share/vlc/lua/extensions/
Restart VLC,

USAGE:
Go to the "View" menu and select "Choice Loader".
--]]

predefined = {{"Bandersnatch", 200, 15, 23}}

function descriptor()
  return {
    title = "Choice Storyline Loader",
    version = 0.1,
    author = "Aabhash Dhakal <aabhashd@gmail.com>",
    url = 'https://github.com/aabhash',
    description = "This extension is able to play Multiple Choice storylines when video reaches the particular time when choice is to be made",
    capabilities = {"input-listener"}
  }
end

sleep_duration = 1
mstos = 1000000
ChoiceATime = 0
ChoiceBTime = 0
TimeCheck = 0

function activate()
  show_dialog()
end

function show_dialog()
  vlc.playlist.pause()
  d = vlc.dialog("Choice Storyline Loader")
  d:show()
  d:add_label("Predefined Shows",1,1,2,1)
  dDropdown = d:add_dropdown(2,1,1,1)
  for i, predefined in pairs(predefined) do
    dDropdown:add_value(predefined[1], i)
  end
  d:add_button("Apply", click_confirm, 3, 1, 1, 1)
  d:add_label( "Time Marker currently should be at", 1, 2, 1, 1 )
  CheckTimeOption = d:add_text_input( TimeCheck, 2, 2, 1, 1 )
  d:add_label( "Time for Choice A", 1, 3, 1, 1 )
  TimeToMoveToOptionOne = d:add_text_input( ChoiceATime, 2, 3, 1, 1 )
  d:add_label( "Time for Choice B", 1, 4, 1, 1 )
  TimeToMoveToOptionTwo = d:add_text_input( ChoiceBTime, 2, 4, 1, 1 )
  d:add_button("Choose A", click_Choice_A,3,3,2,1)
  d:add_button("Choose B", click_Choice_B,3,4,2,1)
end

function click_Choice_A()
  vlc.msg.info("Enabling choice loader, you have chosen storyline A.")
  TimeToMoveToA = tonumber(TimeToMoveToOptionOne:get_text())
  vlc.var.set(vlc.object.input(), "time", TimeToMoveToA * mstos)
  vlc.video.fullscreen()
  d:hide()
  vlc.playlist.play()
end

function click_Choice_B()
  vlc.msg.info("Enabling choice loader, you have chosen storyline B.")
  TimeToMoveToB = tonumber(TimeToMoveToOptionTwo:get_text())
  vlc.var.set(vlc.object.input(), "time", TimeToMoveToB * mstos)
  vlc.video.fullscreen()
  d:hide()
  vlc.playlist.play()
end

function click_confirm()
  local predefined = predefined[dDropdown:get_value()]
  CheckTimeOption:set_text(predefined[2])
  TimeToMoveToOptionOne:set_text(predefined[3])
  TimeToMoveToOptionTwo:set_text(predefined[4])
  d:update()
end