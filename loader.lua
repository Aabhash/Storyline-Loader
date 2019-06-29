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

predefined = {{"Bandersnatch", 20, 15, 15, 23}}

function descriptor()
    return {
        title = "Choice Storyline Loader",
        version = 0.2,
        author = "Aabhash Dhakal <aabhashd@gmail.com>",
        url = 'https://github.com/aabhash',
        description = "Play Multiple Choice storylines by enabling this extension at the particular time when choice is to be made.",
        capabilities = {"input-listener"}
    }
end

sleep_duration = 1
mstos = 1000000
ChoiceATime = 0
ChoiceBTime = 0
TimeCheckMin = 0
TimeCheckSec = 0

function activate()
    show_dialog()
end

function show_dialog()
    vlc.playlist.pause()
    d = vlc.dialog("Choice Storyline Loader")
    d:show()

    -- First Row
    d:add_label("Predefined Shows", 1, 1, 1, 1)
    dDropdown = d:add_dropdown(2, 1, 2, 1)
    for i, predefined in pairs(predefined) do
        dDropdown:add_value(predefined[1], i)
    end
    d:add_button("Apply", click_confirm, 4, 1, 2, 1)

    -- Second Row
    d:add_label( "Time Marker currently should be at", 1, 2, 1, 1 )
    CheckMin = d:add_text_input( TimeCheckMin, 2, 2, 1, 1 )
    d:add_label( "Minutes and", 3, 2, 1, 1 )
    CheckSec = d:add_text_input( TimeCheckSec, 4, 2, 1, 1 )
    d:add_label( "Seconds", 5, 2, 1, 1 )

    -- Third Row
    d:add_label( "Time for Choice A", 1, 3, 1, 1 )
    TimeToMoveToOptionOne = d:add_text_input( ChoiceATime, 2, 3, 1, 1 )
    d:add_label( "Seconds", 3, 3, 1, 1 )

    -- Fourth Row
    d:add_label( "Time for Choice B", 1, 4, 2, 1 )
    TimeToMoveToOptionTwo = d:add_text_input( ChoiceBTime, 2, 4, 1, 1 )
    d:add_label( "Seconds", 3, 4, 1, 1 )

    d:add_button("Choose A", click_Choice_A, 1, 5, 1, 1)
    d:add_button("Choose B", click_Choice_B, 1, 6, 1, 1)
end

-- Choose Story Option A
function click_Choice_A()
    vlc.msg.info("Enabling choice loader, you have chosen storyline A.")
    TimeToMoveToA = tonumber(TimeToMoveToOptionOne:get_text())
    vlc.var.set(vlc.object.input(), "time", TimeToMoveToA * mstos)
    vlc.video.fullscreen()
    d:hide()
    vlc.playlist.play()
end

-- Choose Story Option B
function click_Choice_B()
    vlc.msg.info("Enabling choice loader, you have chosen storyline B.")
    TimeToMoveToB = tonumber(TimeToMoveToOptionTwo:get_text())
    vlc.var.set(vlc.object.input(), "time", TimeToMoveToB * mstos)
    vlc.video.fullscreen()
    d:hide()
    vlc.playlist.play()
end

-- Confirm Show Selection
function click_confirm()
    local predefined = predefined[dDropdown:get_value()]
    CheckMin:set_text(predefined[2])
    CheckSec:set_text(predefined[3])
    TimeToMoveToOptionOne:set_text(predefined[4])
    TimeToMoveToOptionTwo:set_text(predefined[5])
    d:update()
end
