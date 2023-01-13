package base {
	
	//native
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import gfx.InterF;
		
		//http://www.pixeljam.com/dinorunhiscores/index.html?nam=sda&id=PL&score=1009830
		//http://www.pixeljam.com/dinorunhiscores/GetTop500ScoresForMode.php?mode=05&type=today&version=10
		public class Leaderboard extends Sprite{
			
			var sourceNam:String;
			var sourceScore:int;
			var X:URLLoader;
			var ID:String="";
			var scores:Object;
			var scoreClips:Object;
			var cMax:int=50;
			var myIndx:int=-1;
			var IDs:Array=["PL","C1","C2","C3","C4","P1","P2","P3","P4","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
			//var IDs:Array=["PX","C5","C6","C7","C8","P5","P6","P7","P8","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74"]
			var IDNAMES:Array=["Overall Players","Easy Challenge","Medium Challenge","Hard Challenge","Insane Challenge","Easy Planet D","Medium Planet D","Hard Planet D","Insane Planet D","Out To Pasture","Salty Flats","Rainin' Lizards",
				"The Valley","Dino Mountain","Stego Stampede","Up And Down","Ptero Storm","Meteor Meltdown",
				"Bombs Away","Death Crater","Dactyl Dodge","High Rollin'","Twin Peaks","MineFields","Dino Derby","NightFall","Planet D",
				"Circus Tryouts","The Hitchhiker","Rampage","Eggs oF DOOM","SurFing SaFari","Nobody Likes You"]
			var today:Boolean=true;
			var version:String="&version=12";
			
			private var hs:MovieClip;
			private var interF:InterF;
			
			private var xo:int;
			private var yo:int;
			
			public function Leaderboard (paramObj:Object, interF:InterF) {
				
				this.interF = interF
				hs = (Config.WEB ? new HS() : new HSAPP());
				addChild (hs);
				
				xo = Config.WEB ? 0 : 50;
				yo = Config.WEB ? 0 : 50;
				
				//get source
				ID=(paramObj["id"]==undefined)?"PL":String(paramObj["id"])
				sourceNam=(paramObj["nam"]==undefined)?"":String(paramObj["nam"])
				sourceScore=(paramObj["score"]==undefined)?0:Number(paramObj["score"])
				
				//init scores
				scores={};
				scoreClips={}
				for each (var id in IDs) { scores["c"+id]=[] }
				
				//get XML
				X = new URLLoader();
				X.addEventListener(Event.COMPLETE, XMLLoaded);
				
				//init buttons
				hs.bt_prev.addEventListener (MouseEvent.CLICK, prev50);
				hs.bt_next.addEventListener (MouseEvent.CLICK, next50);
				hs.bt_Today.addEventListener (MouseEvent.CLICK, showTodayScore);
				hs.bt_Today.addEventListener (MouseEvent.ROLL_OVER, todayOver);
				hs.bt_Today.addEventListener (MouseEvent.ROLL_OUT, todayOut);
				hs.bt_AllTime.addEventListener (MouseEvent.CLICK, showAllTimeScore);
				hs.bt_AllTime.addEventListener (MouseEvent.ROLL_OVER, allOver);
				hs.bt_AllTime.addEventListener (MouseEvent.ROLL_OUT, allOut);
				hs.bt_back.addEventListener (MouseEvent.CLICK, back);
				
				//populate categories
				for (var i:int=0; i<IDs.length; i++) {
					
					var cat:String=IDs[i];
					var clip:MovieClip=new catClip ();
					clip.namClip.catName.text=IDNAMES[IDs.indexOf(cat)];
					clip.ID=cat;
					clip.bt.addEventListener (MouseEvent.ROLL_OVER, catOver);
					clip.bt.addEventListener (MouseEvent.ROLL_OUT, catOut);
					clip.bt.addEventListener (MouseEvent.CLICK, catClick);
					clip.x=32+(i>16?125:0)+xo;
					clip.y=73+((i>16?i-17:i)*17)+yo;
					hs.addChild (clip);
					
				}
				
				//start it up
				showTodayScore(0)
				//bt_V11.visible=false;
				//V11BT.gotoAndStop ("act");
				
			}
			
			private function back (e:Event):void
			{
				interF.hideLB();
			}
			
			function goHome (ev) {
				
				navigateToURL ( new URLRequest ("http://www.pixeljam.com"),"_self");
				
			}
			
			function goMulti (ev) {
				
				navigateToURL ( new URLRequest ("http://www.xgenstudios.com/play/dinorun"),"_self");
				
			}
			
			function showTodayScore (ev) {
				
				today=true;
				hs.bt_Today.enabled=false;
				hs.bt_Today.visible=false;
				hs.bt_AllTime.enabled=true;
				hs.bt_AllTime.visible=true;
				hs.todayBT.gotoAndStop ("act");
				hs.allTimeBT.gotoAndStop ("out");
				switchCat();
				
			}
			
			function showAllTimeScore (ev) {
				
				today=false;
				hs.bt_Today.enabled=true;
				hs.bt_Today.visible=true;
				hs.bt_AllTime.enabled=false;
				hs.bt_AllTime.visible=false;
				hs.todayBT.gotoAndStop ("out");
				hs.allTimeBT.gotoAndStop ("act");
				switchCat();
				
			}
			
			function todayOver (ev) { hs.todayBT.gotoAndStop ("over") }
			function todayOut (ev) { if (hs.bt_Today.enabled) { hs.todayBT.gotoAndStop ("out") } }
			function allOver (ev) { hs.allTimeBT.gotoAndStop ("over") }
			function allOut (ev) { if (hs.bt_AllTime.enabled) { hs.allTimeBT.gotoAndStop ("out") } }
			
			
			function catOver (ev) { (ev.target.parent as MovieClip).gotoAndStop ("over") }
			function catOut (ev) { (ev.target.parent as MovieClip).gotoAndStop ("out") }
			function catClick (ev) { myIndx=-1; ID=(ev.target.parent as MovieClip).ID; switchCat() }
			
			function prev50 (ev) {
				
				myIndx=-1;
				cMax-=50; 
				updateHS();
				
			}
			
			function next50 (ev) {
				
				myIndx=-1;
				cMax+=50;
				if (cMax>500) { cMax=500 }
				updateHS();
				
			}
			
			function XMLLoaded(event:Event):void {
				
				var xml:XML = new XML(X.data);
				trace (xml)
				
				//parse
				var scoresX:XMLList=xml.children();
				
				for each (var sc in scoresX) { 
					
					var nam:String=sc.children()[0].toString();
					var score:int=Number(sc.children()[1]);
					scores["c"+ID].push(nam,score) 
					
				}
				
				//find my score?
				if (sourceScore!=0) {
					
					var ts:Array=scores["c"+ID];
					for (var i:int=0; i<ts.length; i+=2) {
						trace (ts[i],ts[i+1]);
						if (sourceNam==ts[i]&&sourceScore==ts[i+1]) {
							
							myIndx=i/2;
							cMax=(Math.ceil((myIndx+1)/50))*50;
							trace (myIndx,cMax);
							break;
							
						}
						
					}
					
				}
				
				//show list
				updateHS();
				
			}
			
			function switchCat () {
				
				myIndx=-1;
				scores["c"+ID]=[];
				cMax=50;
				hs.title1.text=(today?"Today's":"All Time")+" Top Dinos - "+IDNAMES[IDs.indexOf(ID)];
				hs.title2.text=(today?"Today's":"All Time")+" Top Dinos - "+IDNAMES[IDs.indexOf(ID)];
				
				//HS GET
				trace ("http://www.pixeljam.com/dinorunhiscores/HvGetTop500ScoresForMode.php?mode="+ID+"DX"+(today?"&type=today":"")+version)
				X.load(new URLRequest("http://www.pixeljam.com/dinorunhiscores/HvGetTop500ScoresForMode.php?mode="+ID+"DX"+(today?"&type=today":"")+version));
				
			}
			
			function updateHS() {
				
				//remove existing
				for (var cl in scoreClips) { hs.removeChild(scoreClips[cl]); delete(scoreClips[cl]) }				
				
				//show new
				var cList:Array=scores["c"+ID].slice();
				var l:int=cList.length/2;
				var tMax:int=(l<cMax)?l:cMax;
				var pi:int=0;
				for (var i:int=cMax-50; i<tMax; i++) {
					
					scoreClips["s"+i]=new scoreClip ();
					scoreClips["s"+i].rank.text=i+1;
					scoreClips["s"+i].nam.text=filter(cList[i*2]);
					scoreClips["s"+i].score.text=cList[(i*2)+1];
					scoreClips["s"+i].x=311+(pi>24?230:0)+xo;
					scoreClips["s"+i].y=72+((pi>24?pi-25:pi)*14)+yo;
					var a:Number=(i==0)?.5:.3-(i*.025);
					if (i==myIndx) { scoreClips["s"+i].bg.gotoAndPlay (5) } else {
						
						if (a<0) {a=0}
						scoreClips["s"+i].bg.alpha=a;
						
					}
					hs.addChild(scoreClips["s"+i]);
					pi++;
					
				}
				
				//adjust buttons
				hs.bt_prev.visible=false;
				hs.bt_next.visible=false;
				if (l>tMax&&cMax!=500) { hs.bt_next.visible=true }
				if (cMax-50>0) { hs.bt_prev.visible=true }
				
			}
			
			// give a rounded random number
			public function rand(min:int, max:int):int {
				return (Math.round(Math.random()*(max-min))+min);
			}
			
			function filter(arg1) {
				
				var pattern:RegExp =/[^a-z0-9.,!\$\*\(\)\_\=\- ]/ig;
				if (pattern.test(arg1)) { trace ("INVALID!!!!!!!!!!"); return "" }
				
				var i:String = "[i;|]";
				var c:String = "[c\[\{\(]";
				var o:String = "[o0]";
				
				arg1 = arg1.replace(new RegExp("&#", "gi"), "");
				arg1 = arg1.replace(new RegExp("\<", "gi"), "");
				arg1 = arg1.replace(new RegExp("assh"+o+"le", "gi"), ["jurrasichole", "pooper"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("fag", "gi"), ["frog", "frag"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("twat", "gi"), ["twig", "twonk"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("g"+o+"ddamn", "gi"), ["flimflam"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("g"+o+"d damn", "gi"), ["flim flam"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("g"+o+"ddamm"+i+"t", "gi"), ["flimflammit"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("g"+o+"ddamn"+i+"t", "gi"), ["flimflammit"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("m"+o+"therfu"+c+"ker", "gi"), ["mothersaurus", "macrophalangia"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("fu"+c+"knuts", "gi"), ["rockstick", "eggnoodle"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("fu"+c+"ker", "gi"), ["flower", "bonky"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("fu"+c+"k"+i+"ng", "gi"), ["flapping", "flooping"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("fu"+c+"k you", "gi"), ["i love you", "lets cuddle"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("f"+i+"stfu"+c+"k", "gi"), ["foliage", "finger fun"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("buttfu"+c+"k", "gi"), ["bronto abuse", "backflip"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("fu"+c+"k", "gi"), ["fossil", "bonk"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("c"+o+c+"k", "gi"), ["rock", "bone"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("b"+i+"t"+c+"h", "gi"), ["ditch", "skronk"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("b:t"+c+"h", "gi"), ["ditch", "skronk"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("b1t"+c+"h", "gi"), ["ditch", "skronk"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("blt"+c+"h", "gi"), ["ditch", "skronk"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("b!t"+c+"h", "gi"), ["ditch", "skronk"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(c+"um ", "gi"), ["oil ", "DNA "][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(c+"uum ", "gi"), ["oiil ", "DNNA "][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(" ass ", "gi"), [" tail ", " scale ", " anklyo "][rand(0, 2)]);
				arg1 = arg1.replace(new RegExp("t"+i+"t ", "gi"), ["mound ", "pebble "][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(" t"+i+"ts", "gi"), [" mounds", " pebbles"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("t1t ", "gi"), ["mound ", "pebble "][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(" t1ts", "gi"), [" mounds", " pebbles"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("t:t ", "gi"), ["mound ", "pebble "][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(" t:ts", "gi"), [" mounds", " pebbles"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("t"+i+"tt"+i+"es", "gi"), ["titanos", "mounds"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("sh"+i+"t", "gi"), ["dung", "dirt"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("sh1t", "gi"), ["dung", "dirt"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("sh!t", "gi"), ["dung", "dirt"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("src", "gi"), ["srb", "sra"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("pussy", "gi"), ["eggnest", "nest"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("di"+c+"k", "gi"), ["diplo", "dactyl"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("d!"+c+"k", "gi"), ["diplo", "dactyl"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("d:"+c+"k", "gi"), ["diplo", "dactyl"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("d1"+c+"k", "gi"), ["diplo", "dactyl"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(""+c+"unt", "gi"), ["hole", "kronk"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(c+"amel t"+o+"e", "gi"), ["camelotia hoof", "raptor hoof"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(c+"amelt"+o+"e", "gi"), ["camelotia hoof", "raptor hoof"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("eja"+c+"ulate", "gi"), ["erupt", "squirt"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("eja"+c+"ulati"+o+"n", "gi"), ["eruption"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("bl"+o+"w j"+o+"b", "gi"), ["oil change"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("bl"+o+"wj"+o+"b", "gi"), ["oil change"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("wh"+o+"re", "gi"), ["hadrosaurus", "hoop"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(" "+c+"l"+i+"t", "gi"), [" claw", " clump"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(c+"l"+i+"t ", "gi"), ["claw ", "clump "][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(" "+c+"l:t", "gi"), [" claw", " clump"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(c+"l:t ", "gi"), ["claw ", "clump "][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(" "+c+"l1t", "gi"), [" claw", " clump"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(c+"l1t ", "gi"), ["claw ", "clump "][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("gl"+o+"ry h"+o+"le", "gi"), ["tar pit", "stonehenge"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("jerk "+o+"ff", "gi"), ["jurassic"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("jerk"+o+"ff", "gi"), ["jurassic"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("jerk-"+o+"ff", "gi"), ["jur-assic"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("c"+i+"r"+c+"le jerk", "gi"), ["stone throw", "fun toss"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("d"+o+"nkey pun"+c+"h", "gi"), ["dino punch"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("d"+i+"rty san"+c+"hez", "gi"), ["dirty saurolophus"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("p"+i+"ss", "gi"), ["pee", "oil"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("p!ss", "gi"), ["pee", "oil"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("p1ss", "gi"), ["pee", "oil"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("p:ss", "gi"), ["pee", "oil"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp(c+"umswap", "gi"), ["eggswap"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("bastard", "gi"), ["bactasaurus", "basket"][rand(0, 1)]);
				arg1 = arg1.replace(new RegExp("n"+i+"gger", "gi"), ["nanosaur"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("n:gger", "gi"), ["nanosaur"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("n1gger", "gi"), ["nanosaur"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("n!gger", "gi"), ["nanosaur"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("don8tosaur", "gi"), ["dino"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("d o n 8 t o s a u r", "gi"), ["dino"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("don8to saur", "gi"), ["dino"][rand(0, 0)]);
				arg1 = arg1.replace(new RegExp("d.o.n.8.t.o.s.a.u.r", "gi"), ["dino"][rand(0, 0)]);
				
				return arg1;
				
			}
			
		}
		
}