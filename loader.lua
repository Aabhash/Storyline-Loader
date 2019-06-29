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

predefined = {{"Bandersnatch", 400, 400, 400}}

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
	
    keep_checking = true

	sleep_duration = 1
	mstos = 1000000
    ChoiceATime = 4
    ChoiceBTime = 2
    TimeCheck = 14

	function activate()
	start_checker()
    end
    
    function show_dialog()
    vlc.playlist.pause()
    d = vlc.dialog("Choice Storyline Loader")
    d:show()
    d:add_label( "Choice Making Time", 1, 1, 1, 1 )
    CheckTimeOption = d:add_text_input( TimeCheck, 2, 1, 1, 1 )
    d:add_label( "Time for Choice A", 1, 2, 1, 1 )
	TimeToMoveToOptionOne = d:add_text_input( ChoiceATime, 2, 2, 1, 1 )
    d:add_label( "Time for Choice B", 1, 3, 1, 1 )
    TimeToMoveToOptionTwo = d:add_text_input( ChoiceBTime, 2, 3, 1, 1 )
    d:add_button("Choose A", click_Choice_A,3,2,1,1)
    d:add_button("Choose B", click_Choice_B,3,3,1,1)
    end
    
    function click_Choice_A()
    vlc.msg.info("Enabling choice loader, you have chosen storyline A.")
    TimeToMoveToA = tonumber(TimeToMoveToOptionOne:get_text())
    vlc.var.set(vlc.object.input(), "time", TimeToMoveToA * mstos)
    vlc.video.fullscreen()
    d:hide()
    end

    function click_Choice_B()
    vlc.msg.info("Enabling choice loader, you have chosen storyline B.")
    TimeToMoveToB = tonumber(TimeToMoveToOptionTwo:get_text())
    vlc.var.set(vlc.object.input(), "time", TimeToMoveToB * mstos)
    vlc.video.fullscreen()
    d:hide() 
    end
	
	function start_checker()
	keep_checking = true
	recheck_choice_time()
	end

	function sleep(s)
	  if keep_checking == true then
	  vlc.msg.info("Sleeping")
	  local ntime = get_time() + s
	  repeat until get_time() > ntime  
	  vlc.msg.info("Waking Up")
	  end
	end
	
	function recheck_choice_time()
	if keep_checking then
		vlc.msg.info("Rechecking if Choice Time")
		sleep(sleep_duration)
		check_current_time()
	end
	end
	
	function check_current_time()
	if get_time() >= TimeCheck * mstos then
		vlc.msg.info("Loading Choice Dialog")
        show_dialog()
		else 
		vlc.msg.info("Not yet at check time")
		recheck_choice_time()
		end
	end
	
	-- Get current time
	function get_time()
	return vlc.var.get(vlc.object.input(), "time") 	
	end
	
	function meta_changed()
	end