package gfx
{
	public class HatUI
	{
		public var dColors:Object={ a:{body:[255,242,0],dot:[],stripe:[],eye:[217,114,39],text:"body"}, //yellow
			b:{body:[180,255,40],dot:[],stripe:[],eye:[168,85,52],text:"body"}, //green
			c:{body:[249,209,255],dot:[],stripe:[],eye:[312,92,231],text:"body"}, //pink
			d:{body:[149,95,43],dot:[],stripe:[],eye:[255,255,255],text:"body"}, //brown
			e:{body:[255,106,22],dot:[],stripe:[],eye:[255,255,255],text:"body"}, //orange
			f:{body:[255,0,0],dot:[],stripe:[],eye:[255,255,255],text:"body"}, //red
			g:{body:[134,81,255],dot:[],stripe:[],eye:[255,255,255],text:"body"}, //purp
			h:{body:[0,176,255],dot:[],stripe:[],eye:[255,255,255],text:"body"}, //blue
			i:{body:[105,192,0],dot:[],stripe:[],eye:[0,0,0],text:"body"}, //green
			j:{body:[255,236,95],dot:[],stripe:[],eye:[0,176,	255],text:"body"}, //ly yellow
			
			k:{body:[255,255,255],dot:[],stripe:[],eye:[255,20,20],text:"body"}, //albino
			l:{body:[127,127,127],dot:[],stripe:[],eye:[255,255,255],text:"body"}, //grey
			m:{body:[0,0,0],dot:[],stripe:[],eye:[255,255,255],text:"body"}, //black
			n:{body:[255,242,0],dot:[255,205,0],stripe:[],eye:[217,114,39],text:"body"}, //yellow orange
			o:{body:[255,113,33],dot:[196,78,0],stripe:[],eye:[255,	244,	96],text:"dot"}, //orange dk orange
			p:{body:[180,255,40],dot:[130,220,10],stripe:[],eye:[168,	85,	52],text:"eye"}, //
			q:{body:[249,209,255],dot:[241,169,252],stripe:[],eye:[213,	92,	231],text:"eye"}, //
			r:{body:[51,186,255],dot:[35,115,255],stripe:[],eye:[255,255,255],text:"dot"}, //
			s:{body:[164,123,71],dot:[130,100,60],stripe:[],eye:[130,	100,	60],text:"dot"}, //
			t:{body:[255,227,161],dot:[255,190,130],stripe:[],eye:[148,	108,	39],text:"eye"}, //
			u:{body:[255,194,0],dot:[245,136,0],stripe:[],eye:[207,	95,	0],text:"dot"}, //
			v:{body:[183,183,183],dot:[143,141,126],stripe:[],eye:[255,255,255],text:"dot"}, //
			w:{body:[255,196,249],dot:[215,184,255],stripe:[],eye:[255,255,255],text:"eye"}, //
			x:{body:[255,242,0],dot:[219,207,5],stripe:[],eye:[217,	114,	39],text:"eye"}, //
			y:{body:[255,255,255],dot:[230,230,230],stripe:[],eye:[255,20,20],text:"dot"}, //
			z:{body:[65,65,65],dot:[0,0,0],stripe:[],eye:[255,	206,	20],text:"dot"}, //
			A:{body:[255,	242,	20],dot:[],stripe:[255,	200	,20],eye:[217,	114,	39],text:"body"}, //
			B:{body:[151,	156,	0],dot:[],stripe:[91,	124	,0],eye:[255,	244,	0],text:"stripe"}, //
			C:{body:[249,	209,	255],dot:[],stripe:[210,	146,	244],eye:[255,255,255],text:"eye"}, //
			D:{body:[236,	191,	13],dot:[],stripe:[225,	131,	61],eye:[255,	241	,172],text:"stripe"}, //
			E:{body:[104,	218,	111],dot:[],stripe:[40,	154,	180],eye:[255,255,255],text:"stripe"}, //
			F:{body:[255,	227,	161],dot:[],stripe:[255,	190,	130],eye:[148,	108,	39],text:"eye"}, //
			G:{body:[168,	94	,165],dot:[],stripe:[213,	127	,210],eye:[249,	183,	246],text:"stripe"}, //
			H:{body:[194,	182	,146],dot:[],stripe:[126,	113,	82],eye:[253,	247,	189],text:"stripe"}, //
			I:{body:[122,	219	,85],dot:[],stripe:[162	,158,	66],eye:[255,255,255],text:"stripe"}, //
			J:{body:[164,	123	,71],dot:[],stripe:[140	,100,	60],eye:[253	,247,	189],text:"stripe"}, //
			K:{body:[0,0,0],dot:[],stripe:[115	,72,	30],eye:[255,255,255],text:"stripe"}, //
			L:{body:[151,	124,	0],dot:[],stripe:[117	,83,	0],eye:[255,255,255],text:"stripe"}, //
			
			
			M:{body:[235,	235,	235],dot:[],stripe:[172,	172,	172],eye:[16,	17,	7],text:"body"}, //
			N:{body:[242,	101,	34],dot:[0,0,0],stripe:[],eye:[255,255,255],text:"body"}, //
			O:{body:[255,0,0],dot:[255,255,255],stripe:[],eye:[255,255,255],text:"body"}, //
			P:{body:[0,	212,	53],dot:[],stripe:[0,	194,	49],eye:[255,255,255],text:"stripe"}, //
			Q:{body:[242,	0,	0],dot:[],stripe:[202,	0,	0],eye:[0,0,0],text:"stripe"}, //
			R:{body:[58,	182,	0],dot:[],stripe:[41,	123,	2],eye:[255,255,255],text:"stripe"}, //
			S:{body:[0,	138,	255],dot:[240,	59,	48],stripe:[],eye:[255,255,255],text:"dot"}, //
			T:{body:[0,	138,	255],dot:[37,	215	,0],stripe:[],eye:[255,255,255],text:"dot"}, //
			U:{body:[242,	150,	175],dot:[],stripe:[244,	83,	148],eye:[255,255,255],text:"stripe"}, //
			V:{body:[255,	255,	255],dot:[],stripe:[255,	204,	153],eye:[217,	114,	39],text:"body"}, //
			W:{body:[255,	255,	255],dot:[],stripe:[51,	204,	51],eye:[16,	17,	7],text:"stripe"}, //
			X:{body:[255,	249,	46],dot:[],stripe:[213,	127	,210],eye:[0,0,0],text:"stripe"}, //
			Y:{body:[112,	199,	52],dot:[155,	96,	26],stripe:[],eye:[255,255,255],text:"dot"}, //
			Z:{body:[255,	200,	22],dot:[],stripe:[255,	96,	39],eye:[255,255,255],text:"stripe"}, //
			aa:{body:[51,	186,	255],dot:[],stripe:[34,	115,	245],eye:[255,255,255],text:"stripe"}, //
			bb:{body:[126,	144,	75],dot:[],stripe:[86,	107,	67],eye:[255,255,255],text:"stripe"}, //
			cc:{body:[251,	173,	83],dot:[],stripe:[75,	145,	255],eye:[255,255,255],text:"stripe"}, //
			dd:{body:[255,	210,	0],dot:[],stripe:[78,	193,	82],eye:[217,	52,	39],text:"stripe"}, //
			ee:{body:[30,	151,	236],dot:[],stripe:[30,	102,	216],eye:[255,255,255],text:"stripe"}, //
			ff:{body:[240,	59,	48],dot:[],stripe:[41,	92,	170],eye:[255,255,255],text:"stripe"}, //
			gg:{body:[166,	166,	166],dot:[],stripe:[42,	42,	42],eye:[255,255,255],text:"stripe"}, //
			hh:{body:[235,	235,	235],dot:[],stripe:[205,	23,	29],eye:[0,	120,	255],text:"stripe"}, //
			ii:{body:[149,	167,	163],dot:[],stripe:[97,	129,,18],eye:[0,	0,	0],text:"stripe"}, //
			jj:{body:[231,	234,	241],dot:[],stripe:[45,	135,	188],eye:[0,0,0],text:"stripe"}, //
			kk:{body:[64,	66,	68],dot:[],stripe:[0,0,0],eye:[240,	39	,0],text:"stripe"}, //
			ll:{body:[255,	255,	255],dot:[],stripe:[16,	17	,7],eye:[240,	39,	0],text:"stripe"}, //
			mm:{body:[214,	54,	44],dot:[],stripe:[30,	34	,37],eye:[255,255,255],text:"body"}, //
			nn:{body:[40,	40,	40],dot:[],stripe:[0,	0,	0],eye:[255,255,255],text:"body"}, //
			oo:{body:[194,	182,	146],dot:[],stripe:[126,	113,	82],eye:[255,255,255],text:"stripe"}, //
			pp:{body:[19,	23,	25],dot:[],stripe:[183,	202,	214],eye:[255,255,255],text:"body"}, //
			qq:{body:[240,	175,	51],dot:[],stripe:[186,	136,	40],eye:[255,255,255],text:"stripe"}, //
			rr:{body:[17,	175,	255],dot:[112,	255,	255],stripe:[],eye:[255,255,255],text:"stripe"}, //
			ss:{body:[255,	53,	0],dot:[255,	228,	0],stripe:[],eye:[255,255,255],text:"stripe"}, //
			tt:{body:[255,	255,	255],dot:[],stripe:[228	,228,	228],eye:[255,0,0],text:"body"}, //
			uu:{body:[124,	124,	124],dot:[],stripe:[188,	188,	188],eye:[255,255,255],text:"body"}, //
			
			
			
			vv:{body:[202,	0,	0],dot:[],stripe:[242,	0,	0],eye:[255,255,255],text:"stripe"}, //
			ww:{body:[255,	183,	9],dot:[],stripe:[179,	52,	1],eye:[255,255,255],text:"stripe"}, //
			xx:{body:[94,	104,	114],dot:[],stripe:[6,	22,	35],eye:[255,255,255],text:"stripe"}, //
			yy:{body:[111,	0,	220],dot:[],stripe:[159,	57,	255],eye:[255,255,255],text:"body"}, //
			zz:{body:[1,	82,	182],dot:[],stripe:[238,	0,	0],eye:[255,255,255],text:"stripe"}, //
			AA:{body:[0,	0,	0],dot:[],stripe:[89,	2,	159],eye:[255,255,255],text:"stripe"}, //
			BB:{body:[255,	229,	108],dot:[],stripe:[217,	32,	62],eye:[255,255,255],text:"stripe"}, //
			
			DD:{body:[255,	255,	255],dot:[],stripe:[232,	232,	232],eye:[255,0,0],text:"body"}, //
			EE:{body:[59,	246,	70],dot:[],stripe:[8,	203,	30],eye:[255,255,255],text:"stripe"}, //
			GG:{body:[18,	181,	245],dot:[255,242,0],stripe:[],eye:[255,255,255],text:"body"}, //
			LL:{body:[72,	100,	24],dot:[41,59,13],stripe:[],eye:[217,114,39],text:"body"}, //
			KK:{body:[255,	204,	153],dot:[189,132,69],stripe:[],eye:[189,132,69],text:"dot"}, //
			
			MM:{body:[66,	104,	8],dot:[],stripe:[106,	149,	41],eye:[106,	149,	41],text:"body"},
			NN:{body:[139,	34,	0],dot:[],stripe:[0,	24,	45],eye:[255,255,255],text:"body"},
			OO:{body:[255,255,255],dot:[],stripe:[243,	139,	222],eye:[138,	48,	137],text:"eye"},
			PP:{body:[49,	65,	180],dot:[],stripe:[0,	198,	199],eye:[255,255,255],text:"body"},
			QQ:{body:[139,	192,	87],dot:[],stripe:[240,	202,	0],eye:[255,255,255],text:"body"},
			RR:{body:[90,	149,	179],dot:[152,	55,	21],stripe:[],eye:[255,255,255],text:"body"},
			SS:{body:[255,255,255],dot:[],stripe:[0,0,0],eye:[255,0,0],text:"stripe"},
			TT:{body:[107,	60,	24],dot:[],stripe:[196,	19,	0],eye:[255,255,255],text:"stripe"},
			UU:{body:[56,	48,	10],dot:[],stripe:[85,	77,	29],eye:[255,255,255],text:"stripe"},
			VV:{body:[0,0,0],dot:[255,	125,	198],stripe:[],eye:[255,255,255],text:"dot"},
			WW:{body:[255,	125,	198],dot:[],stripe:[0,	0,	0],eye:[255,255,255],text:"body"},
			XX:{body:[200,	124,	90],dot:[],stripe:[70,	116,	139],eye:[255,255,255],text:"stripe"},
			YY:{body:[223,	173,	86],dot:[],stripe:[142,	33,	18],eye:[255,255,255],text:"stripe"},
			
			//prestige
			pra:{body:[102,	102,	102],dot:[],stripe:[0,	0,	0],eye:[255,255,255],text:"stripe"},			//bowler
			prb:{body:[193,	119,	72],dot:[255,255,255],stripe:[],eye:[0,0,0],text:"dot"},					//ginuea pig
			prc:{body:[255,  0,  0],dot:[],stripe:[],eye:[0,0,0],text:"body"}, //red ninja
			hhb:{body:[13,	13,	13],dot:[],stripe:[230,83,54],eye:[255,255,255],text:"stripe"},		//halloween	
			
			hhc:{body:[255,	110,	23],dot:[],stripe:[230,83,54],eye:[255,255,255],text:"stripe"},		//glow pumpkin		
			hha:{body:[86,	0,	199],dot:[],stripe:[0,0,0],eye:[255,255,255],text:"body"},	//witch 2	
			hhd:{body:[0,  0,  0],dot:[],stripe:[],eye:[255,255,255],text:"body"},	//back cat
			
			//custom public
			csb:{body:[255,	179,	255],		dot:[243,124,165],			stripe:[],		eye:[255,255,255],		text:"dot"},	//beehive		
			csd:{body:[113,	50,	21],		dot:[],			stripe:[230,196,149],		eye:[255,255,255],			text:"body"},	//pyramid				
			cse:{body:[237,	245,	170],		dot:[],			stripe:[159,232],		eye:[255,255,255],		text:"stripe"},	//red scarf
			
			//custom private
			csa:{body:[73,	73,	73],		dot:[],			stripe:[0,0,0],		eye:[192,69,253],		text:"eye"},	//fedora		
			csc:{body:[142,	142,142],		dot:[],			stripe:[61,61,61],		eye:[255,240,149],			text:"dot"},	// long headband				
			csf:{body:[82,	249,	134],		dot:[],			stripe:[117,48,181],		eye:[17,151,255],		text:"stripe"},	//imag dragon
			csg:{body:[53,	53,	53],		dot:[],			stripe:[0,0,0],		eye:[255,0,0],		text:"eye"}, // shadow link
			
			//indie
			ic_01_:{body:[209, 112, 57], dot:[], stripe:[253, 184, 65], eye:[255,255,255], text:"body"},
			ic_02_:{body:[30, 27, 29], dot:[], stripe:[234, 52, 53], eye:[255,255,255], text:"stripe"},
			ic_03_:{body:[129, 115, 116], dot:[], stripe:[230, 199, 168], eye:[255,255,255], text:"body"},
			ic_04_:{body:[44, 21, 44], dot:[], stripe:[42, 137, 99], eye:[255,255,255], text:"stripe"},
			ic_05_:{body:[1, 4, 74], dot:[], stripe:[27, 101, 167], eye:[255,255,255], text:"stripe"},
			ic_06_:{body:[61, 99, 136], dot:[], stripe:[239, 179, 134], eye:[255,255,255], text:"body"},
			ic_07_:{body:[9, 81, 152], dot:[], stripe:[0, 0, 0], eye:[255,255,255], text:"body"},
			ic_08_:{body:[9, 81, 152], dot:[], stripe:[0, 0, 0], eye:[255,255,255], text:"body"},
			ic_09_:{body:[28, 131, 121], dot:[], stripe:[32, 200, 179], eye:[255,255,255], text:"body"},
			
			ic_10_:{body:[2, 11, 17], dot:[86, 114, 117], stripe:[], eye:[254, 220, 112], text:"dot"},
			ic_11_:{body:[2, 11, 17], dot:[34, 55, 88], stripe:[], eye:[254, 214, 102], text:"eye"},
			ic_12_:{body:[32, 59, 72], dot:[], stripe:[7, 12, 19], eye:[248, 238, 170], text:"body"},
			ic_13_:{body:[12, 16, 16], dot:[], stripe:[30, 53, 4], eye:[255, 246, 172], text:"stripe"},
			ic_14_:{body:[25, 25, 26], dot:[], stripe:[133, 49, 11], eye:[255, 246, 172], text:"stripe"},
			ic_15_:{body:[230, 235, 215], dot:[], stripe:[255, 255, 255], eye:[0, 0, 0], text:"body"},
			ic_16_:{body:[98, 47, 31], dot:[], stripe:[198, 121, 53], eye:[255,255,255], text:"stripe"},
			ic_17_:{body:[0,0,0], dot:[], stripe:[], eye:[255,255,255], text:"body"},
			ic_18_:{body:[244, 240, 232], dot:[], stripe:[255, 255, 255], eye:[0, 0, 0], text:"body"},
			ic_19_:{body:[153, 209, 49], dot:[], stripe:[209, 253, 69], eye:[0,0,0], text:"stripe"},
			
			ic_20_:{body:[223, 215, 209], dot:[], stripe:[255, 255, 255], eye:[0,0,0], text:"stripe"},
			ic_21_:{body:[214, 72, 36], dot:[], stripe:[253, 130, 59], eye:[0,0,0], text:"body"},
			ic_22_:{body:[145, 105, 67], dot:[], stripe:[84, 56, 35], eye:[0,0,0], text:"body"},
			ic_23_:{body:[75, 141, 30], dot:[], stripe:[118, 167, 53], eye:[0,0,0], text:"body"},
			ic_24_:{body:[233, 142, 186], dot:[], stripe:[254, 183, 217], eye:[255,255,255], text:"body"},
			ic_25_:{body:[177, 6, 19], dot:[], stripe:[245, 13, 30], eye:[255,255,255], text:"stripe"},
			ic_26_:{body:[24, 41, 47], dot:[], stripe:[107, 135, 112], eye:[255,255,255], text:"stripe"},
			ic_27_:{body:[137, 19, 10], dot:[], stripe:[171, 44, 16], eye:[255,255,255], text:"eye"},
			ic_28_:{body:[255, 255, 253], dot:[], stripe:[0, 0, 0], eye:[252, 54, 59], text:"body"},
			ic_29_:{body:[0, 0, 0], dot:[], stripe:[68, 189, 249], eye:[255,255,255], text:"stripe"},
			
			ic_30_:{body:[0, 0, 0], dot:[], stripe:[68, 189, 249], eye:[255,255,255], text:"stripe"},
			ic_31_:{body:[41, 51, 54], dot:[], stripe:[111, 113, 130], eye:[0,0,0], text:"stripe"},
			ic_32_:{body:[72, 59, 138], dot:[], stripe:[140, 124, 167], eye:[0,0,0], text:"stripe"},
			ic_33_:{body:[72, 1, 13], dot:[], stripe:[153, 38, 56], eye:[255,255,255], text:"stripe"},
			ic_34_:{body:[77, 131, 149], dot:[], stripe:[246, 74, 180], eye:[255,255,255], text:"stripe"},
			ic_35_:{body:[22, 56, 185], dot:[], stripe:[196, 93, 24], eye:[255,255,255], text:"body"},
			ic_36_:{body:[101, 101, 101], dot:[], stripe:[151, 151, 152], eye:[255,255,255], text:"body"},
			ic_37_:{body:[141, 129, 106], dot:[], stripe:[185, 184, 167], eye:[0,0,0], text:"eye"},
			ic_38_:{body:[131, 131, 80], dot:[], stripe:[135, 80, 41], eye:[255,255,255], text:"eye"},
			ic_39_:{body:[255,255,255], dot:[], stripe:[253, 156, 253], eye:[0,0,0], text:"body"},
			
			ic_40_:{body:[255,255,255], dot:[], stripe:[70, 184, 77], eye:[0,0,0], text:"stripe"},
			ic_41_:{body:[255,255,255], dot:[], stripe:[221, 43, 46], eye:[0,0,0], text:"stripe"},
			ic_42_:{body:[255,255,255], dot:[], stripe:[247, 154, 70], eye:[0,0,0], text:"stripe"},
			ic_43_:{body:[255,255,255], dot:[], stripe:[85, 180, 202], eye:[0,0,0], text:"stripe"},
			ic_44_:{body:[232, 232, 232], dot:[], stripe:[255,255,255], eye:[0,0,0], text:"body"},
			ic_45_:{body:[232, 232, 232], dot:[], stripe:[255,255,255], eye:[0,0,0], text:"body"},
			ic_46_:{body:[232, 232, 232], dot:[], stripe:[255,255,255], eye:[0,0,0], text:"body"},
			ic_47_:{body:[232, 232, 232], dot:[], stripe:[255,255,255], eye:[0,0,0], text:"body"},
			ic_48_:{body:[254, 203, 46], dot:[], stripe:[252, 232, 52], eye:[0,0,0], text:"stripe"},
			ic_49_:{body:[19, 12, 8], dot:[], stripe:[158, 63, 57], eye:[255,255,255], text:"stripe"},
			
			ic_50_:{body:[59, 56, 46], dot:[], stripe:[86, 80, 56], eye:[255,255,255], text:"stripe"},
			ic_51_:{body:[0, 0, 0], dot:[], stripe:[40, 40, 30], eye:[252, 68, 30], text:"stripe"},
			ic_52_:{body:[61, 61, 57], dot:[], stripe:[], eye:[252, 68, 30], text:"stripe"},
			ic_53_:{body:[27, 13, 45], dot:[], stripe:[118, 100, 114], eye:[252, 68, 30], text:"stripe"},
			ic_54_:{body:[106, 99, 81], dot:[], stripe:[186, 178, 139], eye:[0,0,0], text:"body"},
			ic_55_:{body:[53, 53, 53], dot:[], stripe:[], eye:[255,255,255], text:"body"},
			ic_56_:{body:[53, 53, 53], dot:[], stripe:[], eye:[255,255,255], text:"body"},
			ic_57_:{body:[53, 53, 53], dot:[], stripe:[], eye:[255,255,255], text:"body"},
			ic_58_:{body:[53, 53, 53], dot:[], stripe:[], eye:[255,255,255], text:"body"},
			ic_59_:{body:[0,0,0], dot:[], stripe:[], eye:[255,255,255], text:"eye"},
			
			ic_60_:{body:[26, 155, 252], dot:[], stripe:[], eye:[255,255,255], text:"body"},
			ic_61_:{body:[252, 88, 36], dot:[], stripe:[253, 126, 55], eye:[0,0,0], text:"body"},
			ic_62_:{body:[150, 199, 209], dot:[], stripe:[], eye:[255,255,255], text:"eye"},
			ic_63_:{body:[211, 176, 94], dot:[], stripe:[133, 68, 21], eye:[255,255,255], text:"stripe"},
			ic_64_:{body:[140, 140, 140], dot:[], stripe:[41, 58, 98], eye:[255,255,255], text:"stripe"},
			ic_65_:{body:[121, 182, 68], dot:[], stripe:[83, 142, 35], eye:[0,0,0], text:"stripe"},
			ic_66_:{body:[216, 169, 123], dot:[], stripe:[45, 112, 184], eye:[0,0,0], text:"stripe"},
			ic_67_:{body:[32, 110, 208], dot:[], stripe:[251, 224, 50], eye:[255,255,255], text:"body"},
			ic_68_:{body:[250, 21, 122], dot:[], stripe:[164, 16, 127], eye:[255,255,255], text:"stripe"},
			ic_69_:{body:[253, 223, 50], dot:[], stripe:[252, 170, 57], eye:[255,255,255], text:"stripe"},
			
			
			ic_70_:{body:[252, 170, 57], dot:[], stripe:[250, 82, 78], eye:[255,255,255], text:"stripe"},
			ic_71_:{body:[0, 0, 0], dot:[], stripe:[], eye:[255,255,255], text:"body"},
			ic_72_:{body:[249, 48, 44], dot:[], stripe:[0, 0, 0], eye:[255,255,255], text:"body"},
			ic_73_:{body:[249, 48, 44], dot:[], stripe:[0, 0, 0], eye:[255,255,255], text:"body"},
			
			ic_74_:{body:[47, 48, 40], dot:[], stripe:[68, 69, 60], eye:[255,255,255], text:"body"},  //Dr Fetus
			ic_75_:{body:[118, 129, 156], dot:[], stripe:[109, 53, 176], eye:[255,255,255], text:"body"}, //Castle Crashers King
			ic_76_:{body:[123, 133, 159], dot:[], stripe:[124, 80, 59], eye:[255,255,255], text:"body"}, //Battle Block Theatre King
			ic_77_:{body:[253, 177, 45], dot:[], stripe:[87, 53, 251], eye:[255,255,255], text:"stripe"}, //Brick Stonewood
			ic_78_:{body:[254, 209, 232], dot:[], stripe:[246, 140, 234], eye:[255,255,255], text:"body"}, //Bunny
			ic_79_:{body:[61, 143, 184], dot:[], stripe:[73, 230, 252], eye:[255,255,255], text:"body"} // Slimo

		}
			
		private var hatMatcher:Object = {
			C:"o",A:"y",e:"v",f:"Q",g:"y",Z:"y",i:"qq",k:"N",l:"O",n:"G",o:"z",p:"P",
			r:"H",s:"nn",t:"ff",u:"hh",v:"ee",w:"dd",x:"ii",y:"jj",z:"ee",aa:"Z",
			bb:"bb",cc:"Y",dd:"V",ee:"S",ff:"T",gg:"X",hh:"ee",ii:"z",jj:"EE",pp:"d",
			ss:"DD",uu:"gg",vv:"GG",ww:"cc",xxx:"uu",yy:"g",zz:"LL",ab:"nn",cb:"y",db:"AA",
			eb:"zz",fb:"BB",gb:"rr",hb:"ss",ib:"pp",jb:"KK",kb:"f",lb:"vv",mb:"a",nb:"kk",
			ob:"x",pb:"nn",qb:"Q",rb:"z",sb:"ll",tb:"mm",wb:"r",xb:"r",yb:"r",zb:"W",
			fc:"kk",gc:"EE",hc:"ww",jc:"yy",kc:"M",lc:"U",mc:"m",nc:"a",oc:"f",pc:"b",
			rc:"MM",sc:"NN",qc:"OO",tc:"mm",uc:"PP",vc:"k",wc:"m",xc:"QQ",yc:"RR",
			zc:"m",ad:"kk",bd:"SS",id:"SS",jd:"TT",fd:"ee",cd:"P",hd:"k",ed:"m",gd:"UU",
			//prestige
			pra:"pra",prb:"prb",prc:"f",hhb:"hhb",
			
			//halloween
			hhc:"hhc",hha:"hha",hhd:"m",
			
			//custom
			csa:"csa",csb:"csb",csc:"csc",csd:"csd",cse:"cse",csf:"csf",csg:"csg",
			
			//indie
			ic_01_:"ic_01_",ic_02_:"ic_02_",ic_03_:"ic_03_",ic_04_:"ic_04_",ic_05_:"ic_05_",ic_06_:"ic_06_",ic_07_:"ic_07_",ic_08_:"ic_08_",ic_09_:"ic_09_",ic_10_:"ic_10_",
			ic_11_:"ic_11_", ic_12_:"ic_12_", ic_13_:"ic_13_", ic_14_:"ic_14_", ic_15_:"ic_15_", ic_16_:"ic_16_", ic_17_:"ic_17_", ic_18_:"ic_18_", ic_19_:"ic_19_",
			ic_20_:"ic_20_", ic_21_:"ic_21_", ic_22_:"ic_22_", ic_23_:"ic_23_", ic_24_:"ic_24_", ic_25_:"ic_25_", ic_26_:"ic_26_", ic_27_:"ic_27_", ic_28_:"ic_28_", ic_29_:"ic_29_",
			ic_30_:"ic_30_", ic_31_:"ic_31_", ic_32_:"ic_32_", ic_33_:"ic_33_", ic_34_:"ic_34_", ic_35_:"ic_35_", ic_36_:"ic_36_", ic_37_:"ic_37_", ic_38_:"ic_38_", ic_39_:"ic_39_",
			ic_40_:"ic_40_", ic_41_:"ic_41_", ic_42_:"ic_42_", ic_43_:"ic_43_", ic_44_:"ic_44_", ic_45_:"ic_45_", ic_46_:"ic_46_", ic_47_:"ic_47_", ic_48_:"ic_48_", ic_49_:"ic_49_",
			ic_50_:"ic_50_", ic_51_:"ic_51_", ic_52_:"ic_52_", ic_53_:"ic_53_", ic_54_:"ic_54_", ic_55_:"ic_55_", ic_56_:"ic_56_", ic_57_:"ic_57_", ic_58_:"ic_58_", ic_59_:"ic_59_",
			ic_60_:"ic_60_", ic_61_:"ic_61_", ic_62_:"ic_62_", ic_63_:"ic_63_", ic_64_:"ic_64_", ic_65_:"ic_65_", ic_66_:"ic_66_", ic_67_:"ic_67_", ic_68_:"ic_68_", ic_69_:"ic_69_",
			ic_70_:"ic_70_", ic_71_:"ic_71_", ic_72_:"ic_72_", ic_73_:"ic_73_",
			ic_74_:"ic_74_", ic_75_:"ic_75_", ic_76_:"ic_76_", ic_77_:"ic_77_", ic_78_:"ic_78_", ic_79_:"ic_79_"
			
		}
			
		// all colors go here
		public var dinoColors:Array = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E",
			"F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","aa","bb","cc","dd","ee","ff","gg","hh","ii","jj","kk","ll","mm",
			"nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xx","yy","zz","AA","BB","DD","EE","GG","LL","KK","MM","NN","OO","PP","QQ","RR","SS","TT","UU","VV",
			"WW","XX","YY",
			"pra","prb",		//prestige
			"hhb","hha","hhc",	//halloween	
			"csa","csb","csc","csd","cse","csf","csg",		//custom
			"ic_01_","ic_02_","ic_03_","ic_04_","ic_05_","ic_06_","ic_07_","ic_08_","ic_09_","ic_10_","ic_11_","ic_12_","ic_13_","ic_14_","ic_15_","ic_16_","ic_17_","ic_18_","ic_19_","ic_20_","ic_21_","ic_22_","ic_23_","ic_24_","ic_25_","ic_26_","ic_27_","ic_28_","ic_29_","ic_30_","ic_31_","ic_32_","ic_33_","ic_34_","ic_35_","ic_36_","ic_37_","ic_38_","ic_39_","ic_40_","ic_41_","ic_42_","ic_43_","ic_44_","ic_45_","ic_46_","ic_47_","ic_48_","ic_49_","ic_50_","ic_51_","ic_52_","ic_53_","ic_54_","ic_55_","ic_56_","ic_57_","ic_58_","ic_59_","ic_60_","ic_61_","ic_62_","ic_63_","ic_64_","ic_65_","ic_66_","ic_67_","ic_68_","ic_69_","ic_71_","ic_72_","ic_73_","ic_74_","ic_75_","ic_76_","ic_77_","ic_78_","ic_79_" //indie
			
		]
			
		//ALL HATS IN THE GAME
		public var hats:Array = ["xx","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d",
			"e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","aa","bb","cc","dd","ee","ff","gg","hh","ii","jj","kk","ll",
			"mm","nn","oo","pp","qq","rr","ss","tt","uu","vv","ww","xxx","yy","zz","ab","cb","db","eb","fb","gb","hb","ib","jb","kb","lb","mb","nb","ob","pb",
			"qb","rb","sb","tb","ub","vb","wb","xb","yb","zb","ac","bc","dc","ec","fc","gc","hc","ic","jc","kc","lc","mc","nc","oc","pc","qc","rc","sc","tc",
			"uc","vc","wc","xc","yc","zc","ad","bd","cd","fd","ed","hd","gd","id","jd",
			"kd","ld","md","nd","od","pd","qd","rd","sd","td",	//level 11-20
			"pra","prb","prc","hhb",							//prestige
			"hha","hhc","hhd",									//halloween
			"csa","csb","csc","csd","cse","csf","csg",			//custom
			"ic_02_","ic_03_","ic_04_","ic_05_","ic_60_","ic_61_","ic_50_","ic_51_","ic_52_","ic_53_","ic_49_","ic_10_","ic_11_","ic_12_","ic_13_","ic_14_","ic_15_","ic_16_","ic_17_","ic_18_","ic_19_","ic_20_","ic_21_","ic_22_","ic_23_","ic_25_","ic_24_","ic_74_","ic_26_","ic_27_","ic_28_","ic_29_","ic_32_","ic_33_","ic_35_","ic_34_","ic_36_","ic_37_","ic_39_","ic_40_","ic_41_","ic_42_","ic_43_","ic_75_","ic_38_","ic_76_","ic_44_","ic_45_","ic_46_","ic_47_","ic_48_","ic_54_","ic_55_","ic_58_","ic_59_","ic_62_","ic_63_","ic_64_","ic_65_","ic_06_","ic_08_","ic_68_","ic_09_","ic_77_","ic_78_","ic_79_", //indie
			"hhe_","hhf_","hhg_","hhh_","hhi_","hhj_","hhk_","hhl_","hhm_","hhn_","hho_","hhp_","hhq_","hhr_","hhs_","hht_","hhu_","hhv_","hhw_","hhx_", //halloween 2
			//vaults
			"vaultA_","vaultB_","vaultC_","vaultD_","vaultE_","vaultF_","vaultG_","vaultH_","vaultI_","vaultJ_","vaultK_","vaultL_","vaultM_","vaultN_","vaultO_",
			"vaultP_","vaultQ_","vaultR_","vaultS_","vaultT_","vaultU_","vaultV_","vaultW_","vaultX_","vaultY_","vaultZ_","vaultAA_","vaultBB_","vaultCC_","vaultDD_",
			"vaultEE_","vaultFF_","vaultGG_","vaultHH_","vaultII_","vaultJJ_","vaultKK_","vaultLL_","vaultMM_","vaultNN_","vaultOO_","vaultPP_","vaultQQ_","vaultRR_",
			"vaultSS_","vaultTT_","vaultUU_","vaultVV_","vaultWW_","vaultXX_","vaultYY_","vaultZZ_","vaultAAA_","vaultBBB_","vaultCCC_","vaultDDD_","vaultEEE_","vaultFFF_",
			"vaultGGG_","vaultHHH_","vaultIII_","vaultJJJ_","vaultLLL_","vaultMMM_","vaultNNN_","vaultOOO_","vaultPPP_","cov1_","cov2_","cov3_","cov4_","cov5_","cov6_","cov7_",
			//Adult Swim
			"ASa_", "ASb_", "ASc_", "ASd_", "ASe_", "ASf_", "ASg_", "ASh_", "ASi_", "ASj_", "ASk_", "ASl_", "ASm_", "ASn_", "ASo_", "ASp_", "ASq_", "ASr_", "ASs_"
		]
			
		public function HatUI()
		{
		}
	}
}