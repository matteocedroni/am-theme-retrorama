//
// Attract-Mode Front-End - Retrorama Layout based on EmulationStation layout


class UserConfig
{
    </  label     = "System",
    help      = "Current system. Auto for match mode by system identifier",
    options     = "auto,Arcade,Nintendo 64,Nintendo Entertainment System,Nintendo GameCube,Sega 32X,Sega Genesis,Sega Master System,Sega Saturn,Sony PlayStation,Super Nintendo Entertainment System,NEC TurboGrafx-16",
    order     = 1,
    per_display   = "yes"
  />  system = "auto";

    </ 	label			= "System Art Mode",
		help			= "Video or static image for current system art",
		options			= "video,image",
		order			= 1,
		per_display		= "no"
	/>	systemArtMode	= "image";

	</ 	label			= "Splash screen delay",
		help			= "Splash screen delay time in millis",
		options			= "1000,1500,2000,2500,3000",
		order			= 2,
		per_display		= "no"
	/>	splashScreenDelay	= "3000";

  </  label     = "Game list elements",
    help      = "Game list elements visible on screen",
    order     = 3,
    per_display   = "no"
  />  gameListElements = "20";
}



//fe.load_module("objects/scrollingtext");
//fe.load_module("fade");
fe.load_module("animate");
fe.load_module("shuffle");
fe.load_module("file");

fe.layout.width=ScreenWidth;
fe.layout.height=ScreenHeight;

local surfaceWidth=fe.layout.width
local surfaceHeight=fe.layout.height;

local fs=fe.add_surface(surfaceWidth,surfaceHeight)
//x scale factor
local xs=surfaceWidth/1280.;
//y scale factor
local ys=surfaceHeight/1024.;

local layoutConfig = fe.get_config();

local currentGameList = fe.list.name;
local currentSystem;
if (layoutConfig.system=="auto"){
  currentSystem = fe.game_info(Info.System);
}
else{
  currentSystem = layoutConfig.system;
}

local systemPath = fe.script_dir + currentSystem + "/";


fe.layout.font = "VAGRounded-Bold";

ThemeResource <- {
    OverviewBackground = "game-overview-bg.png",
    SystemBackground = "system-bg",
    SystemSpecs = "system-specs.txt",
    SystemSplash = "system-splash.jpg",
    ModalOverlay = "modal-overlay.png"
    SnapShaderVert = "crt.vert",
    SnapShaderFrag = "crt.frag",
    SystemVideo = "system.mp4",
    SystemImage = "system.png"
}

SystemArtMode <-{
	Video = "video",
	Image = "image"
}


local overwiewBg = fs.add_image(ThemeResource.OverviewBackground, 0, 0, 1280*xs, 1024*ys);

local overviewText =fs.add_text("[Overview]", 680*xs, 800*ys, 558*xs, 700*ys)
overviewText.charsize = 14*ys;
overviewText.set_rgb( 0, 0, 0 );
overviewText.align = Align.TopLeft;
overviewText.word_wrap = true;
overviewText.font="Roboto-LightItalic";

local bk = null;
if (fe.path_test(systemPath+"/"+ThemeResource.SystemBackground+".png" , PathTest.IsFile)){
	bk = fs.add_image(systemPath+"/"+ThemeResource.SystemBackground+".png", 0, 0, 1280*xs, 1024*ys);
}
else{
	bk = fs.add_image(systemPath+"/"+ThemeResource.SystemBackground+".jpg", 0, 0, 1280*xs, 1024*ys);
}

/*
local overviewTextScroll = {
   when = Transition.EndNavigation,
   property = "y",
   start = overviewText.y
   end = (overviewText.y-overviewText.height+200)
   time = 30000,
   tween = Tween.Linear
   delay = 2000
   loop = true
 }
 */    
 
//animation.add( PropertyAnimation ( overviewText, overviewTextScroll ) );


function trimmedGameTitle( index_offset ) {
    local s = split( fe.game_info( Info.Title, index_offset ), "(" );
    if ( s.len() > 0 )
        return s[0];

    return "";
}

local systemSpecs = fs.add_text("", 287*xs, 187*ys, 317*xs, 175*ys );
systemSpecs.set_rgb( 0, 0, 0 );
systemSpecs.charsize = 16*ys;
systemSpecs.align = Align.TopRight;
systemSpecs.word_wrap = true;


local systemImage = fs.add_image(systemPath+"/"+ThemeResource.SystemImage, 21*xs,184*ys,242*xs,179*ys);
if (SystemArtMode.Video == layoutConfig.systemArtMode){
	systemImage.video_flags = Vid.NoAudio;
}
else{
	systemImage.video_flags = Vid.ImagesOnly;
}


class ShuffleList extends Shuffle {
	function select(slot) {
		slot.set_rgb(255,51,51);
	}
	function deselect(slot) {
		slot.set_rgb(255,255,255);
	}
}


local gameListSize = layoutConfig.gameListElements.tointeger();
if (fe.list.size < gameListSize){
  gameListSize = fe.list.size;
}

local gameList = [];
for (local i=0; i<gameListSize; i++) {
	gameList.push(fs.add_text("[!trimmedGameTitle]", 25*xs, 390*ys+(i*23), 580*xs, 23*ys));
	gameList[i].align = Align.Right;
	gameList[i].charsize = 17*ys;
	
}
local gameListShuffle = ShuffleList(gameList, "text");

//local gameList = ShuffleList(gameListSize, "text", "[!trimmedGameTitle]", true, fs);
//for (local i=0; i<gameListSize; i++) {
//	gameList.slots[i].set_pos(25*xs, 390*ys+(i*23), 580*xs, 23*ys);
//	gameList.slots[i].align = Align.Right;
//	gameList.slots[i].charsize = 17*ys;
//}

//Game gategory
local category = fs.add_text( "[Category]", 1020*xs, 490*ys, 217*xs, 45*ys );
category.set_rgb( 0, 0, 0 );
category.charsize = 16*ys;
category.align = Align.Centre;
category.word_wrap = true;

//Year
local year = fs.add_text( "[Year]", 792*xs, 635*ys, 195*xs, 25*ys );
year.set_rgb( 255, 255, 255 );
year.charsize = 16*ys;
year.align = Align.Right;

//Manufacturer
local manufacturer = fs.add_text( "[Manufacturer]", 792*xs, 670*ys, 195*xs, 45*ys );
manufacturer.set_rgb( 255, 255, 255 );
manufacturer.charsize = 16*ys;
manufacturer.align = Align.TopRight;
manufacturer.word_wrap = true;

//Max players
local numPlayers = fs.add_text( "[Players]P", 1094*xs, 546*ys, 86*xs, 23*ys );
numPlayers.set_rgb( 0, 0, 0 );
numPlayers.charsize = 16*ys;
numPlayers.align = Align.Centre;

//Snap
local snap = fs.add_artwork("snap", 680*xs,39*ys,564*xs,424*ys);
snap.trigger = Transition.EndNavigation;

//Snap shader
local shader = fe.add_shader( Shader.VertexAndFragment, "crt.vert", "crt.frag" );
shader.set_param( "rubyInputSize", 565*xs, 423*ys );
shader.set_param( "rubyOutputSize", 565*xs, 423*ys );
shader.set_param( "rubyTextureSize", 565*xs, 423*ys );
shader.set_texture_param( "rubyTexture" );
snap.shader = shader;

//Flyer
local flyer = fs.add_artwork("flyer", 26*xs,576*ys,290*xs,420*ys);
flyer.pinch_y=20;
flyer.alpha=70;
flyer.trigger = Transition.EndNavigation;


local modalOverlay = fs.add_image(ThemeResource.ModalOverlay, 0, 0, surfaceWidth, surfaceHeight);
modalOverlay.alpha=220;

local splashImage = fe.add_image(systemPath+"/" + ThemeResource.SystemSplash, 0,0,900*xs,506*ys);
splashImage.x = (surfaceWidth/2)-(splashImage.width/2);
splashImage.y = (surfaceHeight/2)-(splashImage.height/2);

local modalOverlayFadeOut = {
   when = When.StartLayout,
   when = Transition.ToNewList,
   property = "alpha",
   start = 220,
   end = 0,
   time = 250,
   tween = Tween.Linear,
   delay = layoutConfig.splashScreenDelay.tointeger(),
   onStart = function( anim ) {
   		modalOverlay.alpha=220;		
   }
}

local splashImageFadeOut = {
   when = When.StartLayout,
   when = Transition.ToNewList,
   property = "alpha",
   start = 255,
   end = 0,
   time = 250,
   tween = Tween.Linear,
   delay = layoutConfig.splashScreenDelay.tointeger(),
   onStart = function( anim ) {
   		splashImage.alpha=255;
   		//loadSystemSpec();
   }
}

animation.add( PropertyAnimation ( splashImage, splashImageFadeOut ) );
animation.add( PropertyAnimation ( modalOverlay, modalOverlayFadeOut ) );  		


function loadSystemSpec () {
  local systemSpecsFileLines = [];
	local systemSpecsText = "";
	local systemSpecsFile = ReadTextFile(systemPath, ThemeResource.SystemSpecs);
	while( !systemSpecsFile.eos() ){
		systemSpecsFileLines.push(systemSpecsFile.read_line());
		systemSpecsText = systemSpecsText + systemSpecsFileLines[systemSpecsFileLines.len()-1] + "\n";
	}

	systemSpecs.msg=systemSpecsText;
}

function onTransition( ttype, var, transition_time )
{
   local redraw_needed = false;

   if (ttype == Transition.ToNewList && currentGameList!=fe.list.name){
      fe.signal("reload"); 
   }   
   if (ttype == Transition.StartLayout){
   		loadSystemSpec();
   }

   if ( redraw_needed )
      return true;

   return false;
}


fe.add_transition_callback("onTransition");
