package bl {
	
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray; 
	import bl.BLEvent;
	
	/**
	 * BL manager files rewritten to properly work with FlashDevelop.
	 * @author Jean-Philippe Sarda
	 * @edited Simon Marynissen
	 */
	
	public class EditorManager extends EventDispatcher {
		
		public static var
			MAX_DATA_SIZE:Number = 40000;
			
		public var
			theroot:Main;
			
		private var
			sendconn:LocalConnection,
			rcvconn:LocalConnection,
			connectString:String = "BLConnectionRcv",
			cursoroverbl:Boolean = false,
			paused:Boolean = false,
			gldcmd:*, elcmd:*,
			blRc:Number;
		
		/**
		 * Constructor.
		 * @param	main	Your main class, must be named Main.
		 */
		public function EditorManager(main:Main) {
		    theroot = main;
		    try {
			    var keyStr:String;
			    var valueStr:String;
			    var paramObj:Object = LoaderInfo(theroot.root.loaderInfo).parameters;
			    for (keyStr in paramObj) {
					if (keyStr == "blRc") blRc = Number(paramObj[keyStr]);
			    }
			} catch (error:Error) {}
			connectString += blRc;
			sendconn = new LocalConnection();
            sendconn.addEventListener(StatusEvent.STATUS, onstatus);
			rcvconn = new LocalConnection();
			rcvconn.allowDomain("http://www.bonuslevel.org", "http://bonuslevel.org", "http://localhost");
			rcvconn.client = this;
			try {
                rcvconn.connect("BLEditorConnectionSnd" + blRc);
            } catch (error:ArgumentError) {
                trace("GameManager Can't connect... The connection name is already being used by another SWF");
            }
		}
		
		/**
		 * Is called by the level manager, when your editor is loaded and the BL API is ready
		 */
		public function blInit():void {
			// You may implement this function.
		}
		
		/**
		 * Is called by the level manager, when your editor is paused (put in background).
		 */
		public function blPause():void {
			// You may implement this function.
    		paused = true;
		}
		
		/**
		 * Is called by the level manager, when your editor is resumed (put in foreground).
		 */
		public function blResume():void {
			// You may implement this function.
    		paused = false;
		}
		
		/**
		 * Is called by the level manager when the stop button is pressed. It's a request to show the welcome screen of your game.
		 */
		public function blWelcome():void {
			// You may implement this function.
		}
		
		/**
		 * This method is called by the level manager, not by you.
		 */
		public function blGetLvlData():void {
			// You must implement this function.
			// Always include the sendLevelData method at the end of the function.
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes("Yoy must implement the blGetLvlData function of the editor manager.");
			sendLvlData(false, bytes);
		}
		
		/**
		 * This method is called by the level manager, not by you.
		 * @param	data	A ByteArray containing the level data to be unserialized and to be edited. If it's empty, you edit a new level.
		 */
		public function blEditLvl(data:ByteArray):void {
			// You must implement this function.
			// Always include the sendEditResult method at the end of the function.
			sendEditResult(false, "You must implement the blEditLvl function of the editor manager.");
		}
		
		private var dataStack:ByteArray;
		public function editLvl(cmd:*, data:ByteArray, packet_id:Number = 0, packet_nb:Number = 1):void {
			// Don't modify this function.
			if (packet_id == 0) dataStack = new ByteArray();
			dataStack.writeBytes(data);
			if (packet_id == packet_nb - 1) {
				elcmd = cmd;
				var bytes:ByteArray = new ByteArray();
				bytes.writeBytes(dataStack);
				blEditLvl(bytes);
				dataStack = new ByteArray();
			}
		}
		
		public function getLvlData(cmd:*):void {
			// Don't modify this function.
			gldcmd = cmd;
			blGetLvlData();
		}
		
		/**
		 * Call this function at the end of the blEditLvl function.
		 * @param	result	A Boolean wether it succeeded to unserialize and edit the level.
		 * @param	data	A string containing an error message if result is false.
		 */
		public function sendEditResult(result:Boolean, data:String):void {
			// Don't modify this function.
			sendconn.send(connectString, "editLvlCbk", elcmd, result, data);
		}
		
		/**
		 * Call this function at the end of the blGetLvlData function.
		 * @param	result	A Boolean wether it succeeded to get the level data and serialize it.
		 * @param	data	The serialized level data, or if result is false an error message.
		 */
		public function sendLvlData(result:Boolean, data:ByteArray):void {
			// Don't modify this function.
			// MAX_DATA_SIZE, split in small blocks of data if necessary.
			var packet_nb:Number = Math.ceil(data.length / MAX_DATA_SIZE);
			if (packet_nb <= 0) packet_nb = 1;
			for (var i:Number = 0; i < packet_nb; i++) {
				var packet:ByteArray = new ByteArray();
				var startRead:Number = i * MAX_DATA_SIZE;
				var readLength:Number = MAX_DATA_SIZE;
				if (startRead + readLength >= data.length) readLength = data.length - startRead;
				packet.writeBytes(data, startRead, readLength);
				sendconn.send(connectString, "getLvlDataByteArrayCbk", gldcmd, result, packet, i, packet_nb);
			}
		}
		
		/**
		 * You can call this method to display a trace in the debug console.
		 * @param	text	Contains the String you want to trace.
		 * @param	level	0 for important, 1 for medium, 2 for info.
		 */
		public function log(text:String, level:Number):void {
			// Don't modify this function.
			sendconn.send(connectString, "debug", text, level);
		}
		
		/**
		 * You can call this method to display the main menu.
		 * @param	command  -1 turns on the menu as it is. Other values are for specific screens, but are not yet defined.
		 */
		public function showMenu(command:Number):void {
			// Don't modify this function.
			sendconn.send(connectString, "cmdShowMenu", command);
		}
		
		/**
		 * You can call this method to display a popup with an info text.
		 * @param	text	The String you want to display.
		 */ 
		public function showInfo(text:String):void {
			// Don't modify this function.
			sendconn.send(connectString, "cmdShowInfo", text);
		}
		
		public function getMgrVersion():void {
			// Don't modify this function.
			sendconn.send(connectString, "setEditorManagerVersion", 3, 1);
		}
		
		/**
		 * You can call this method to know if the editor is paused (in background).
		 * @return	A Boolean wether the editor is paused.
		 */
		public function isPaused():Boolean {
			// Don't modify this function.
			return paused;
		}
		
		/**
		 * You must call this method when a mouse click is triggered in your swf to know if your mouse is over a Bonuslevel menu or popup.
		 * @return	A Boolean wether the mouse cursor is over a Bonuslevel menu or popup. If it's true you can't use the mouse click for your swf.
		 */
		public function cursorOverBLGUI():Boolean {
			// Don't modify this function.
			return cursoroverbl;
		}
		
		public function setCursorOverBLGUI(b:Boolean):void {
			// Don't modify this function.
			cursoroverbl = b;
			if (!paused) dispatchEvent(new BLEvent("GUI", b)); //dont dispatch if the app is paused
		}
		
		private function onstatus(event:StatusEvent):void {
			// Don't modify this function.
            switch (event.level) {
                case "status":
                    //trace("GameManager LocalConnection.send() succeeded");
                    break;
                case "error":
                    //trace("GameManager LocalConnection.send() failed");
                    break;
            }
        }
		
		public var gid:Number = -1; // game id
		public var path:String = "";
		public function initialize(g:Number, p:String):void {
			// Don't modify this function.
			gid = g;
			path = p;
			blInit();
		}
		
		/**
		 * Call this method to get the path to the extra resources (extra swf, images, etc.) you have uploaded to the BL servsers, you may want to load into you main swf.
		 * @return	A string containing the extra path.
		 */
		public function getExtraPath():String {
			// Don't modify this function.
			return path;
		}
	}
}