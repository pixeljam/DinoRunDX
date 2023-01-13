package gamestats
{
	import com.amanitadesign.steam.DownloadUGCResult;
	import com.amanitadesign.steam.FRESteamWorks;
	import com.amanitadesign.steam.FileDetailsResult;
	import com.amanitadesign.steam.FilesByUserActionResult;
	import com.amanitadesign.steam.ItemVoteDetailsResult;
	import com.amanitadesign.steam.LeaderboardEntry;
	import com.amanitadesign.steam.SteamConstants;
	import com.amanitadesign.steam.SteamEvent;
	import com.amanitadesign.steam.SteamResults;
	import com.amanitadesign.steam.SubscribedFilesResult;
	import com.amanitadesign.steam.UploadLeaderboardScoreResult;
	import com.amanitadesign.steam.UserFilesResult;
	import com.amanitadesign.steam.UserStatsConstants;
	import com.amanitadesign.steam.UserVoteDetails;
	import com.amanitadesign.steam.WorkshopConstants;
	import com.amanitadesign.steam.WorkshopFilesResult;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import base.Brain;
	
	import ui.LEADERBOARD;
	import ui.UI;

	public class SteamStats
	{
		private var Steamworks:FRESteamWorks = new FRESteamWorks();
		
		public function SteamStats()
		{
			Brain.log ("steam stats");
			Steamworks.addEventListener(SteamEvent.STEAM_RESPONSE, onSteamResponse);
			NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExit);
		}
		
		public function init():void
		{
			Brain.log ("steam init");
			Steamworks.init();
		}
		
		public function getUserID():String
		{
			return Steamworks.getUserID();
		}
		
		public function getMyPersona():String 
		{
			//return "miles"; //MPTEMP
			return Steamworks.getPersonaName();
		}
		
		private var tempScore:int;
		private var tempHandle:String;
		private var tempUserID:String;
		public function submitScore(score:int,category:String = "normal"):void
		{
			tempScore = score;
			Brain.log ("submit score"+ " "+ score+ " "+category);
			Steamworks.findLeaderboard(category);
		}
		
		public function leaderboardFound(handle:String):void
		{
			tempHandle = handle;
			Brain.log ("LB found"+ " "+ handle+ " "+tempScore);
			Steamworks.uploadLeaderboardScore(handle,UserStatsConstants.UPLOADSCOREMETHOD_KeepBest,tempScore);
		}
		
		//private var tempLB:LEADERBOARD;
		public function showLeaderboards():void
		{
			//show internal LB
			//tempLB = new LEADERBOARD(tempScore);
			//UI._getInstance().addUI(tempLB);
		}
		
		public function getScores():void
		{
			Brain.log ("get steam scores"+ " "+ tempHandle);
			Steamworks.downloadLeaderboardEntries(tempHandle, UserStatsConstants.DATAREQUEST_Friends, 1, 500);
		}
		
		public function getPersona(id:String):String
		{
			return Steamworks.getFriendPersonaName(id);
		}
		
		public function entriesLoaded(entries:Array):void
		{
			//tempLB.scoresLoaded(entries,Steamworks.getPersonaName());
		}
		
		public function lbError():void
		{
			//tempLB.error(null);
		}
		
		public function submitAch(id:String,percentComplete:Number):void
		{
			Steamworks.setAchievement(id);
		}
		
		private function onExit(e:Event):void{
			Brain.log("Exiting application, cleaning up");
			Steamworks.dispose();
		}
		
		private var id:String;
		private var ugcHandle:String;
		private var publishedFile:String;
		private var leaderboard:String;
		private var scoreDetails:int = 0;
		private var authHandle:uint = 0;
		private var authTicket:ByteArray = null;
		private function onSteamResponse(e:SteamEvent):void{
			
			var apiCall:Boolean;
			var i:int;
			switch(e.req_type){
				case SteamConstants.RESPONSE_OnUserStatsStored:
					Brain.log("RESPONSE_OnUserStatsStored: "+e.response);
					break;
				case SteamConstants.RESPONSE_OnUserStatsReceived:
					Brain.log("RESPONSE_OnUserStatsReceived: "+e.response);
					break;
				case SteamConstants.RESPONSE_OnAchievementStored:
					Brain.log("RESPONSE_OnAchievementStored: "+e.response);
					break;
				case SteamConstants.RESPONSE_OnGlobalStatsReceived:
					Brain.log("RESPONSE_OnGlobalStatsReceived: " + e.response);
					break;
				case SteamConstants.RESPONSE_OnFindLeaderboard:
					Brain.log("RESPONSE_OnFindLeaderboad: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					/*if (leaderboard) {
						// result of findOrCreateLeaderboard
						var newLeaderboard:String = Steamworks.findLeaderboardResult();
						Brain.log("findLeaderboardResult() == " + newLeaderboard);
						if (newLeaderboard != leaderboard)
							Brain.log("FAILURE: findOrCreateLeaderboard() returned different leaderboard");
						
						break;
					}*/
					
					leaderboard = Steamworks.findLeaderboardResult();
					this.leaderboardFound(leaderboard);
					/*var name:String = Steamworks.getLeaderboardName(leaderboard)
					var sortMethod:int = Steamworks.getLeaderboardSortMethod(leaderboard);
					var displayType:int = Steamworks.getLeaderboardDisplayType(leaderboard)
					Brain.log("findLeaderboardResult() == " + leaderboard);
					Brain.log("getLeaderboardName(...) == " + name);
					Brain.log("getLeaderboardEntryCount(...) == " + Steamworks.getLeaderboardEntryCount(leaderboard));
					Brain.log("getLeaderboardSortMethod(...) == " + sortMethod);
					Brain.log("getLeaderboardDisplayType(...) == " + displayType);
					Brain.log("findOrCreateLeaderboard(...) == " + Steamworks.findOrCreateLeaderboard(
						name, sortMethod, displayType));*/
					break;
				case SteamConstants.RESPONSE_OnDownloadLeaderboardEntries:
					Brain.log("RESPONSE_OnDownloadLeaderboardEntries: " + e.response);
					if(e.response != SteamResults.OK) {
						lbError();
						Brain.log("FAILED!");
						break;
					}
					
					var entries:Array = Steamworks.downloadLeaderboardEntriesResult(scoreDetails);
					Brain.log("downloadLeaderboardEntriesResult(" + scoreDetails + ") == " + (entries ? ("Array, size " + entries.length) : "null"));
					/*for(i = 0; i < entries.length; ++i) {
						var en:LeaderboardEntry = entries[i];
						Brain.log(i + ": " + en.userID + ", " + en.globalRank + ", " + en.score + ", " + en.numDetails + "//" + en.details.length);
						for(var d:int = 0; d < en.details.length; ++d)
							Brain.log("\tdetails[" + d + "] == " + en.details[d]);
					}*/
					entriesLoaded(entries);
					scoreDetails = 0;
					break;
				case SteamConstants.RESPONSE_OnUploadLeaderboardScore:
					Brain.log("RESPONSE_OnUploadLeaderboardScore: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					var sr:UploadLeaderboardScoreResult = Steamworks.uploadLeaderboardScoreResult();
					Brain.log("uploadLeaderboardScoreResult() == " + sr);
					Brain.log("success: " + sr.success + ", score: " + sr.score + ", changed: " + sr.scoreChanged +
						", rank: " + sr.previousGlobalRank + " -> " + sr.newGlobalRank);
					//getUserScore(null);
					break;
				
				case SteamConstants.RESPONSE_OnPublishWorkshopFile:
					Brain.log("RESPONSE_OnPublishWorkshopFile: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					publishedFile = Steamworks.publishWorkshopFileResult();
					Brain.log("File published as " + publishedFile);
					if (publishedFile == WorkshopConstants.PUBLISHEDFILEID_Invalid) {
						Brain.log("FAILED!");
						break;
					}
					
					Brain.log("subscribePublishedFile(...) == " + Steamworks.subscribePublishedFile(publishedFile));
					break;
				case SteamConstants.RESPONSE_OnEnumerateUserSubscribedFiles:
					Brain.log("RESPONSE_OnEnumerateUserSubscribedFiles: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					var subRes:SubscribedFilesResult = Steamworks.enumerateUserSubscribedFilesResult();
					Brain.log("User subscribed files: " + subRes.resultsReturned + "/" + subRes.totalResults);
					for(i = 0; i < subRes.resultsReturned; i++) {
						id = subRes.publishedFileId[i];
						apiCall = Steamworks.getPublishedFileDetails(subRes.publishedFileId[i]);
						Brain.log(i + ": " + subRes.publishedFileId[i] + " (" + subRes.timeSubscribed[i] + ") - " + apiCall);
					}
					
					// only unsubscribe if we're subscribed to more than one file, so we
					// can continue testing UGCDownload etc.
					if(subRes.resultsReturned > 1) {
						var subbedFile:String = subRes.publishedFileId[1]
						apiCall = Steamworks.unsubscribePublishedFile(subbedFile);
						Brain.log("unsubscribePublishedFile(" + subbedFile + ") == " + apiCall);
					}
					
					if(subRes.resultsReturned > 0) {
						apiCall = Steamworks.setUserPublishedFileAction(
							subRes.publishedFileId[0], WorkshopConstants.FILEACTION_Played);
						Brain.log("setUserPublishedFileAction(..., Played) == " + apiCall);
					}
					break;
				case SteamConstants.RESPONSE_OnEnumerateUserSharedWorkshopFiles:
				case SteamConstants.RESPONSE_OnEnumerateUserPublishedFiles:
					var shared:Boolean = (e.req_type == SteamConstants.RESPONSE_OnEnumerateUserSharedWorkshopFiles);
					Brain.log((shared ?
						"RESPONSE_OnEnumerateUserSharedWorkshopFile" :
						"RESPONSE_OnEnumerateUserPublishedFiles: ") + e.response);
					if(e.response != SteamResults.OK) return;
					var userRes:UserFilesResult = shared ?
					Steamworks.enumerateUserSharedWorkshopFilesResult() :
					Steamworks.enumerateUserPublishedFilesResult();
					
					Brain.log("User " + (shared ? "shared" : "published") +" files: " +
						userRes.resultsReturned + "/" + userRes.totalResults);
					
					for(i = 0; i < userRes.resultsReturned; i++) {
						Brain.log(i + ": " + userRes.publishedFileId[i]);
					}
					
					if(userRes.resultsReturned > 0)
						publishedFile = userRes.publishedFileId[0];
					
					break;
				case SteamConstants.RESPONSE_OnEnumeratePublishedWorkshopFiles:
					Brain.log("RESPONSE_OnEnumeratePublishedWorkshopFiles: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					var fileRes:WorkshopFilesResult = Steamworks.enumeratePublishedWorkshopFilesResult();
					Brain.log("Workshop files: " + fileRes.resultsReturned + "/" + fileRes.totalResults);
					for(i = 0; i < fileRes.resultsReturned; i++) {
						Brain.log(i + ": " + fileRes.publishedFileId[i] + " - " + fileRes.score[i]);
					}
					if(fileRes.resultsReturned > 0) {
						var f:String = fileRes.publishedFileId[0];
						apiCall = Steamworks.updateUserPublishedItemVote(f, true);
						Brain.log("updateUserPublishedItemVote(" + f + ", true) == " + apiCall);
						apiCall = Steamworks.getPublishedItemVoteDetails(f);
						Brain.log("getPublishedItemVoteDetails(" + f + ") == " + apiCall);
						apiCall = Steamworks.getUserPublishedItemVoteDetails(f);
						Brain.log("getUserPublishedItemVoteDetails(" + f + ") == " + apiCall);
					}
					break;
				case SteamConstants.RESPONSE_OnEnumeratePublishedFilesByUserAction:
					Brain.log("RESPONSE_OnEnumeratePublishedFilesByUserAction: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					var actionRes:FilesByUserActionResult = Steamworks.enumeratePublishedFilesByUserActionResult();
					// TODO: m_eAction seems to be uninitialized?
					Brain.log("Files for action " + actionRes.action + ": " +
						actionRes.resultsReturned + "/" + actionRes.totalResults);
					
					for(i = 0; i < actionRes.resultsReturned; i++) {
						Brain.log(i + ": " + actionRes.publishedFileId[i] + " - " + actionRes.timeUpdated[i]);
						if (actionRes.action == WorkshopConstants.FILEACTION_Played) {
							Brain.log("setUserPublishedFileAction(..., Completed) == " +
								Steamworks.setUserPublishedFileAction(actionRes.publishedFileId[i],
									WorkshopConstants.FILEACTION_Completed));
						}
					}
					break;
				case SteamConstants.RESPONSE_OnGetPublishedFileDetails:
					Brain.log("RESPONSE_OnGetPublishedFileDetails: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					var res:FileDetailsResult = Steamworks.getPublishedFileDetailsResult(id);
					Brain.log("Result for " + id + ": " + res);
					if(res) {
						Brain.log("File: " + res.fileName + ", handle: " + res.fileHandle);
						ugcHandle = res.fileHandle;
						apiCall = Steamworks.UGCDownload(res.fileHandle, 0);
						Brain.log("UGCDownload(...) == " + apiCall);
						var progress:Array = Steamworks.getUGCDownloadProgress(res.fileHandle);
						Brain.log("getUGCDownloadProgress(...) == " + progress);
						setTimeout(function():void {
							var progress:Array = Steamworks.getUGCDownloadProgress(res.fileHandle);
							Brain.log("getUGCDownloadProgress(...) == " + progress);
						}, 1000);
					}
					break;
				case SteamConstants.RESPONSE_OnUGCDownload:
					Brain.log("RESPONSE_OnUGCDownload: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					var ugcResult:DownloadUGCResult = Steamworks.getUGCDownloadResult(ugcHandle);
					Brain.log("Result for " + ugcHandle + ": " + ugcResult);
					if(ugcResult) {
						Brain.log("File: " + ugcResult.fileName + ", handle: " + ugcResult.fileHandle + ", size: " + ugcResult.size);
						var ba:ByteArray = new ByteArray();
						apiCall = Steamworks.UGCRead(ugcResult.fileHandle, ugcResult.size, 0, ba);
						Brain.log("UGCRead(...) == " + apiCall);
						if(apiCall) {
							Brain.log("Result length: " + ba.position + "//" + ba.length);
							Brain.log("Result: " + ba.readUTFBytes(ugcResult.size));
						}
					}
					break;
				case SteamConstants.RESPONSE_OnGetPublishedItemVoteDetails:
					Brain.log("RESPONSE_OnGetPublishedItemVoteDetails: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					var voteDetails:ItemVoteDetailsResult = Steamworks.getPublishedItemVoteDetailsResult();
					Brain.log("getPublishedItemVoteDetails() == " + (voteDetails ? voteDetails.result : "null"));
					if(!voteDetails) return;
					
					// no native JSON support for Linux ...
					Brain.log("votes: " + voteDetails.votesFor + "//" + voteDetails.votesAgainst +
						", score: " + voteDetails.score + ", reports: " + voteDetails.reports);
					break;
				case SteamConstants.RESPONSE_OnGetUserPublishedItemVoteDetails:
					Brain.log("RESPONSE_OnGetUserPublishedItemVoteDetails: " + e.response);
					if(e.response != SteamResults.OK) {
						Brain.log("FAILED!");
						break;
					}
					
					var userVoteDetails:UserVoteDetails = Steamworks.getUserPublishedItemVoteDetailsResult();
					Brain.log("getUserPublishedItemVoteDetails() == " + (userVoteDetails ? userVoteDetails.result : "null"));
					if(!userVoteDetails) return;
					
					Brain.log("vote: " + userVoteDetails.vote);
					break;
								
				default:
					Brain.log("STEAMresponse type:"+e.req_type+" response:"+e.response);
			}
		}
	}
}