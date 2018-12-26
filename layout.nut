//
// Attract-Mode Front-End - Retrorama Layout based on EmulationStation layout


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

local systemDir = fe.script_dir + fe.game_info(Info.System) + "/";


local overwiewBg = fs.add_image("game-overview-bg.png", 0, 0, 1280*xs, 1024*ys);

local overviewText =fs.add_text("[Overview]", 680*xs, 800*ys, 558*xs, 700*ys)
overviewText.charsize = 12;
overviewText.set_rgb( 0, 0, 0 );
overviewText.align = Align.TopLeft;
overviewText.word_wrap = true;


local bk = fs.add_image( "[System]/system-bg.png", 0, 0, 1280*xs, 1024*ys);

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


function trimmed_name( index_offset ) {
    local s = split( fe.game_info( Info.Title, index_offset ), "(" );
    if ( s.len() > 0 )
        return s[0];

    return "";
}

local systemSpecsFileLines = [];
local systemSpecsText = "";
local systemSpecsFile = ReadTextFile(systemDir, "system-specs.txt");
while( !systemSpecsFile.eos() ){
	systemSpecsFileLines.push(systemSpecsFile.read_line());
	systemSpecsText = systemSpecsText + systemSpecsFileLines[systemSpecsFileLines.len()-1] + "\n";
}

local systemSpecs = fs.add_text(systemSpecsText, 287*xs, 187*ys, 317*xs, 175*ys );
systemSpecs.set_rgb( 0, 0, 0 );
systemSpecs.charsize = 16*ys;
systemSpecs.align = Align.TopRight;
systemSpecs.word_wrap = true;



class ShuffleList extends Shuffle {
	function select(slot) {
		slot.set_rgb(255,51,51);
	}
	function deselect(slot) {
		slot.set_rgb(255,255,255);
	}
}


local gameListSize = 20;
local gameList = ShuffleList(gameListSize, "text", "[!trimmed_name]", true, fs);
for (local i=0; i<gameListSize; i++) {
	gameList.slots[i].set_pos(25*xs, 390*ys+(i*23), 580, 23);
	gameList.slots[i].align = Align.Right;
	gameList.slots[i].charsize = 17*ys;
}

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
local snap = fs.add_artwork("snap", 680*xs,38*ys,565*xs,423*ys);
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


local modalOverlay = fs.add_image("modal-overlay.png", 0, 0, surfaceWidth, surfaceHeight);
modalOverlay.alpha=220;

local systemArt = fe.add_image("[System]/system.jpg", 0,0,900*xs,506*ys);
systemArt.x = (surfaceWidth/2)-(systemArt.width/2);
systemArt.y = (surfaceHeight/2)-(systemArt.height/2);

local modalOverlayFadeOut = {
   property = "alpha",
   start = modalOverlay.alpha,
   end = 0,
   time = 250,
   tween = Tween.Linear,
   delay = 2000,
   loop = false
}

local systemArtFadeOut = {
   when = Transition.StartLayout,
   property = "alpha",
   start = 255,
   end = 0,
   time = 250,
   tween = Tween.Linear,
   delay = 2000,
   loop = false,
   onStart = function( anim ) {
   		animation.add( PropertyAnimation ( modalOverlay, modalOverlayFadeOut ) );   		
   }
}

animation.add( PropertyAnimation ( systemArt, systemArtFadeOut ) );

