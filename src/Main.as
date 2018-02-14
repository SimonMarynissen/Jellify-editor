package {
	
	import bl.MyEditorManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import states.*;
	import gui.GridCell;
	[SWF(width = "640", height = "640", backgroundColor = "#fff7ff")]
	
	public class Main extends Sprite {
		
		public static var BLManager:MyEditorManager;
		private var state:State;
		
		public function Main() {
			BLManager = new MyEditorManager(this);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.frameRate = 30;
			EditorState.initBitmapDatas();
			GridCell.initBitmapData();
			switchState(new TitleState());
		}
		
		public function switchState(newState:State):void {
			if (state != null) {
				state.terminate();
				removeChild(state);
			}
			if (newState != null) {
				state = newState;
				addChild(state);
			}
		}
	}
}