package states {
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class TitleState extends State {
		
		[Embed(source = "../img/bg.jpg")] private static const BG:Class;
		
		override public function startUp(e:Event):void {
			addChild(new Bitmap(new BG().bitmapData));
			Main.BLManager.blEditLvl(new ByteArray()); // uncomment for offline testing
		}
	}
}