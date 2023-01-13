package util
{
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class SharedObjectAlt
	{
		public var data:Object;
		private var f:File;
		private var fBackup:File;
		
		public function SharedObjectAlt(key:String)
		{
			trace (File.applicationStorageDirectory.nativePath);
			this.f = File.applicationStorageDirectory.resolvePath(key+".txt");
			this.fBackup = File.applicationStorageDirectory.resolvePath(key+"Backup.txt");
			if (f.exists)
			{
				trace ("alt exists");
				var fs:FileStream = new FileStream();
				fs.open(this.f, FileMode.READ);
				this.data = fs.readObject();
				fs.close();
			}
			else
			{
				trace ("make new alt data");
				this.data = new Object();
			}
		}
		
		public static function getLocal(key:String):SharedObjectAlt
		{
			return new SharedObjectAlt(key);
		}
		
		public function flush():void
		{
			trace ("flush alt");
			var fs:FileStream = new FileStream();
			fs.open(this.f, FileMode.WRITE);
			fs.writeObject(this.data);
			fs.close();
			
			
		}
		
		public function flushBackup():void
		{
			trace ("flush alt backup");
			var fs:FileStream = new FileStream();
			fs.open(this.fBackup, FileMode.WRITE);
			fs.writeObject(this.data);
			fs.close();
		}
		
		public function clear():void
		{
			trace ("clear alt");
			this.data = new Object();
			flush();
		}
	}
}