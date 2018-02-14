package states {
	
	import com.Base64;
	import com.bit101.components.CheckBox;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.RadioButton;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import gui.*;
	
	public class EditorState extends State {
		
		[Embed(source = "../img/panel.png")] private static const PANEL:Class;
		[Embed(source = "../img/colours.png")] private static const COLOUR:Class;
		[Embed(source = "../img/blocks.png")] private static const BLOCK:Class;
		[Embed(source = "../img/immobileBlocks.png")] private static const IMMOBILE_BLOCK:Class;
		[Embed(source = "../img/wall.png")] private static const WALL:Class;
		[Embed(source = "../img/garbage.png")] private static const GARBAGE:Class;
		[Embed(source = "../img/boundary.png")] private static const BOUNDARY:Class;
		[Embed(source = "../img/select.png")] private static const SELECT:Class;
		[Embed(source = "../img/wallBlockSeparation.png")] private static const WALL_BLOCK_SEPARATE:Class;
		[Embed(source = "../img/wallBlockSeparationConfirmation.png")] private static const WALL_BLOCK_SEPARATE_CONFIRM:Class;
		[Embed(source = "../img/wallBlockSeparationGarbage.png")] private static const WALL_BLOCK_SEPARATE_GARBAGE:Class;
		[Embed(source = "../img/blockConnection.png")] private static const BLOCK_CONNECTION:Class;
		[Embed(source = "../img/blockConnectionGarbage.png")] private static const BLOCK_CONNECTION_GARBAGE:Class;
		[Embed(source = "../img/colourChangers.png")] private static const COLOUR_CHANGER:Class;
		[Embed(source = "../img/bombs.png")] private static const BOMB:Class;
		[Embed(source = "../img/forceFields.png")] private static const FORCE_FIELD:Class;
		[Embed(source = "../img/hinges.png")] private static const HINGE:Class;
		[Embed(source = "../img/locked.png")] private static const LOCKED:Class;
		[Embed(source = "../img/spikes.png")] private static const SPIKE:Class;
		[Embed(source = "../img/freezers.png")] private static const FREEZER:Class;
		[Embed(source = "../img/defrosters.png")] private static const DEFROSTER:Class;
		[Embed(source = "../img/moveCount.png")] private static const MOVE_COUNT:Class;
		
		
		private static const
			COLOUR_BITMAPDATA:Array = [],
			BLOCK_BITMAPDATA:Array = [],
			IMMOBILE_BLOCK_BITMAPDATA:Array = [],
			FORCE_FIELD_BITMAPDATA:Array = [],
			FORCE_FIELD_PASTE_BITMAPDATA:Array = [],
			WALL_ATTACHMENT_BITMAPDATA:Array = [],
			WALL_ATTACHMENT_BUTTON_BITMAPDATA:Array = [],
			MOVE_COUNT_BITMAPDATA:Array = [],
			WALL_BLOCK_SEPARATION_BITMAPDATA:Array = [[], []];
		
		public static var
			dataMap:Array = new Array();
			
		private static var
			WALL_BITMAPDATA:BitmapData;
		
		private var
			grid:Array = [],
			panel:Bitmap,
			displayMap:Array = [],
			displayLayers:/*Sprite*/Array = [],
			colours:/*Sprite*/Array = [],
			colour:int = 0,
			block:Sprite = new Sprite(),
			blockBitmap:Bitmap,
			blockUnderLocked:Sprite = new Sprite(),
			blockUnderLockedBitmap:Bitmap,
			blockUnderMoveCount:Sprite = new Sprite(),
			blockUnderMoveCountBitmap:Bitmap,
			wallBlockUnderMoveCount:Sprite = new Sprite(),
			wallBlockUnderMoveCountBitmap:Bitmap,
			immobileBlock:Sprite = new Sprite(),
			immobileBlockBitmap:Bitmap,
			locked:Sprite = new Sprite(),
			lockedBitmap:Bitmap,
			wall:Sprite = new Sprite(),
			movableWall:Sprite = new Sprite(),
			immobileMovableWall:Sprite = new Sprite(),
			garbage:Sprite = new Sprite(),
			garbageBitmap:Bitmap,
			boundary:Sprite = new Sprite(),
			boundaryBitmap:Bitmap,
			boundaryWalls:Array = [],
			select:Sprite = new Sprite(),
			selectBitmap:Bitmap,
			wallBlockSeparate:Sprite = new Sprite(),
			wallBlockSeparateBitmap:Bitmap,
			wallBlockUnderSeparate:Sprite = new Sprite(),
			wallBlockUnderSeparateBitmap:Bitmap,
			wallBlockSeparateConfirm:Sprite = new Sprite(),
			wallBlockSeparateConfirmBitmap:Bitmap,
			wallBlockUnderSeparateConfirm:Sprite = new Sprite(),
			wallBlockUnderSeparateConfirmBitmap:Bitmap,
			wallBlockSeparateGarbage:Sprite = new Sprite(),
			wallBlockSeparateGarbageBitmap:Bitmap,
			wallBlockUnderSeparateGarbage:Sprite = new Sprite(),
			wallBlockUnderSeparateGarbageBitmap:Bitmap,
			blockConnection:Sprite = new Sprite(),
			blockConnectionBitmap:Bitmap,
			blockConnectionGarbage:Sprite = new Sprite(),
			blockConnectionGarbageBitmap:Bitmap,
			forceFields:Array = [],
			forceFieldBitmaps:Array = [],
			wallAttachmentButtons:Array = [],
			ccButtonBitmap:Bitmap,
			wallAttachmentType:int = 0,
			wallAttachmentStartIndex:Array = [6, 10, 18, 23, 27, 31],
			wallAttachments:Array = [],
			wallAttachmentBitmaps:Array = [],
			selectionType:int = 0,
			selectionBitmap:Bitmap = new Bitmap(),
			upCheckBox:CheckBox,
			leftCheckBox:CheckBox,
			rightCheckBox:CheckBox,
			downCheckBox:CheckBox,
			upStartGravity:RadioButton,
			leftStartGravity:RadioButton,
			rightStartGravity:RadioButton,
			downStartGravity:RadioButton,
			gravityChangersText:TextField,
			startGravityText:TextField,
			selectText:TextField,
			toolTip:TextField,
			shapeSteppers:/*NumericStepper*/Array = [],
			shapeSteppersUnderColour:Array = [],
			shapeEnabler:CheckBox,
			movesCount:Sprite = new Sprite(),
			movesCountBitmap:Bitmap,
			wallMovesCount:Sprite = new Sprite(),
			wallMovesCountBitmap:Bitmap,
			moveCount:int = 1,
			moveCountStepper:NumericStepper;
		
		public static function initBitmapDatas():void {
			for (var f:int = 0; f < 6; f++)
				WALL_ATTACHMENT_BITMAPDATA[f] = [];
			WALL_ATTACHMENT_BUTTON_BITMAPDATA[0] = [];
			var bit:BitmapData = new WALL_BLOCK_SEPARATE().bitmapData;
			
			for (var i:int = 0; i < 20; i++) {
				if (i < 16) {
					(WALL_BLOCK_SEPARATION_BITMAPDATA[0][i] = new BitmapData(32, 32, true, 0)).copyPixels(
							bit, new Rectangle(0, 32 * i, 32, 32), new Point(0, 0), null, null, true);
					(WALL_BLOCK_SEPARATION_BITMAPDATA[1][i] = new BitmapData(32, 32, true, 0)).copyPixels(
							bit, new Rectangle(32, 32 * i, 32, 32), new Point(0, 0), null, null, true);
				} else {
					var j:int = i - 16;
					var X:int = 16 * int(j % 2);
					var Y:int = 16 * int(j > 1);
					(WALL_BLOCK_SEPARATION_BITMAPDATA[0][i] = new BitmapData(32, 32, true, 0)).copyPixels(
							bit, new Rectangle(X, 512 + Y, 16, 16), new Point(X, Y), null, null, true);
					(WALL_BLOCK_SEPARATION_BITMAPDATA[1][i] = new BitmapData(32, 32, true, 0)).copyPixels(
							bit, new Rectangle(32+ X, 512 + Y, 16, 16), new Point(X, Y), null, null, true);
				}
			}
			bit.dispose();
			for (i = 0; i <= 11; i++) {
				(BLOCK_BITMAPDATA[i] = new BitmapData(32, 32, true)).copyPixels(
						new BLOCK().bitmapData,
						new Rectangle(i * 32, 0, 32, 32),
						new Point(0, 0));
				(IMMOBILE_BLOCK_BITMAPDATA[i] = new BitmapData(32, 32, true)).copyPixels(
						new IMMOBILE_BLOCK().bitmapData,
						new Rectangle(i * 32, 0, 32, 32),
						new Point(0, 0));
				bit = new MOVE_COUNT().bitmapData;
				MOVE_COUNT_BITMAPDATA[i] = [];
				for (j = 0; j < 9; j++) {
					(MOVE_COUNT_BITMAPDATA[i][j] = new BitmapData(32, 32, true, 0)).copyPixels(
						bit,
						new Rectangle((8 - j) * 8, 12 * i, 8, 12),
						new Point(12, 10));
				}
				bit.dispose();
				if (i == 11)
					break;
				(COLOUR_BITMAPDATA[i] = new BitmapData(16, 16, false)).copyPixels(
						new COLOUR().bitmapData,
						new Rectangle(i * 16, 0, 16, 16),
						new Point(0, 0));
				(WALL_ATTACHMENT_BUTTON_BITMAPDATA[0][i] = new BitmapData(32, 32, true, 0)).copyPixels(
						new COLOUR_CHANGER().bitmapData, new Rectangle(32 * i, 0, 32, 32), new Point());
				WALL_ATTACHMENT_BITMAPDATA[0][i] = [[], []];
				FORCE_FIELD_BITMAPDATA[i] = [];
				FORCE_FIELD_PASTE_BITMAPDATA[i] = [];
				for (j = 0; j < 4; j++) {
					var w:int = 6 * Math.floor(((j + 1) % 4) / 2) + 20 * Math.floor(((j + 3) % 4) / 2);
					var h:int = 20 * Math.floor(((j + 1) % 4) / 2) + 6 * Math.floor(((j + 3) % 4) / 2);
					var bitX:int = 6 * Math.floor(((j + 3) % 4) / 2) + 26 * int(j == 2);
					var bitY:int = 6 * Math.floor(((j + 1) % 4) / 2) + 26 * int(j == 3);
					for (var k:int = 0; k < 2; k++) {
						(WALL_ATTACHMENT_BITMAPDATA[0][i][k][j] = new BitmapData(32, 32, true, 0)).copyPixels(new COLOUR_CHANGER().bitmapData,
								new Rectangle(32 * i + bitX, 32 * k + bitY, w, h), new Point(bitX, bitY), null, null, true);
					}
					w = 4 * Math.floor(((j + 1) % 4) / 2) + 24 * Math.floor(((j + 3) % 4) / 2);
					h = 24 * Math.floor(((j + 1) % 4) / 2) + 4 * Math.floor(((j + 3) % 4) / 2);
					bitX = 4 * Math.floor(((j + 3) % 4) / 2) + 28 * int(j == 2);
					bitY = 4 * Math.floor(((j + 1) % 4) / 2) + 28 * int(j == 3);
					(FORCE_FIELD_BITMAPDATA[i][j] = new BitmapData(24, 24, true, 0)).copyPixels(new FORCE_FIELD().bitmapData,
							new Rectangle(32 * i + bitX, bitY, w, h), new Point(20 * int(j == 2), 20 * int(j == 3)), null, null, true);
					(FORCE_FIELD_PASTE_BITMAPDATA[i][j] = new BitmapData(32, 32, true, 0)).copyPixels(new FORCE_FIELD().bitmapData,
							new Rectangle(32 * i + bitX, bitY, w, h), new Point(bitX, bitY), null, null, true);
				}
			}
			for (i = 1; i < 6; i++) {
				if (i == 3)
					WALL_ATTACHMENT_BUTTON_BITMAPDATA[i] = new BitmapData(40, 40, true, 0);
				else
					WALL_ATTACHMENT_BUTTON_BITMAPDATA[i] = new BitmapData(32, 32, true, 0);
			}
			WALL_ATTACHMENT_BUTTON_BITMAPDATA[1].copyPixels(new BOMB().bitmapData,
				new Rectangle(0, 0, 32, 32), new Point(), null, null, true);
			for (i = 0; i < 4; i++) {
				w = 6 * Math.floor(((i + 1) % 4) / 2) + 20 * Math.floor(((i + 3) % 4) / 2);
				h = 20 * Math.floor(((i + 1) % 4) / 2) + 6 * Math.floor(((i + 3) % 4) / 2);
				bitX = 6 * Math.floor(((i + 3) % 4) / 2) + 26 * int(i == 2);
				bitY = 6 * Math.floor(((i + 1) % 4) / 2) + 26 * int(i == 3);
				(WALL_ATTACHMENT_BITMAPDATA[1][i] = new BitmapData(38, 38, true, 0)).copyPixels(new BOMB().bitmapData,
					new Rectangle(bitX, bitY, w, h), new Point(bitX, bitY), null, null, true);
				(WALL_ATTACHMENT_BITMAPDATA[2][i] = new BitmapData(32, 32, true, 0)).copyPixels(new HINGE().bitmapData,
					new Rectangle(32 * i, 0, 32, 32), new Point(), null, null, true);
				(WALL_ATTACHMENT_BITMAPDATA[3][i] = new BitmapData(40, 40, true, 0)).copyPixels(new SPIKE().bitmapData,
					new Rectangle(40 * i, 0, 40, 40), new Point(), null, null, true);
				(WALL_ATTACHMENT_BITMAPDATA[4][i] = new BitmapData(32, 32, true, 0)).copyPixels(new FREEZER().bitmapData,
					new Rectangle(32 * i, 0, 32, 32), new Point(), null, null, true);
				(WALL_ATTACHMENT_BITMAPDATA[5][i] = new BitmapData(32, 32, true, 0)).copyPixels(new DEFROSTER().bitmapData,
					new Rectangle(32 * i, 0, 32, 32), new Point(), null, null, true);
				WALL_ATTACHMENT_BUTTON_BITMAPDATA[2].copyPixels(new HINGE().bitmapData,
					new Rectangle(32 * i, 0, 32, 32), new Point(), null, null, true);
				WALL_ATTACHMENT_BUTTON_BITMAPDATA[3].copyPixels(new SPIKE().bitmapData,
					new Rectangle(40 * i, 0, 40, 40), new Point(), null, null, true);
				WALL_ATTACHMENT_BUTTON_BITMAPDATA[4].copyPixels(new FREEZER().bitmapData,
					new Rectangle(32 * i, 0, 32, 32), new Point(), null, null, true);
				WALL_ATTACHMENT_BUTTON_BITMAPDATA[5].copyPixels(new DEFROSTER().bitmapData,
					new Rectangle(32 * i, 0, 32, 32), new Point(), null, null, true);
			}
			(WALL_BITMAPDATA = new BitmapData(32, 32, true, 0)).copyPixels(
					new WALL().bitmapData,
					new Rectangle(0, 0, 32, 32),
					new Point(0, 0));
		}
		
		public function EditorState(data:ByteArray) {
			super();
			//var str:String = "eNp90UF2wyAMRdEiSwjhQRfQVXb/g1YgvzBKwjnONf5YAsdvi2j6FXdTydF06B3eNiKs6RU/+fwZa/44rysqGjqAgw4MKLgKV1US1UQs9IStbqIK/eVPZ4Wc9ABxMEGsjazeXacKdRp1HhjowMEAcSDVz8h1xroXOnBSk3aEBuXMBBjAQQcGFFxAwGtLHXht3bOVtdHnHOrmO79jjlknWse6/ziPu/Ka007ePuSdyHgb6RXxvNlP7SSJGL1ble97Vmph3+8/b1+Xf95uS78=";
			//data = Base64.decodeToByteArray(str);
			//data.uncompress();
			if (data.length == 0)
				dataMap = [[0]];
			else {
				data.position = 0;
				dataMap = data.readObject();
				data.position = 0;
			}
			for (var x:int = 0; x < 14; x++) {
				grid[x] = new Array();
				displayMap[x] = [];
				for (var y:int = 0; y < 14; y++) {
					addChild(grid[x][y] = new GridCell(x, y));
					displayMap[x][y] = [];
					for (var z:int = 0; z < J.LAYER_AMOUNT; z++)
						displayMap[x][y][z] = [];
				}
			}
			panel = new Bitmap(new PANEL().bitmapData);
			addChild(panel);
			addChild(selectionBitmap);
			var clickColours:Array = [clickGrey, clickRed, clickBlue, clickGreen, clickYellow, clickPurple, clickPink, clickCyan, clickOrange, clickDarkRed, clickDarkGreen];
			var overColours:Array = [overGrey, overRed, overBlue, overGreen, overYellow, overPurple, overPink, overCyan, overOrange, overDarkRed, overDarkGreen];
			for (var i:int = 0; i <= 10; i++) {
				colours[i] = new Sprite();
				colours[i].buttonMode = true;
				colours[i].addChild(new Bitmap(COLOUR_BITMAPDATA[i]));
				colours[i].x = 16 + 32 * ((i+4) % 5);
				colours[i].y = 16 + Math.floor((i + 4) / 5) * 32;
				colours[i].addEventListener(MouseEvent.CLICK, clickColours[i]);
				colours[i].addEventListener(MouseEvent.MOUSE_OVER, overColours[i]);
				colours[i].addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				addChild(colours[i]);
			}
			
			block.x = 16;
			block.y = 128;
			blockBitmap = new Bitmap(BLOCK_BITMAPDATA[0]);
			block.addChild(blockBitmap);
			block.buttonMode = true;
			block.addEventListener(MouseEvent.CLICK, clickBlock);
			block.addEventListener(MouseEvent.MOUSE_OVER, overBlock);
			block.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(block);
			
			blockUnderLocked.x = 128;
			blockUnderLocked.y = 128;
			blockUnderLocked.alpha = 0.5;
			blockUnderLockedBitmap = new Bitmap(BLOCK_BITMAPDATA[0]);
			blockUnderLocked.addChild(blockUnderLockedBitmap);
			addChild(blockUnderLocked);
			
			blockUnderMoveCount.x = 128;
			blockUnderMoveCount.y = 192;
			blockUnderMoveCount.alpha = 0.5;
			blockUnderMoveCountBitmap = new Bitmap(BLOCK_BITMAPDATA[0]);
			blockUnderMoveCount.addChild(blockUnderMoveCountBitmap);
			addChild(blockUnderMoveCount);
			
			wallBlockUnderMoveCount.x = 128;
			wallBlockUnderMoveCount.y = 256;
			wallBlockUnderMoveCount.alpha = 0.5;
			wallBlockUnderMoveCountBitmap = new Bitmap(BLOCK_BITMAPDATA[11]);
			wallBlockUnderMoveCount.addChild(wallBlockUnderMoveCountBitmap);
			addChild(wallBlockUnderMoveCount);
			
			immobileBlock.x = 64;
			immobileBlock.y = 128;
			immobileBlockBitmap = new Bitmap(IMMOBILE_BLOCK_BITMAPDATA[0]);
			immobileBlock.addChild(immobileBlockBitmap);
			immobileBlock.buttonMode = true;
			immobileBlock.addEventListener(MouseEvent.CLICK, clickImmobileBlock);
			immobileBlock.addEventListener(MouseEvent.MOUSE_OVER, overImmobileBlock);
			immobileBlock.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(immobileBlock);
			
			locked.x = 128;
			locked.y = 128;
			lockedBitmap = new Bitmap(new LOCKED().bitmapData);
			locked.addChild(lockedBitmap);
			locked.buttonMode = true;
			locked.addEventListener(MouseEvent.CLICK, clickLocked);
			locked.addEventListener(MouseEvent.MOUSE_OVER, overLocked);
			locked.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(locked);
			
			movesCount.x = 128;
			movesCount.y = 192;
			movesCountBitmap = new Bitmap(MOVE_COUNT_BITMAPDATA[colour][moveCount - 1])
			movesCount.addChild(movesCountBitmap);
			movesCount.buttonMode = true;
			movesCount.addEventListener(MouseEvent.CLICK, clickMovesCount);
			movesCount.addEventListener(MouseEvent.MOUSE_OVER, overMovesCount);
			movesCount.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(movesCount);
			
			wallMovesCount.x = 128;
			wallMovesCount.y = 256;
			wallMovesCountBitmap = new Bitmap(MOVE_COUNT_BITMAPDATA[11][moveCount - 1])
			wallMovesCount.addChild(wallMovesCountBitmap);
			wallMovesCount.buttonMode = true;
			wallMovesCount.addEventListener(MouseEvent.CLICK, clickWallMovesCount);
			wallMovesCount.addEventListener(MouseEvent.MOUSE_OVER, overWallMovesCount);
			wallMovesCount.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(wallMovesCount);
			
			wall.x = 16;
			wall.y = 560;
			wall.addChild(new Bitmap(WALL_BITMAPDATA));
			wall.buttonMode = true;
			wall.addEventListener(MouseEvent.CLICK, clickWall);
			wall.addEventListener(MouseEvent.MOUSE_OVER, overWall);
			wall.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(wall);
			
			movableWall.x = 80;
			movableWall.y = 560;
			movableWall.addChild(new Bitmap(BLOCK_BITMAPDATA[11]));
			movableWall.buttonMode = true;
			movableWall.addEventListener(MouseEvent.CLICK, clickMovableWall);
			movableWall.addEventListener(MouseEvent.MOUSE_OVER, overMovableWall);
			movableWall.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(movableWall);
			
			immobileMovableWall.x = 128;
			immobileMovableWall.y = 560;
			immobileMovableWall.addChild(new Bitmap(IMMOBILE_BLOCK_BITMAPDATA[11]));
			immobileMovableWall.buttonMode = true;
			immobileMovableWall.addEventListener(MouseEvent.CLICK, clickImmobileMovableWall);
			immobileMovableWall.addEventListener(MouseEvent.MOUSE_OVER, overImmobileMovableWall);
			immobileMovableWall.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(immobileMovableWall);
			
			garbage.x = 144;
			garbage.y = 480;
			garbage.addChild(garbageBitmap = new Bitmap(new GARBAGE().bitmapData));
			garbage.buttonMode = true;
			garbage.addEventListener(MouseEvent.CLICK, clickGarbage);
			garbage.addEventListener(MouseEvent.MOUSE_OVER, overGarbage);
			garbage.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(garbage);
			
			boundary.x = 184;
			boundary.y = 480;
			boundary.addChild(boundaryBitmap = new Bitmap(new BOUNDARY().bitmapData));
			boundary.buttonMode = true;
			boundary.addEventListener(MouseEvent.CLICK, clickBoundary);
			boundary.addEventListener(MouseEvent.MOUSE_OVER, overBoundary);
			boundary.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(boundary);
			
			select.x = 224;
			select.y = 480;
			select.addChild(selectBitmap = new Bitmap(new SELECT().bitmapData));
			select.buttonMode = true;
			select.addEventListener(MouseEvent.CLICK, clickSelect);
			select.addEventListener(MouseEvent.MOUSE_OVER, overSelect);
			select.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(select);
			
			wallBlockUnderSeparate.x = 288;
			wallBlockUnderSeparate.y = 480;
			wallBlockUnderSeparate.alpha = 0.5;
			wallBlockUnderSeparateBitmap = new Bitmap(BLOCK_BITMAPDATA[11]);
			wallBlockUnderSeparate.addChild(wallBlockUnderSeparateBitmap);
			addChild(wallBlockUnderSeparate);
			
			wallBlockSeparate.x = 288;
			wallBlockSeparate.y = 480;
			wallBlockSeparate.addChild(wallBlockSeparateBitmap = new Bitmap(WALL_BLOCK_SEPARATION_BITMAPDATA[0][0]));
			wallBlockSeparate.buttonMode = true;
			wallBlockSeparate.addEventListener(MouseEvent.CLICK, clickWallBlockSeparate);
			wallBlockSeparate.addEventListener(MouseEvent.MOUSE_OVER, overWallBlockSeparate);
			wallBlockSeparate.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(wallBlockSeparate);
			
			wallBlockUnderSeparateConfirm.x = 328;
			wallBlockUnderSeparateConfirm.y = 480;
			wallBlockUnderSeparateConfirm.alpha = 0.5;
			wallBlockUnderSeparateConfirmBitmap = new Bitmap(BLOCK_BITMAPDATA[11]);
			wallBlockUnderSeparateConfirm.addChild(wallBlockUnderSeparateConfirmBitmap);
			addChild(wallBlockUnderSeparateConfirm);
			
			wallBlockSeparateConfirm.x = 328;
			wallBlockSeparateConfirm.y = 480;
			wallBlockSeparateConfirm.addChild(wallBlockSeparateConfirmBitmap = new Bitmap(new WALL_BLOCK_SEPARATE_CONFIRM().bitmapData));
			wallBlockSeparateConfirm.buttonMode = true;
			wallBlockSeparateConfirm.addEventListener(MouseEvent.CLICK, clickWallBlockSeparateConfirm);
			wallBlockSeparateConfirm.addEventListener(MouseEvent.MOUSE_OVER, overWallBlockSeparateConfirm);
			wallBlockSeparateConfirm.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(wallBlockSeparateConfirm);
			
			wallBlockUnderSeparateGarbage.x = 368;
			wallBlockUnderSeparateGarbage.y = 480;
			wallBlockUnderSeparateGarbageBitmap = new Bitmap(BLOCK_BITMAPDATA[11].clone());
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = .5;
			wallBlockUnderSeparateGarbageBitmap.bitmapData.colorTransform(new Rectangle(0, 0, 32, 32), ct);
			wallBlockUnderSeparateGarbageBitmap.bitmapData.copyPixels(
					WALL_BLOCK_SEPARATION_BITMAPDATA[0][0], new Rectangle(0, 0, 32, 32),
					new Point(0, 0), null, null, true);
			wallBlockUnderSeparateGarbage.addChild(wallBlockUnderSeparateGarbageBitmap);
			addChild(wallBlockUnderSeparateGarbage);
			
			wallBlockSeparateGarbage.x = 368;
			wallBlockSeparateGarbage.y = 480;
			wallBlockSeparateGarbage.addChild(wallBlockSeparateGarbageBitmap = new Bitmap(new WALL_BLOCK_SEPARATE_GARBAGE().bitmapData));
			wallBlockSeparateGarbage.buttonMode = true;
			wallBlockSeparateGarbage.addEventListener(MouseEvent.CLICK, clickWallBlockSeparateGarbage);
			wallBlockSeparateGarbage.addEventListener(MouseEvent.MOUSE_OVER, overWallBlockSeparateGarbage);
			wallBlockSeparateGarbage.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(wallBlockSeparateGarbage);
			
			blockConnection.x = 432;
			blockConnection.y = 480;
			blockConnection.addChild(blockConnectionBitmap = new Bitmap(new BLOCK_CONNECTION().bitmapData));
			blockConnection.buttonMode = true;
			blockConnection.addEventListener(MouseEvent.CLICK, clickBlockConnection);
			blockConnection.addEventListener(MouseEvent.MOUSE_OVER, overBlockConnection);
			blockConnection.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(blockConnection);
			
			blockConnectionGarbage.x = 472;
			blockConnectionGarbage.y = 480;
			blockConnectionGarbage.addChild(new Bitmap(new BLOCK_CONNECTION().bitmapData));
			blockConnectionGarbage.addChild(blockConnectionGarbageBitmap = new Bitmap(new BLOCK_CONNECTION_GARBAGE().bitmapData));
			blockConnectionGarbage.buttonMode = true;
			blockConnectionGarbage.addEventListener(MouseEvent.CLICK, clickBlockConnectionGarbage);
			blockConnectionGarbage.addEventListener(MouseEvent.MOUSE_OVER, overBlockConnectionGarbage);
			blockConnectionGarbage.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addChild(blockConnectionGarbage);
			
			
			var clickWallAttachmentButton:Array = [clickColourChanger, clickBomb, clickHinge, clickSpike, clickFreezer, clickDefroster];
			var overWallAttachmentButton:Array = [overColourChanger, overBomb, overHinge, overSpike, overFreezer, overDefroster];
			for (i = 0; i < clickWallAttachmentButton.length; i++) {
				wallAttachmentButtons[i] = new Sprite();
				wallAttachmentButtons[i].x = 16 + 56 * (i % 3);
				wallAttachmentButtons[i].y = 320 + 48 * Math.floor(i / 3);
				if (i == 0) {
					ccButtonBitmap = new Bitmap(WALL_ATTACHMENT_BUTTON_BITMAPDATA[0][0])
					wallAttachmentButtons[i].addChild(ccButtonBitmap);
				} else if (i == 3) {
					var bitmap:Bitmap = new Bitmap(WALL_ATTACHMENT_BUTTON_BITMAPDATA[i]);
					bitmap.x = -4;
					bitmap.y = -4;
					wallAttachmentButtons[i].addChild(bitmap);
				} else 
					wallAttachmentButtons[i].addChild(new Bitmap(WALL_ATTACHMENT_BUTTON_BITMAPDATA[i]));
				wallAttachmentButtons[i].buttonMode = true;
				wallAttachmentButtons[i].addEventListener(MouseEvent.CLICK, clickWallAttachmentButton[i]);
				wallAttachmentButtons[i].addEventListener(MouseEvent.MOUSE_OVER, overWallAttachmentButton[i]);
				wallAttachmentButtons[i].addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				addChild(wallAttachmentButtons[i]);
			}
			
			var clickWallAttachment:Array = [clickUpWallAttachment, clickLeftWallAttachment, clickRightWallAttachment, clickDownWallAttachment];
			var overWallAttachment:Array = [overUpWallAttachment, overLeftWallAttachment, overRightWallAttachment, overDownWallAttachment];
			for (i = 0; i < 4; i++) {
				wallAttachments[i] = new Sprite();
				wallAttachments[i].x = 16 + 32 * int(i == 0 || i == 3) + 64 * int(i == 2);
				wallAttachments[i].y = 432 + 32 * int(i == 1 || i == 2) + 64 * int(i == 3);
				wallAttachments[i].addChild(new Bitmap(WALL_BITMAPDATA));
				wallAttachments[i].addChild(wallAttachmentBitmaps[i] = new Bitmap(WALL_ATTACHMENT_BITMAPDATA[0][0][0][i]));
				wallAttachments[i].buttonMode = true;
				wallAttachments[i].addEventListener(MouseEvent.CLICK, clickWallAttachment[i]);
				wallAttachments[i].addEventListener(MouseEvent.MOUSE_OVER, overWallAttachment[i]);
				wallAttachments[i].addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				addChild(wallAttachments[i]);
			}
			var clickForceField:Array = [clickUpForceField, clickLeftForceField, clickRightForceField, clickDownForceField];
			var overForceField:Array = [overUpForceField, overLeftForceField, overRightForceField, overDownForceField];
			for (i = 0; i < 4; i++) {
				forceFields[i] = new Sprite();
				forceFields[i].x = 20 + 24 * int(i == 0 || i == 3) + 48 * int(i == 2);
				forceFields[i].y = 204 + 24 * int(i == 1 || i == 2) + 48 * int(i == 3);
				forceFields[i].addChild(forceFieldBitmaps[i] = new Bitmap(FORCE_FIELD_BITMAPDATA[0][i]));
				forceFields[i].buttonMode = true;
				forceFields[i].addEventListener(MouseEvent.CLICK, clickForceField[i]);
				forceFields[i].addEventListener(MouseEvent.MOUSE_OVER, overForceField[i]);
				forceFields[i].addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				addChild(forceFields[i]);
			}
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.size = 12;
			
			gravityChangersText = new TextField();
			gravityChangersText.x = 528;
			gravityChangersText.y = 472;
			gravityChangersText.defaultTextFormat = format;
			gravityChangersText.text = "Gravity changers";
			gravityChangersText.width = 104;
			gravityChangersText.selectable = false;
			addChild(gravityChangersText);
			upCheckBox = new CheckBox(this, 575, 501, "", updateGravity);
			upCheckBox.setSize(16, 16);
			leftCheckBox = new CheckBox(this, 563, 513, "", updateGravity);
			leftCheckBox.setSize(16, 16);
			rightCheckBox = new CheckBox(this, 587, 513, "", updateGravity);
			rightCheckBox.setSize(16, 16);
			downCheckBox = new CheckBox(this, 575, 525, "", updateGravity);
			downCheckBox.setSize(16, 16);
			startGravityText = new TextField();
			startGravityText.x = 528;
			startGravityText.y = 558;
			startGravityText.defaultTextFormat = format;
			startGravityText.text = "Start gravity";
			startGravityText.width = 104;
			startGravityText.selectable = false;
			addChild(startGravityText);
			
			selectText = new TextField();
			selectText.x = 11;
			selectText.y = 11;
			selectText.wordWrap = true;
			selectText.defaultTextFormat = format;
			selectText.width = 121;
			selectText.height = 34;
			selectText.selectable = false;
			addChild(selectText);
			
			toolTip = new TextField();
			toolTip.x = 136;
			toolTip.y = 526;
			toolTip.defaultTextFormat = format;
			toolTip.width = 376;
			toolTip.height = 20;
			toolTip.selectable = false;
			toolTip.text = "";
			addChild(toolTip);
			
			upStartGravity = new RadioButton(this, 575, 589, "", false, updateGravity);
			leftStartGravity = new RadioButton(this, 563, 601, "", false, updateGravity);
			rightStartGravity = new RadioButton(this, 587, 601, "", false, updateGravity);
			downStartGravity = new RadioButton(this, 575, 613, "", true, updateGravity);
			
			for (var k:int = 1; k < dataMap[0].length; k++) {
				if (dataMap[0][k][0] == 1) {
					var checkBoxes:Array = [upCheckBox, leftCheckBox, rightCheckBox, downCheckBox];
					var radioButtons:Array = [upStartGravity, leftStartGravity, rightStartGravity, downStartGravity];
					for (var h:int = 0; h < 4; h++) {
						if (dataMap[0][k][1] & (1 << h))
							radioButtons[h].selected = true;
						if (dataMap[0][k][2] & (1 << h))
							checkBoxes[h].selected = true;
					}
				} else if (dataMap[0][k][0] == 5) {
					connections = dataMap[0][k];
				}
			}
			
			if (connections != null) {
				for (k = 1; k < connections.length; k++) {
					var bl1:Point = new Point(connections[k][0], connections[k][1]);
					var bl2:Point = new Point(connections[k][2], connections[k][3]);
					var d1:Point = J.getDirectionFromIndex(connections[k][4]);
					var d2:Point = J.getDirectionFromIndex(connections[k][5]);
					var connect:Connection = new Connection(bl1, bl2, d1, d2);
					connectionsSprite.addChild(connect);
					connectionSprites.push(connect);
				}
				
			}
			
			for (k = 0; k < 10; k++) {
				shapeSteppersUnderColour[k] = new Bitmap(COLOUR_BITMAPDATA[k + 1]);
				shapeSteppersUnderColour[k].x = 192 + 64 * (k % 5);
				shapeSteppersUnderColour[k].y = 563 + 32 * Math.floor(k / 5);
				shapeSteppersUnderColour[k].width = 56;
				shapeSteppersUnderColour[k].height = 26;
				shapeSteppers[k] = new NumericStepper(null, 197 + 64 * (k % 5), 568 + 32 * Math.floor(k / 5), changeShapeCount);
				shapeSteppers[k].minimum = 0;
				shapeSteppers[k].maximum = 10;
				shapeSteppers[k].width = 46;
				shapeSteppers[k].value = 8;
			}
			shapeEnabler = new CheckBox(this, 75, 619, "Enable shape count", enableShapes);
			for (k = 1; k < dataMap[0].length; k++) {
				if (dataMap[0][k] is Array && dataMap[0][k][0] == 3)
					shapeEnabler.selected = true;
			}
			enableShapes(null);
			
			moveCountStepper = new NumericStepper(null, 120, 232, changeMoveCount);
			moveCountStepper.minimum = 1;
			moveCountStepper.maximum = 9;
			moveCountStepper.width = 48;
			moveCountStepper.value = 1;
			addChild(moveCountStepper);
			
			addChild(boundarySprite);
			boundaryProgressSprite.alpha = 0.8;
			addChild(boundaryProgressSprite);
			addChild(selectionSprite);
			selectionProgressSprite.alpha = 0.8;
			addChild(selectionProgressSprite);
			
			
			
			for (var Z:int = 0; Z < J.LAYER_AMOUNT; Z++) {
				displayLayers[Z] = new Sprite();
				addChild(displayLayers[Z]);
			}
			addChild(connectionsSprite)
			connectionProgressSprite.alpha = 0.8;
			addChild(connectionProgressSprite);
			
			for (k = 1; k < dataMap[0].length; k++) {
				if (dataMap[0][k][0] == 4) { // wall block separation
					for (l = 1; l < dataMap[0][k].length; l++) {
						if (dataMap[0][k][l] is Array)
							pasteWallBlockSeparation(dataMap[0][k][l]);
					}
					break;
				}
			}
			
			for (k = 1; k < dataMap[0].length; k++) {
				if (dataMap[0][k][0] == 6) { // boundary wall attachments
					for (l = 1; l < dataMap[0][k].length; l++)
						addAttachments(dataMap[0][k][l][0], dataMap[0][k][l][1], [dataMap[0][k][l][2]], true);
					break;
				}
			}
			
			for each (var obj:Array in dataMap) {
				if (obj[0] == 1) {
					var newBlock:Bitmap;
					if (obj[4] == 1)
						newBlock = new Bitmap(IMMOBILE_BLOCK_BITMAPDATA[obj[3]]);
					else
						newBlock = new Bitmap(BLOCK_BITMAPDATA[obj[3]]);
					newBlock.x = 184 + 32 * obj[1];
					newBlock.y = 8 + 32 * obj[2];
					displayMap[obj[1]][obj[2]][J.BLOCK_LAYER].push(newBlock);
					displayLayers[J.BLOCK_LAYER].addChild(newBlock);
					if (obj[3] == 11) {
						for (h = 4; h < obj.length; h++) {
							if (obj[h] is Array && obj[h][0] == 0) {
								var att:Array = obj[h].concat();
								att.shift();
								addAttachments(obj[1], obj[2], att);
								break;
							}
						}
					}
					if (obj[4] == 2) {
						var lock:Bitmap = new Bitmap(lockedBitmap.bitmapData);
						lock.x = 184 + 32 * obj[1];
						lock.y = 8 + 32 * obj[2];
						displayMap[obj[1]][obj[2]][J.BLOCK_LAYER].push(lock);
						displayLayers[J.BLOCK_LAYER].addChild(lock);
					} else if (!(obj[4] is Array) && obj[4] != undefined && obj[4] > 2) {
						var number:Bitmap = new Bitmap(MOVE_COUNT_BITMAPDATA[obj[3]][obj[4] - 3]);
						number.x = 184 + 32 * obj[1];
						number.y = 8 + 32 * obj[2];
						displayMap[obj[1]][obj[2]][J.BLOCK_LAYER].push(number);
						displayLayers[J.BLOCK_LAYER].addChild(number);
					}
				} else if (obj[0] == 2) {
					var newWall:Bitmap = new Bitmap(WALL_BITMAPDATA);
					newWall.x = 184 + 32 * obj[1];
					newWall.y = 8 + 32 * obj[2];
					displayMap[obj[1]][obj[2]][J.WALL_LAYER].push(newWall);
					displayLayers[J.WALL_LAYER].addChild(newWall);
					for (h = 3; h < obj.length; h++) {
						if (obj[h] is Array && obj[h][0] == 0) {
							att = obj[h].concat();
							att.shift();
							addAttachments(obj[1], obj[2], att);
							break;
						}
					}
				} else if (obj[0] == 3) {
					for (var g:int = 0; g < 4; g++) {
						if (obj[3+g] != -1) {
							var ff:Bitmap = new Bitmap(FORCE_FIELD_PASTE_BITMAPDATA[obj[3+g]][g]);
							ff.x = 184 + 32 * obj[1];
							ff.y = 8 + 32 * obj[2];
							displayMap[obj[1]][obj[2]][J.FORCE_FIELD_LAYER].push(ff);
							displayLayers[J.FORCE_FIELD_LAYER].addChild(ff);
						}
					}
				}
			}
			
			var defined:Boolean = false;
			for (var l:int = 1; l < dataMap[0].length; l++) {
				if (dataMap[0][l][0] == 2) {
					minX = dataMap[0][l][1];
					maxX = dataMap[0][l][3] + minX - 1;
					minY = dataMap[0][l][2];
					maxY = dataMap[0][l][4] + minY - 1;
					defined = true;
				}
			}
			if (!defined)
				defineBoundary();
			if (!(minX == 13 && maxX == 0 && minY == 13 && maxY == 0))
				updateBoundary();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		override public function startUp(e:Event):void {
			super.startUp(e);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		override public function everyFrame(e:Event):void {
			if (down) {
				if (selectionType == -6 || selectionType == -7)
					down = false;
				placeItems();
			}
			selectionBitmap.x = mouseX - 16;
			selectionBitmap.y = mouseY - 16;
			boundaryProgressSprite.graphics.clear();
			if (firstPoint != null && secondPoint == null) {
				boundaryProgressSprite.graphics.lineStyle(1, 0xf60000, 0.8);
				boundaryProgressSprite.graphics.drawRect(Math.min(firstPoint.x, mouseX), Math.min(firstPoint.y, mouseY),
						Math.abs(firstPoint.x - mouseX), Math.abs(firstPoint.y - mouseY));
			}
			connectionProgressSprite.graphics.clear();
			if (firstBlock != null && secondBlock == null) {
				if (selectionType == -7) {
					firstDirection = new Point();
					secondDirection = new Point();
				}
				var fromX:int = 184 + firstBlock.x * 32 + 16 + 10 * firstDirection.x;
				var fromY:int = 8 + firstBlock.y * 32 + 16 + 10 * firstDirection.y;
				var toX:int = Math.min(Math.max(mouseX, 184), 632);
				var toY:int = Math.min(Math.max(mouseY, 8), 456);
				if (selectionType == -6)
					connectionProgressSprite.graphics.lineStyle(1, 0x800080, 0.8);
				else if (selectionType == -7)
					connectionProgressSprite.graphics.lineStyle(4, 0xe33434, 1);
				connectionProgressSprite.graphics.moveTo(fromX, fromY);
				connectionProgressSprite.graphics.lineTo(toX, toY);
			}
			
			selectionProgressSprite.graphics.clear();
			if (firstSelectionPoint != null && secondSelectionPoint == null && !selected) {
				selectionProgressSprite.graphics.lineStyle(1, 0x00f600, 0.8);
				var rectX:int = Math.min(firstSelectionPoint.x, mouseX);
				var rectY:int = Math.min(firstSelectionPoint.y, mouseY);
				var rectW:int = Math.abs(firstSelectionPoint.x - mouseX);
				var rectH:int = Math.abs(firstSelectionPoint.y - mouseY);
				if (rectX < 183) {
					rectW -= (183 - rectX);
					rectX = 183;
				}
				if (rectX + rectW > 632)
					rectW -= (rectX + rectW - 632);
				if (rectY < 7) {
					rectH -= (7 - rectY);
					rectY = 7;
				}
				if (rectY + rectH > 456)
					rectH -= (rectY + rectH - 456);
				selectionProgressSprite.graphics.drawRect(rectX, rectY, rectW, rectH);
			} else if (selected && firstMovePoint != null) {
				var gridX:int = Math.round((mouseX - firstMovePoint.x) / 32);
				var gridY:int = Math.round((mouseY - firstMovePoint.y) / 32);
				if (-sminX > gridX)
					gridX += (-sminX -gridX);
				if (gridX > (13 - smaxX))
					gridX -= (gridX - (13 - smaxX));
				if ( -sminY > gridY)
					gridY += (-sminY -gridY);
				if (gridY > (13 - smaxY))
					gridY -= (gridY - (13 - smaxY));	
				selectionSprite.x = gridX * 32;
				selectionSprite.y = gridY * 32;
				
				for (var X:int = 0; X <= smaxX - sminX; X++) {
					for (var Y:int = 0; Y <= smaxY - sminY; Y++) {
						for (var Z:int = 0; Z < J.LAYER_AMOUNT; Z++) {
							for (var k:int = 0; k < selectedBitmaps[X][Y][Z].length; k++) {
								selectedBitmaps[X][Y][Z][k].x += (gridX - transferX) * 32;
								selectedBitmaps[X][Y][Z][k].y += (gridY - transferY) * 32;
							}
						}
					}
				}
				transferX = gridX;
				transferY = gridY;
				for each (var selectConnect:Connection in selectedConnectionSprites)
					selectConnect.interDraw(transferX, transferY, sminX, smaxX, sminY, smaxY);
			}
		}
		
		override public function terminate():void {
			super.terminate();
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
		
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addAttachments(X:int, Y:int, data:Array, boundary:Boolean = false):void {
			for (var i:int = 0; i < data.length; i++) {
				var attachment:Bitmap = null;
				var bit:BitmapData = null;
				if (data[i][0] == 1) // colour changer
					bit = WALL_ATTACHMENT_BITMAPDATA[0][data[i][3]][0][J.getIndexFrom(data[i][1], data[i][2])];
				else if (data[i][0] == 2) // bomb
					bit = WALL_ATTACHMENT_BITMAPDATA[1][J.getIndexFrom(data[i][1], data[i][2])];
				else if (data[i][0] == 3) // hinge
					bit = WALL_ATTACHMENT_BITMAPDATA[2][J.getIndexFrom(data[i][1], data[i][2])];
				else if (data[i][0] == 4) // spike
					bit = WALL_ATTACHMENT_BITMAPDATA[3][J.getIndexFrom(data[i][1], data[i][2])];
				else if (data[i][0] == 5) // freezer
					bit = WALL_ATTACHMENT_BITMAPDATA[4][J.getIndexFrom(data[i][1], data[i][2])];
				else if (data[i][0] == 6) // defroster
					bit = WALL_ATTACHMENT_BITMAPDATA[5][J.getIndexFrom(data[i][1], data[i][2])];
					
				if (boundary) {
					attachment = new BoundaryBitmap(X, Y, bit);
					boundaryWalls.push(attachment);
				} else
					attachment = new Bitmap(bit);
					
				if (bit != null) {
					attachment.x = 184 + 32 * X;
					attachment.y = 8 + 32 * Y;
					if (data[i][0] == 4) { // spike
						attachment.x -= 4;
						attachment.y -= 4;
					}
					if (!boundary)
						displayMap[X][Y][J.WALL_ATTACHMENT_LAYER].push(attachment);
					displayLayers[J.WALL_ATTACHMENT_LAYER].addChild(attachment);
				}
			}
		}
		
		private function updateGravity(e:MouseEvent):void {
			var gravitySwitches:int = int(upCheckBox.selected) + 2 * int(leftCheckBox.selected) +
					4 * int(rightCheckBox.selected) + 8 * int(downCheckBox.selected);
			var startGravity:int = int(upStartGravity.selected) + 2 * int(leftStartGravity.selected) +
					4 * int(rightStartGravity.selected) + 8 * int(downStartGravity.selected);
			var updated:Boolean = false;
			for (var i:int = 1; i < dataMap[0].length; i++) {
				if (dataMap[0][i][0] == 1) {
					dataMap[0][i] = [1, startGravity, gravitySwitches];
					updated = true;
				}
			}
			if (!updated)
				dataMap[0].push([1, startGravity, gravitySwitches]);
		}
		
		private function defineBoundary():void {
			minX = 13, maxX = 0, minY = 13, maxY = 0;
			for (var i:int = 1; i < dataMap.length; i++) {
				if (dataMap[i][1] < minX)
					minX = dataMap[i][1];
				if (dataMap[i][1] > maxX)
					maxX = dataMap[i][1];
				if (dataMap[i][2] < minY)
					minY = dataMap[i][2];
				if (dataMap[i][2] > maxY)
					maxY = dataMap[i][2];
			}
		}
		
		private function hasConnections(X:int , Y:int):Boolean {
			if (connections == null)
				return false;
			for (var i:int = 1; i < connections.length; i++) {
				if (Connection.hasBlockInConnectionArray(X, Y, connections[i]))
					return true;
			}
			return false;
		}
		
		private var
			movesCountColour:int,
			connections:Array;
		private function placeItems():void {
			var inside:Boolean = 184 + 32 * minX <= mouseX && mouseX < 184 + 32 * (maxX + 1) && 8 + 32 * minY <= mouseY && mouseY < 8 + 32 * (maxY + 1);
			var inGrid:Boolean = mouseX >= 184 && mouseX < 632 && mouseY >= 8 && mouseY < 456;
			var outside:Boolean =  isWallAttachment(selectionType) && !inside && (168 + 32 * minX <= mouseX && mouseX < 168 + 32 * (maxX + 2) && 32 * minY <= mouseY && mouseY < 24 + 32 * (maxY + 1));
			if (inGrid || outside) {
				var X:int = Math.floor((mouseX - 184) / 32.0);
				var Y:int = Math.floor((mouseY - 8) / 32.0);
				var canBePlaced:Boolean = true;
				var layer:int = J.WALL_LAYER;
				if (selectionType == -7) {
					canBePlaced = false;
					var found:Boolean = false;
					for each (arr in dataMap) {
						if (arr[0] == 1 && arr[1] == X && arr[2] == Y) {
							found = true;
							break;
						}
					}
					if (found) {
						if (firstBlock == null) {
							if (hasConnections(X, Y)) {
								setTooltip("Click a second block to remove the fixed link. Click the first block to undo.");
								firstBlock = new Point(X, Y);
							}
						} else {
							if (X != firstBlock.x || Y != firstBlock.y) {
								if (hasConnections(X, Y)) {
									secondBlock = new Point(X, Y);
									if (connections != null) {
										for (var q:int = connections.length - 1; q > 0; q--) {
											if (Connection.isConnectionArray(firstBlock, secondBlock, connections[q])) {
												for (var v:int = connectionSprites.length - 1; v >= 0; v--) {
													if (connectionSprites[v].isConnectionBetween(firstBlock, secondBlock)) {
														connectionsSprite.removeChild(connectionSprites[v]);
														connectionSprites[v] = null;
														connectionSprites.splice(v, 1);
														break;
													}
												}
												connections.splice(q, 1);
												break;
											}
										}
									}
									firstBlock = null;
									secondBlock = null;
									setTooltip("Click a block or wall block you want to remove a fixed link from.");
								}
							} else {
								firstBlock = null;
								secondBlock = null;
								setTooltip("Click a block or wall block you want to remove a fixed link from.");
							}
						}
					}
				} else if (selectionType == -6) {
					canBePlaced = false;
					found = false;
					for each (arr in dataMap) {
						if (arr[0] == 1 && arr[1] == X && arr[2] == Y) {
							found = true;
							break;
						}
					}
					if (found) {
						if (firstBlock == null) {
							// check that first block has got too many connections
							var amountOfConnections:int = 0;
							if (connections != null) {
								for (var s:int = 1; s < connections.length; s++) {
									if (X == connections[s][0] && Y == connections[s][1])
										amountOfConnections++;
									else if (X == connections[s][2] && Y == connections[s][3])
										amountOfConnections++;
									if (amountOfConnections >= 4)
										break;
								}
							}
							if (amountOfConnections < 4) {
								var relXPos:int = (mouseX - 184) % 32;
								var relYPos:int = (mouseY - 8) % 32;
								if (relYPos > relXPos) {
									if (32 - relXPos > relYPos)
										firstDirection = new Point(-1, 0);
									else
										firstDirection = new Point(0, 1);
								} else {
									if (32 - relXPos > relYPos)
										firstDirection = new Point(0, -1);
									else
										firstDirection = new Point(1, 0);
								}
								firstBlock = new Point(X, Y);
								setTooltip("Click a second block to establish a fixed link. Click the first block to undo.");
							}
						} else {
							if (firstBlock.x != X || firstBlock.y != Y) {
								// check that second block has got too many connections
								relXPos = (mouseX - 184) % 32;
								relYPos = (mouseY - 8) % 32;
								if (relYPos > relXPos) {
									if (32 - relXPos > relYPos)
										secondDirection = new Point(-1, 0);
									else
										secondDirection = new Point(0, 1);
								} else {
									if (32 - relXPos > relYPos)
										secondDirection = new Point(0, -1);
									else
										secondDirection = new Point(1, 0);
								}
								amountOfConnections = 0;
								if (connections != null) {
									for (s = 1; s < connections.length; s++) {
										if (X == connections[s][0] && Y == connections[s][1]) {
											amountOfConnections++;
											if (connections[s][4] == J.getIndexFrom(secondDirection.x, secondDirection.y))
												amountOfConnections += 4;
										}
										else if (X == connections[s][2] && Y == connections[s][3]) {
											amountOfConnections++;
											if (connections[s][5] == J.getIndexFrom(secondDirection.x, secondDirection.y))
												amountOfConnections += 4;
										}
										if (amountOfConnections >= 4)
											break;
									}
								}
								if (amountOfConnections < 4)
									secondBlock = new Point(X, Y) 
							} else {
								firstBlock = null;
								secondBlock = null;
								setTooltip("Click a block or wall block on one of the four sides to add a fixed link to it.");
							}
						}
					}
					if (secondBlock != null) {
						if (connections == null) {
							for each (var obj:Array in dataMap) {
								if (obj[0] == 0) {
									for (var r:int = 1; r < obj.length; r++) {
										if (obj[r][0] == 5) {
											connections = obj[r];
											break;
										}
									}
									break;
								}
							}
						}
						var firstDirIndex:int = J.getIndexFrom(firstDirection.x, firstDirection.y);
						var secondDirIndex:int = J.getIndexFrom(secondDirection.x, secondDirection.y);
						if (connections == null) {
							connections = [5, [firstBlock.x, firstBlock.y, secondBlock.x, secondBlock.y, firstDirIndex, secondDirIndex]];
							obj.push(connections);
						} else {
							var alreadyHaveThatConnection:Boolean = false;
							for (var f:int = 1; f < connections.length; f++) {
								if ((connections[f][0] == firstBlock.x && connections[f][1] == firstBlock.y &&
										connections[f][2] == secondBlock.x && connections[f][3] == secondBlock.y) ||
										(connections[f][0] == secondBlock.x && connections[f][1] == secondBlock.y &&
										connections[f][2] == firstBlock.x && connections[f][3] == firstBlock.y)) {
									alreadyHaveThatConnection = true;
								}
							}
							if (alreadyHaveThatConnection)
								secondBlock = null;
							else
								connections.push([firstBlock.x, firstBlock.y, secondBlock.x, secondBlock.y, firstDirIndex, secondDirIndex]);
						}
						if (secondBlock != null) {
							var connect:Connection = new Connection(firstBlock, secondBlock, firstDirection, secondDirection);
							connectionsSprite.addChild(connect);
							connectionSprites.push(connect);
							firstBlock = null;
							secondBlock = null;
							setTooltip("Click a block or wall block on one of the four sides to add a fixed link to it.");
						}
					}
				} else if (selectionType == -5) {
					canBePlaced = false;
					for (var h:int = 0; h < wallBlockSeparationCoordinates.length; h++) {
						if (wallBlockSeparationCoordinates[h][0] == X && wallBlockSeparationCoordinates[h][1] == Y) {
							wallBlockSeparationCoordinates.splice(h, 1);
							for each (var bit:Bitmap in displayMap[X][Y][J.WALL_BLOCK_SEPARATION])
								displayLayers[J.WALL_BLOCK_SEPARATION].removeChild(bit);
							displayMap[X][Y][J.WALL_BLOCK_SEPARATION] = [];
							break;
						}
					}
				} else if (selectionType == -4) {
					layer = J.WALL_BLOCK_SEPARATION;
					canBePlaced = (displayMap[X][Y][layer].length == 0);
					if (canBePlaced) {
						canBePlaced = false;
						for each (arr in dataMap) {
							if (arr[1] == X && arr[2] == Y && arr[0] == 1) {
								if (arr[3] == 11) {
									wallBlockSeparationCoordinates.push([X, Y]);
									canBePlaced = true;
								}
								break;
							}
						}
					}
				} else if (selectionType == -3) {
					if (selectedCell == null) {
						canBePlaced = false;
						var succeeded:Boolean = prepareSelectedCell(X, Y);
						if (succeeded) {
							var bitmapData:BitmapData = new BitmapData(40, 40, true, 0);
							for (var Z:int = 0; Z < J.LAYER_AMOUNT; Z++) {
								if (Z == J.WALL_BLOCK_SEPARATION)
									continue;
								for (var A:int = 0; A < displayMap[X][Y][Z].length; A++) {
									var xShift:int = ((displayMap[X][Y][Z][A].x - 184) % 32 == 0) ? 4 : 0;
									var yShift:int = ((displayMap[X][Y][Z][A].x - 8) % 32 == 0) ? 4 : 0;
									bitmapData.copyPixels(displayMap[X][Y][Z][A].bitmapData,
										displayMap[X][Y][Z][A].bitmapData.rect, new Point(xShift, yShift),
										null, null, true);
								}
							}
							setTooltip("Click a tile to place the copied tile.");
							clickItem( -3, bitmapData);
						} else
							selectedCell = null;
					} else {
						for each (obj in dataMap) {
							if (obj[0] != 0) {
								if (obj[1] == X && obj[2] == Y) {
									canBePlaced = false;
									break;
								}
							}
						}
						if (canBePlaced) {
							var newData:Array = copySelectedCell(X, Y);
							dataMap = dataMap.concat(newData);
						}
					}
				} else if (selectionType == -2 && firstPoint == null) {
					canBePlaced = false;
					firstPoint = new Point(mouseX, mouseY);
				} else if (selectionType == -1) {
					canBePlaced = false;
					for each (obj in dataMap) {
						if (obj[0] != 0) {
							if (obj[1] == X && obj[2] == Y)
								obj[0] = -1;
						} else {
							found = false;
							for (var m:int = 1; m < obj.length; m++) {
								var arr:Array = obj[m];
								if (arr[0] == 4) {
									for (var p:int = arr.length - 1; p > 0; p--) {
										var orr:Array = arr[p];
										for (var n:int = 0; n < orr.length; n++) {
											if (orr[n][0] == X && orr[n][1] == Y) {
												found = true;
												orr.splice(n, 1);
												pasteWallBlockSeparation(orr);
												break;
											}
										}
										if (orr.length == 0)
											arr.splice(p, 1);
										if (found)
											break;
									}
									break;
								}
							}
						}
					}
					for (var i:int = dataMap.length - 1; i >= 0; i--) {
						if (dataMap[i][0] == -1)
							dataMap.splice(i, 1);
					}
					for (Z = 0; Z < J.LAYER_AMOUNT; Z++) {
						for each (bit in displayMap[X][Y][Z])
							displayLayers[Z].removeChild(bit);
						displayMap[X][Y][Z] = [];
					}
					if (connections != null) {
						for (var t:int = connections.length - 1; t > 0; t--) {
							if (Connection.hasBlockInConnectionArray(X, Y, connections[t]))
								connections.splice(t, 1);
						}
					}
					for (t = connectionSprites.length - 1; t >= 0; t--) {
						if (connectionSprites[t].hasBlock(X, Y)) {
							connectionsSprite.removeChild(connectionSprites[t]);
							connectionSprites[t] = null;
							connectionSprites.splice(t, 1);
						}
					}
					for (t = 0; t < dataMap.length; t++) {
						if (dataMap[t][0] == 0) {
							for (s = 1; s < dataMap[t].length; s++) {
								if (dataMap[t][s][0] == 6) {
									for (var u:int = 1; u < dataMap[t][s].length; u++) {
										if (dataMap[t][s][u][0] == X && dataMap[t][s][u][1] == Y) {
											dataMap[t][s].splice(u, 1);
											for (v = boundaryWalls.length - 1; v >= 0; v--) {
												if (boundaryWalls[v] is BoundaryBitmap) {
													var bbit:BoundaryBitmap = (boundaryWalls[v] as BoundaryBitmap);
													if (bbit.X == X && bbit.Y == Y) {
														boundaryWalls.splice(v, 1);
														displayLayers[J.WALL_ATTACHMENT_LAYER].removeChild(bbit);
													}
												}
											}
											break;
										}
									}
									break;
								}
							}
							break;
						}
					}
					//for (t = 0; t < dataMap.length; t++) {
						//if (dataMap[t][0] == 0) {
							//for (s = 1; s < dataMap[t].length; s++) {
								//if (dataMap[t][s][0] == 6) {
									//dataMap[t].splice(s, 1);
									//break;
								//}
							//}
							//break;
						//}
					//}
				} else if (selectionType == 0 && firstSelectionPoint == null && !selected) {
					canBePlaced = false;
					firstSelectionPoint = new Point(mouseX, mouseY);
				} else if (selectionType == 1) {
					layer = J.BLOCK_LAYER;
					for each (arr in dataMap) {
						if (arr[1] == X && arr[2] == Y && (arr[0]==1 || arr[0]==2)) {
							canBePlaced = false;
							break;
						}
					}
					if (canBePlaced)
						dataMap.push([1, X, Y, colour]);
				} else if (selectionType == 2) {
					layer = J.WALL_LAYER;
					for each (arr in dataMap) {
						if (arr[1] == X && arr[2] == Y && (arr[0]==1 || arr[0]==2)) {
							canBePlaced = false;
							break;
						}
					}
					if (canBePlaced)
						dataMap.push([2, X, Y]);
				} else if (selectionType == 3) {
					layer = J.BLOCK_LAYER;
					for each (arr in dataMap) {
						if (arr[1] == X && arr[2] == Y && (arr[0]==1 || arr[0]==2)) {
							canBePlaced = false;
							break;
						}
					}
					if (canBePlaced)
						dataMap.push([1, X, Y, colour, 1]);
				} else if (selectionType == 4) {
					layer = J.BLOCK_LAYER;
					for each (arr in dataMap) {
						if (arr[1] == X && arr[2] == Y && (arr[0]==1 || arr[0]==2)) {
							canBePlaced = false;
							break;
						}
					}
					if (canBePlaced)
						dataMap.push([1, X, Y, 11]);
				} else if (selectionType == 5) {
					layer = J.BLOCK_LAYER;
					for each (arr in dataMap) {
						if (arr[1] == X && arr[2] == Y && (arr[0]==1 || arr[0]==2)) {
							canBePlaced = false;
							break;
						}
					}
					if (canBePlaced)
						dataMap.push([1, X, Y, 11, 1]);
				} else if (selectionType == 6 || selectionType == 7 || selectionType == 8 || selectionType == 9) {
					layer = J.WALL_ATTACHMENT_LAYER;
					xDir = int(selectionType == 8) - int(selectionType == 7);
					yDir = int(selectionType == 9) - int(selectionType == 6);
					if (outside)
						canBePlaced = placeWallAttachmentOutsideGrid(X, Y, [1, xDir, yDir, colour]);
					else {
						canBePlaced = false;
						for each (arr in dataMap) {
							if (arr[1] == X && arr[2] == Y) {
								if (arr[0] == 2 || (arr[0] == 1 && arr[3] == 11)) {
									canBePlaced = true;
									var hasAttachments:Boolean = false;
									var attachmentIndex:int = 0;
									for (var k:int = 3; k < arr.length; k++) {
										if (arr[k] is Array && arr[k][0] == 0) {
											hasAttachments = true;
											attachmentIndex = k;
											for (var l:int = 1; l < arr[k].length; l++) {
												if (arr[k][l][1] == xDir && arr[k][l][2] == yDir) {
													canBePlaced = false;
													break;
												}
											}
										}
									}
									if (canBePlaced) {
										if (hasAttachments)
											arr[attachmentIndex].push([1, xDir, yDir, colour]);
										else
											arr.push([0, [1, xDir, yDir, colour]]);
									}
								}
								break;
							}
						}
					}
				} else if (selectionType == 10 || selectionType == 11 || selectionType == 12 || selectionType == 13) {
					layer = J.WALL_ATTACHMENT_LAYER;
					var xDir:int = int(selectionType == 12) - int(selectionType == 11);
					var yDir:int = int(selectionType == 13) - int(selectionType == 10);
					if (outside)
						canBePlaced = placeWallAttachmentOutsideGrid(X, Y, [2, xDir, yDir]);
					else {
						canBePlaced = false;
						for each (arr in dataMap) {
							if (arr[1] == X && arr[2] == Y) {
								if (arr[0] == 2 || (arr[0] == 1 && arr[3] == 11)) {
									canBePlaced = true;
									hasAttachments = false;
									attachmentIndex = 0;
									for (k = 3; k < arr.length; k++) {
										if (arr[k] is Array && arr[k][0] == 0) {
											hasAttachments = true;
											attachmentIndex = k;
											for (l = 1; l < arr[k].length; l++) {
												if (arr[k][l][1] == xDir && arr[k][l][2] == yDir) {
													canBePlaced = false;
													break;
												}
											}
										}
									}
									if (canBePlaced) {
										if (hasAttachments)
											arr[attachmentIndex].push([2, xDir, yDir]);
										else
											arr.push([0, [2, xDir, yDir]]);
									}
								}
								break;
							}
						}
					}
				} else if (selectionType == 14 || selectionType == 15 || selectionType == 16 || selectionType == 17) {
					layer = J.FORCE_FIELD_LAYER;
					xDir = int(selectionType == 16) - int(selectionType == 15) 
					yDir = int(selectionType == 17) - int(selectionType == 14) 
					canBePlaced = true;
					var hasAlreadyForceField:Boolean = false;
					var index:int = 3 + J.getIndexFrom(xDir, yDir);
					for each (arr in dataMap) {
						if (arr[1] == X && arr[2] == Y) {
							if (arr[0] == 3) {
								hasAlreadyForceField = true;
								if (arr[index] != -1) {
									canBePlaced = false;
									break;
								}
								arr[index] = colour;
							}
						}
					}
					if (!hasAlreadyForceField) {
						var newArr:Array = [3, X, Y, -1, -1, -1, -1];
						newArr[index] = colour;
						dataMap.push(newArr);
					}
				} else if (selectionType == 18 || selectionType == 19 || selectionType == 20 || selectionType == 21) {
					layer = J.WALL_ATTACHMENT_LAYER;
					xDir = int(selectionType == 20) - int(selectionType == 19);
					yDir = int(selectionType == 21) - int(selectionType == 18);
					if (outside)
						canBePlaced = placeWallAttachmentOutsideGrid(X, Y, [3, xDir, yDir]);
					else {
						canBePlaced = false;
						for each (arr in dataMap) {
							if (arr[1] == X && arr[2] == Y) {
								if (arr[0] == 2 || (arr[0] == 1 && arr[3] == 11)) {
									canBePlaced = true;
									hasAttachments = false;
									attachmentIndex = 0;
									for (k = 3; k < arr.length; k++) {
										if (arr[k] is Array && arr[k][0] == 0) {
											hasAttachments = true;
											attachmentIndex = k;
											for (l = 1; l < arr[k].length; l++) {
												if (arr[k][l][1] == xDir && arr[k][l][2] == yDir) {
													canBePlaced = false;
													break;
												}
											}
										}
									}
									if (canBePlaced) {
										if (hasAttachments)
											arr[attachmentIndex].push([3, xDir, yDir]);
										else
											arr.push([0, [3, xDir, yDir]]);
									}
								}
								break;
							}
						}
					}
				} else if (selectionType == 22) {
					layer = J.BLOCK_LAYER;
					canBePlaced = false;
					for each (arr in dataMap) {
						if (arr[1] == X && arr[2] == Y && arr[0] == 1) {
							if (arr[4] is Array || arr[4] == undefined) {
								arr.splice(4, 0, 2);
								canBePlaced = true;
							}
							break;
						}
					}
				} else if (selectionType == 23 || selectionType == 24 || selectionType == 25 || selectionType == 26) {
					layer = J.WALL_ATTACHMENT_LAYER;
					xDir = int(selectionType == 25) - int(selectionType == 24);
					yDir = int(selectionType == 26) - int(selectionType == 23);
					if (outside)
						canBePlaced = placeWallAttachmentOutsideGrid(X, Y, [4, xDir, yDir]);
					else {
						canBePlaced = false;
						for each (arr in dataMap) {
							if (arr[1] == X && arr[2] == Y) {
								if (arr[0] == 2 || (arr[0] == 1 && arr[3] == 11)) {
									canBePlaced = true;
									hasAttachments = false;
									attachmentIndex = 0;
									for (k = 3; k < arr.length; k++) {
										if (arr[k] is Array && arr[k][0] == 0) {
											hasAttachments = true;
											attachmentIndex = k;
											for (l = 1; l < arr[k].length; l++) {
												if (arr[k][l][1] == xDir && arr[k][l][2] == yDir) {
													canBePlaced = false;
													break;
												}
											}
										}
									}
									if (canBePlaced) {
										if (hasAttachments)
											arr[attachmentIndex].push([4, xDir, yDir]);
										else
											arr.push([0, [4, xDir, yDir]]);
									}
								}
								break;
							}
						}
					}
				} else if (selectionType == 27 || selectionType == 28 || selectionType == 29 || selectionType == 30) {
					layer = J.WALL_ATTACHMENT_LAYER;
					xDir = int(selectionType == 29) - int(selectionType == 28);
					yDir = int(selectionType == 30) - int(selectionType == 27);
					if (outside)
						canBePlaced = placeWallAttachmentOutsideGrid(X, Y, [5, xDir, yDir]);
					else {
						canBePlaced = false;
						for each (arr in dataMap) {
							if (arr[1] == X && arr[2] == Y) {
								if (arr[0] == 2 || (arr[0] == 1 && arr[3] == 11)) {
									canBePlaced = true;
									hasAttachments = false;
									attachmentIndex = 0;
									for (k = 3; k < arr.length; k++) {
										if (arr[k] is Array && arr[k][0] == 0) {
											hasAttachments = true;
											attachmentIndex = k;
											for (l = 1; l < arr[k].length; l++) {
												if (arr[k][l][1] == xDir && arr[k][l][2] == yDir) {
													canBePlaced = false;
													break;
												}
											}
										}
									}
									if (canBePlaced) {
										if (hasAttachments)
											arr[attachmentIndex].push([5, xDir, yDir]);
										else
											arr.push([0, [5, xDir, yDir]]);
									}
								}
								break;
							}
						}
					}
				} else if (selectionType == 31 || selectionType == 32 || selectionType == 33 || selectionType == 34) {
					layer = J.WALL_ATTACHMENT_LAYER;
					xDir = int(selectionType == 33) - int(selectionType == 32);
					yDir = int(selectionType == 34) - int(selectionType == 31);
					if (outside)
						canBePlaced = placeWallAttachmentOutsideGrid(X, Y, [6, xDir, yDir]);
					else {
						canBePlaced = false;
						for each (arr in dataMap) {
							if (arr[1] == X && arr[2] == Y) {
								if (arr[0] == 2 || (arr[0] == 1 && arr[3] == 11)) {
									canBePlaced = true;
									hasAttachments = false;
									attachmentIndex = 0;
									for (k = 3; k < arr.length; k++) {
										if (arr[k] is Array && arr[k][0] == 0) {
											hasAttachments = true;
											attachmentIndex = k;
											for (l = 1; l < arr[k].length; l++) {
												if (arr[k][l][1] == xDir && arr[k][l][2] == yDir) {
													canBePlaced = false;
													break;
												}
											}
										}
									}
									if (canBePlaced) {
										if (hasAttachments)
											arr[attachmentIndex].push([6, xDir, yDir]);
										else
											arr.push([0, [6, xDir, yDir]]);
									}
								}
								break;
							}
						}
					}
				} else if (selectionType == 35 || selectionType == 36) {
					layer = J.BLOCK_LAYER;
					canBePlaced = false;
					for each (arr in dataMap) {
						if (arr[1] == X && arr[2] == Y && arr[0] == 1) {
							if (arr[4] is Array || arr[4] == undefined) {
								movesCountColour = arr[3];
								arr.splice(4, 0, moveCount + 2);
								canBePlaced = true;
							}
							break;
						}
					}
				} else
					canBePlaced = false;
				if (canBePlaced) {
					var boundaryChanged:Boolean = false;
					if (X < minX && !outside) { minX = X; boundaryChanged = true; }
					if (X > maxX && !outside) { maxX = X; boundaryChanged = true; }
					if (Y < minY && !outside) { minY = Y; boundaryChanged = true; }
					if (Y > maxY && !outside) { maxY = Y; boundaryChanged = true; }
					
					if (boundaryChanged && !outside)
						updateBoundary();
					if (selectionType == -3) {
						var diffX:int = X - selectX;
						var diffY:int = Y - selectY;
						for (Z = 0; Z < J.LAYER_AMOUNT; Z++) {
							if (Z == J.WALL_BLOCK_SEPARATION)
								continue;
							for (A = 0; A < displayMap[selectX][selectY][Z].length; A++) {
								var bitty:Bitmap = new Bitmap(displayMap[selectX][selectY][Z][A].bitmapData);
								bitty.x = displayMap[selectX][selectY][Z][A].x + 32 * diffX;
								bitty.y = displayMap[selectX][selectY][Z][A].y + 32 * diffY;
								displayMap[X][Y][Z].push(bitty);
								displayLayers[Z].addChild(bitty);
							}
						}
					} else if (selectionType == 35 || selectionType == 36) {
						var newItem:Bitmap = new Bitmap(MOVE_COUNT_BITMAPDATA[movesCountColour][moveCount - 1]);
						newItem.x = 184 + 32 * X;
						newItem.y = 8 + 32 * Y;
						displayMap[X][Y][layer].push(newItem);
						displayLayers[layer].addChild(newItem);
					} else {
						newItem = outside ? new BoundaryBitmap(X, Y, selectionBitmap.bitmapData) : new Bitmap(selectionBitmap.bitmapData);
						newItem.x = 184 + 32 * X;
						newItem.y = 8 + 32 * Y;
						if (selectionType == 23 || selectionType == 24 || selectionType == 25 || selectionType == 26) {
							newItem.x -= 4;
							newItem.y -= 4;
						}
						if (outside) {
							newItem.x += xDir * 4;
							newItem.y += yDir * 4;
							boundaryWalls.push(newItem);
						} else
							displayMap[X][Y][layer].push(newItem);
						displayLayers[layer].addChild(newItem);
					}
				}
			}
		}
		
		private function placeWallAttachmentOutsideGrid(X:int, Y:int, data:Array):Boolean {
			// return true if it was possible and is succesfully altered in data
			if (minX == 13, maxX == 0, minY == 13, maxY == 0)
				return false;
			if (X == minX - 1 && minY <= Y && Y <= maxY)
				return placeOutsideWallAttachment(X, Y, 1, 0, data);
			else if (X == maxX + 1 && minY <= Y && Y <= maxY)
				return placeOutsideWallAttachment(X, Y, -1, 0, data);
			else if (Y == minY - 1 && minX <= X && X <= maxX)
				return placeOutsideWallAttachment(X, Y, 0, 1, data);
			else if (Y == maxY + 1 && minX <= X && X <= maxX)
				return placeOutsideWallAttachment(X, Y, 0, -1, data);
			return false;
		}
		
		private function placeOutsideWallAttachment(X:int, Y:int, xdir:int, ydir:int, data:Array):Boolean {
			if (xdir != data[1] || ydir != data[2])
				return false;
			var arr:Array = null;
			
			for (var g:int = 0; g < dataMap.length; g++) {
				if (dataMap[g][0] == 0) {
					for (var k:int = 1; k < dataMap[g].length; k++) {
						if (dataMap[g][k][0] == 6) {
							arr = dataMap[0][k];
							break;
						}
					}
					break;
				}
			}
			
			if (arr != null) {
				for (var i:int = 1; i < arr.length; i++) {
					if (arr[i][0] == X && arr[i][1] == Y) 
						return false;
				}
			}
			if (arr != null)
				arr.push([X, Y, data]);
			else
				dataMap[0].push([6, [X, Y, data]]);
			return true;
		}
		
		private static const wallAttachmentTypes:Array = [6, 7, 8, 9, 10, 11, 12, 13, 18, 19, 20, 21, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34];
		private function isWallAttachment(selType:int):Boolean {
			return wallAttachmentTypes.indexOf(selType) != -1;
		}
		
		private var down:Boolean = false;
		private function mouseDown(e:MouseEvent):void {
			down = true;
			if (selected) {
				if (firstMovePoint == null &&
						mouseX >= 184 + sminX * 32 && mouseX < 184 + (smaxX + 1) * 32 &&
						mouseY >= 8 + sminY * 32 && mouseY < 8 + (smaxY + 1) * 32) {
					firstMovePoint = new Point(mouseX, mouseY);
					
					selectedData = [];
					for (var i:int = dataMap.length - 1; i >= 0; i--) {
						var obj:Array = dataMap[i];
						if (obj[0] != 0) {
							if (obj[1] >= sminX && obj[1] <= smaxX && obj[2] >= sminY && obj[2] <= smaxY) {
								selectedData.push(obj);
								dataMap.splice(i, 1);
							}
						}
					}
					
					selectedWallSeparation = [];
					for (var k:int = 1; k < dataMap[0].length; k++) {
						if (dataMap[0][k][0] == 4) {
							for (var l:int = 1; l < dataMap[0][k].length; l++) {
								selectedWallSeparation[l - 1] = [];
								for (var j:int = dataMap[0][k][l].length - 1; j >= 0; j--) {
									var err:Array = dataMap[0][k][l][j];
									var inX:Boolean = (err[0] >= sminX) && (err[0] <= smaxX);
									var inY:Boolean = (err[1] >= sminY) && (err[1] <= smaxY);
									if (inX && inY) {
										selectedWallSeparation[l - 1].push(err.concat());
										dataMap[0][k][l].splice(j, 1)
									}
								}
							}
							break;
						}
					}
					selectedConnections = [];
					selectedConnectionSprites = [];
					selectedBitmaps = [];
					for (var X:int = 0; X <= smaxX - sminX; X++) {
						selectedBitmaps[X] = [];
						for (var Y:int = 0; Y <= smaxY - sminY; Y++) {
							if (connections != null) {
								for (var U:int = connections.length - 1; U > 0; U--) {
									if (Connection.hasBlockInConnectionArray(sminX + X, sminY + Y, connections[U])) {
										selectedConnections.push(connections[U].concat());
										connections.splice(U, 1);
									}	
								}
								for each (var connect:Connection in connectionSprites) {
									if (connect.hasBlock(sminX + X, sminY + Y) && selectedConnectionSprites.indexOf(connect) == -1)
										selectedConnectionSprites.push(connect);
								}
							}
							selectedBitmaps[X][Y] = [];
							for (var Z:int = 0; Z < J.LAYER_AMOUNT; Z++) {
								selectedBitmaps[X][Y][Z] = displayMap[sminX + X][sminY + Y][Z];
								for (k = 0; k < selectedBitmaps[X][Y][Z].length; k++) {
									selectedBitmaps[X][Y][Z][k].alpha = 0.6;
									displayMap[sminX + X][sminY + Y][Z] = [];
								}
							}
						}
					}
				} else {
					selected = false;
					selectionSprite.graphics.clear();
				}
			}
		}
		
		private function mouseUp(e:MouseEvent):void {
			down = false;
			if (selected) {
				selected = false;
				selectionSprite.graphics.clear();
				if (firstMovePoint != null) {
					if (sminX + transferX >= 0 && smaxX + transferX <= 13 && sminY + transferY >= 0 && smaxY + transferY <= 13)
						transferDataMap();
					else
						repasteBitmaps();
					firstMovePoint = null;
				}
				transferX = 0;
				transferY = 0;
			}
			if (selectionType == -2 && firstPoint != null) {
				secondPoint = new Point(mouseX, mouseY);
				firstPoint = new Point(Math.floor((firstPoint.x - 184) / 32), Math.floor((firstPoint.y - 8) / 32));
				secondPoint = new Point(Math.floor((secondPoint.x - 184) / 32), Math.floor((secondPoint.y - 8) / 32));
				var newMinX:int = Math.min(Math.max(0, Math.min(firstPoint.x, secondPoint.x)), 13);
				var newMaxX:int = Math.min(Math.max(0, Math.max(firstPoint.x, secondPoint.x)), 13);
				var newMinY:int = Math.min(Math.max(0, Math.min(firstPoint.y, secondPoint.y)), 13);
				var newMaxY:int = Math.min(Math.max(0, Math.max(firstPoint.y, secondPoint.y)), 13);
				firstPoint = null;
				secondPoint = null;
				defineBoundary();
				if (newMinX > minX || newMaxX < maxX || newMinY > minY || newMaxY < maxY)
					return;
				minX = newMinX, maxX = newMaxX, minY = newMinY, maxY = newMaxY;
				updateBoundary();
			}
			if (selectionType == 0 && firstSelectionPoint != null && !selected) {
				selected = true;
				secondSelectionPoint = new Point(mouseX, mouseY);
				firstSelectionPoint = new Point(Math.floor((firstSelectionPoint.x - 184) / 32), Math.floor((firstSelectionPoint.y - 8) / 32));
				secondSelectionPoint = new Point(Math.floor((secondSelectionPoint.x - 184) / 32), Math.floor((secondSelectionPoint.y - 8) / 32));
				newMinX = Math.min(Math.max(0, Math.min(firstSelectionPoint.x, secondSelectionPoint.x)), 13);
				newMaxX = Math.min(Math.max(0, Math.max(firstSelectionPoint.x, secondSelectionPoint.x)), 13);
				newMinY = Math.min(Math.max(0, Math.min(firstSelectionPoint.y, secondSelectionPoint.y)), 13);
				newMaxY = Math.min(Math.max(0, Math.max(firstSelectionPoint.y, secondSelectionPoint.y)), 13);
				firstSelectionPoint = null;
				secondSelectionPoint = null;
				sminX = newMinX, smaxX = newMaxX, sminY = newMinY, smaxY = newMaxY;
				updateSelection();
			}
		}
		
		private function updateBoundary(update:Boolean = true):void {
			boundarySprite.graphics.clear();
			boundarySprite.graphics.lineStyle(2, 0xf60000, 0.8);
			boundarySprite.graphics.drawRect(184 + minX * 32, 8 + minY * 32, (maxX - minX + 1) * 32, (maxY - minY + 1) * 32);
			if (!update)
				return;
			var updated:Boolean = false;
			var changed:Boolean = true;
			for (var i:int = 1; i < dataMap[0].length; i++) {
				if (dataMap[0][i][0] == 2) {
					changed = !(dataMap[0][i][1] == minX && dataMap[0][i][2] == minY && dataMap[0][i][3] == maxX - minX + 1 && dataMap[0][i][4] == maxY - minY + 1);
					dataMap[0][i] = [2, minX, minY, maxX-minX+1, maxY-minY+1];
					updated = true;
				}
			}
			if (!updated)
				dataMap[0].push([2, minX, minY, maxX - minX + 1, maxY - minY + 1]);
			if (changed) {
				for (i = 0; i < boundaryWalls.length; i++) {
					if (displayLayers[J.WALL_ATTACHMENT_LAYER].contains(boundaryWalls[i]))
						displayLayers[J.WALL_ATTACHMENT_LAYER].removeChild(boundaryWalls[i]);
				}
				boundaryWalls = [];
				for (i = 0; i < dataMap.length; i++) {
					if (dataMap[i][0] == 0) {
						for (var j:int = 1; j < dataMap[i].length; j++) {
							if (dataMap[i][j][0] == 6) {
								dataMap[i].splice(j, 1);
								break;
							}
						}
						break;
					}
				}
			}
		}
		
		private var
			selectedData:Array = [],
			selectedBitmaps:Array = [],
			selectedWallSeparation:Array = [],
			selectedConnections:Array = [],
			selectedConnectionSprites:Array = [];
		private function updateSelection():void {
			selectionSprite.x = 0;
			selectionSprite.y = 0;
			selectionSprite.graphics.clear();
			selectionSprite.graphics.lineStyle(2, 0x00f600, 0.8);
			selectionSprite.graphics.drawRect(184 + sminX * 32, 8 + sminY * 32, (smaxX - sminX + 1) * 32, (smaxY - sminY + 1) * 32);
		}
		
		private function repasteBitmaps():void {
			dataMap = dataMap.concat(selectedData);
			if (connections != null) {
				for (var k:int = 0; k < selectedConnections.length; k++)
					connections.push(selectedConnections[k].concat());
			}
			for (k = 1; k < dataMap[0].length; k++) {
				if (dataMap[0][k][0] == 4) {
					for (var l:int = 1; l < dataMap[0][k].length; l++)
						dataMap[0][k][l] = dataMap[0][k][l].concat(selectedWallSeparation[l - 1]);
					break;
				}
			}
			for (var X:int = 0; X <= smaxX - sminX; X++) {
				for (var Y:int = 0; Y <= smaxY - sminY; Y++) {
					for (var Z:int = 0; Z < J.LAYER_AMOUNT; Z++) {
						for (k = 0; k < selectedBitmaps[X][Y][Z].length; k++) {
							selectedBitmaps[X][Y][Z][k].alpha = 1;
							selectedBitmaps[X][Y][Z][k].x -= transferX * 32;
							selectedBitmaps[X][Y][Z][k].y -= transferY * 32;
						}
						displayMap[sminX + X][sminY + Y][Z] = displayMap[sminX + X][sminY + Y][Z].concat(selectedBitmaps[X][Y][Z]);
					}
				}
			}
			selectedBitmaps = [];
		}
		
		private var 
			transferX:int,
			transferY:int;
		private function transferDataMap():void {
			firstMovePoint = null;
			var possibleConflicts:Array = [];
			for each (var obj:Array in selectedData)
				possibleConflicts.push([obj[1] + transferX, obj[2] + transferY]);
			for each (obj in dataMap) {
				if (obj[0] != 0) {
					if (obj[1] >= sminX + transferX && obj[1] <= smaxX + transferX &&
							obj[2] >= sminY + transferY && obj[2] <= smaxY + transferY) {
						for (var j:int = 0; j < possibleConflicts.length; j++) {
							if (obj[1] == possibleConflicts[j][0] && obj[2] == possibleConflicts[j][1]) {
								repasteBitmaps();
								return; // not possible to paste in this position
							}
						}
					}
				}
			}
			for each (obj in selectedData) {
				obj[1] += transferX;
				obj[2] += transferY;
				dataMap.push(obj);
			}
			var len:int = selectedData.length;
			selectedData = [];
			
			for each (obj in selectedConnections) {
				if (sminX <= obj[0] && obj[0] <= smaxX && sminY <= obj[1] && obj[1] <= smaxY) {
					obj[0] += transferX;
					obj[1] += transferY;
				}
				if (sminX <= obj[2] && obj[2] <= smaxX && sminY <= obj[3] && obj[3] <= smaxY) {
					obj[2] += transferX;
					obj[3] += transferY;
				}
			}
			for each (var connect:Connection in selectedConnectionSprites)
				connect.transfer(transferX, transferY, sminX, smaxX, sminY, smaxY);
			if (connections != null) {
				for (k = 0; k < selectedConnections.length; k++)
					connections.push(selectedConnections[k].concat());
			}
			selectedConnections = [];
			selectedConnectionSprites = [];
			
			for (var l:int = 0; l < selectedWallSeparation.length; l++) {
				for (j = 0; j < selectedWallSeparation[l].length; j++) {
					selectedWallSeparation[l][j][0] += transferX;
					selectedWallSeparation[l][j][1] += transferY;
				}
			}
			for (var k:int = 1; k < dataMap[0].length; k++) {
				if (dataMap[0][k][0] == 4) {
					for (l = 1; l < dataMap[0][k].length; l++)
						dataMap[0][k][l] = dataMap[0][k][l].concat(selectedWallSeparation[l - 1]);
					break;
				}
			}
			selectedWallSeparation = [];
			
			for (var X:int = 0; X <= smaxX - sminX; X++) {
				for (var Y:int = 0; Y <= smaxY - sminY; Y++) {
					for (var Z:int = 0; Z < J.LAYER_AMOUNT; Z++) {
						for (k = 0; k < selectedBitmaps[X][Y][Z].length; k++)
							selectedBitmaps[X][Y][Z][k].alpha = 1;
						displayMap[sminX + transferX + X][sminY + transferY + Y][Z] = displayMap[sminX + transferX + X][sminY + transferY + Y][Z].concat(selectedBitmaps[X][Y][Z]);
					}
				}
			}
			
			// retile wall block separations
			for (k = 1; k < dataMap[0].length; k++) {
				if (dataMap[0][k][0] == 4) {
					for (l = 1; l < dataMap[0][k].length; l++)
						pasteWallBlockSeparation(dataMap[0][k][l]);
					break;
				}
			}
			
			if (len != 0) {
				defineBoundary();
				updateBoundary();
			}
		}
		
		private var savedShapeAmounts:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		private function enableShapes(e:Event):void {
			if (shapeEnabler.selected) {
				var readFromData:Boolean = false;
				for (i = 0; i < dataMap[0].length; i++) {
					if (dataMap[0][i] is Array && dataMap[0][i][0] == 3) {
						readFromData = true;
						for (var j:int = 1; j < dataMap[0][i][1].length-1/*zonder rainbow, daarom -1*/; j++) {
							if (j == 11)
								continue;
							else if (j == 12)
								shapeSteppers[j - 2].value = dataMap[0][i][1][j];
							else
								shapeSteppers[j - 1].value = dataMap[0][i][1][j];
						}
						break;
					}
				}
				if (!readFromData) {
					dataMap[0].push([3, []]);
					for (j = 1; j < savedShapeAmounts.length - 1/*zonder rainbow, daarom -1*/; j++) {
						dataMap[0][dataMap[0].length - 1][1].push(savedShapeAmounts[j]);
						if (j == 11)
							continue;
						else if (j == 12)
							shapeSteppers[j - 2].value = savedShapeAmounts[j];
						else
							shapeSteppers[j - 1].value = savedShapeAmounts[j];
					}
					dataMap[0][dataMap[0].length - 1][1].push(0); // rainbow
				}
				for (var i:int = 0; i < shapeSteppers.length; i++) {
					addChild(shapeSteppersUnderColour[i]);
					addChild(shapeSteppers[i]);
				}
			} else {
				for (i = 0; i < shapeSteppers.length; i++) {
					if (contains(shapeSteppersUnderColour[i]))
						removeChild(shapeSteppersUnderColour[i]);
					if (contains(shapeSteppers[i]))
						removeChild(shapeSteppers[i]);
				}
				for (i = 0; i < dataMap[0].length; i++) {
					if (dataMap[0][i] is Array && dataMap[0][i][0] == 3) {
						for (j = 0; j < dataMap[0][i][1].length; j++)
							savedShapeAmounts[i] = dataMap[0][i][1][j];
						dataMap[0].splice(i, 1);
						break;
					}
				}
			}
		}
		
		private function changeShapeCount(e:Event):void {
			var newShapeCount:Array = [0];
			for (var i:int = 0; i < shapeSteppers.length; i++)
				newShapeCount.push(shapeSteppers[i].value);
			// rainbow adding here
			newShapeCount.push(0, 0);
			var changed:Boolean = false;
			for (i = 1; i < dataMap[0].length; i++) {
				if (dataMap[0][i] is Array && dataMap[0][i][0] == 3) {
					changed = true;
					for (var j:int = 0; j < newShapeCount.length; j++)
						dataMap[0][i][1][j] = newShapeCount[j];
					break;
				}
			}
			if (!changed)
				dataMap[0].push([3, newShapeCount]);
			for (i = 0; i < newShapeCount.length; i++)
				savedShapeAmounts[i] = newShapeCount[i];
		}
		
		private function changeMoveCount(e:Event):void {
			moveCount = moveCountStepper.value;
			movesCount.removeChild(movesCountBitmap);
			movesCount.addChild(movesCountBitmap = new Bitmap(MOVE_COUNT_BITMAPDATA[colour][moveCount - 1]));
			wallMovesCount.removeChild(wallMovesCountBitmap);
			wallMovesCount.addChild(wallMovesCountBitmap = new Bitmap(MOVE_COUNT_BITMAPDATA[11][moveCount - 1]));
			
			allowSame = true;
			if (selectionType == 35)
				clickMovesCount(null);
			if (selectionType == 36)
				clickWallMovesCount(null);
		}
		
		private function clickGrey(e:MouseEvent):void {
			clickOnColour(0);
		}
		
		private function clickRed(e:MouseEvent):void {
			clickOnColour(1);
		}
		
		private function clickBlue(e:MouseEvent):void {
			clickOnColour(2);
		}
		
		private function clickGreen(e:MouseEvent):void {
			clickOnColour(3);
		}
		
		private function clickYellow(e:MouseEvent):void {
			clickOnColour(4);
		}
		
		private function clickPurple(e:MouseEvent):void {
			clickOnColour(5);
		}
		
		private function clickPink(e:MouseEvent):void {
			clickOnColour(6);
		}
		
		private function clickCyan(e:MouseEvent):void {
			clickOnColour(7);
		}
		
		private function clickOrange(e:MouseEvent):void {
			clickOnColour(8);
		}
		
		private function clickDarkRed(e:MouseEvent):void {
			clickOnColour(9);
		}
		
		private function clickDarkGreen(e:MouseEvent):void {
			clickOnColour(10);
		}
		
		private function clickOnColour(col:int):void {
			colour = col;
			block.removeChild(blockBitmap);
			block.addChild(blockBitmap = new Bitmap(BLOCK_BITMAPDATA[colour]));
			blockUnderLocked.removeChild(blockUnderLockedBitmap);
			blockUnderLocked.addChild(blockUnderLockedBitmap = new Bitmap(BLOCK_BITMAPDATA[colour]));
			blockUnderMoveCount.removeChild(blockUnderMoveCountBitmap);
			blockUnderMoveCount.addChild(blockUnderMoveCountBitmap = new Bitmap(BLOCK_BITMAPDATA[colour]));
			immobileBlock.removeChild(immobileBlockBitmap);;
			immobileBlock.addChild(immobileBlockBitmap = new Bitmap(IMMOBILE_BLOCK_BITMAPDATA[colour]));
			movesCount.removeChild(movesCountBitmap);
			movesCount.addChild(movesCountBitmap = new Bitmap(MOVE_COUNT_BITMAPDATA[colour][moveCount - 1]));
			if (wallAttachmentType == 0) {
				for (var t:int = 0; t < 4; t++) {
					wallAttachments[t].removeChild(wallAttachmentBitmaps[t]);
					wallAttachments[t].addChild(wallAttachmentBitmaps[t] = new Bitmap(WALL_ATTACHMENT_BITMAPDATA[0][colour][0][t]));
				}
			}
			wallAttachmentButtons[0].removeChild(ccButtonBitmap);
			wallAttachmentButtons[0].addChild(ccButtonBitmap = new Bitmap(WALL_ATTACHMENT_BUTTON_BITMAPDATA[0][colour]));
			for (t = 0; t < 4; t++) {
				forceFields[t].removeChild(forceFieldBitmaps[t]);
				forceFields[t].addChild(forceFieldBitmaps[t] = new Bitmap(FORCE_FIELD_BITMAPDATA[colour][t]));
			}
			allowSame = true;
			if (selectionType == 1)
				clickBlock(null);
			else if (selectionType == 3)
				clickImmobileBlock(null);
			else if (selectionType == 14)
				clickUpForceField(null);
			else if (selectionType == 15)
				clickLeftForceField(null);
			else if (selectionType == 16)
				clickRightForceField(null);
			else if (selectionType == 17)
				clickDownForceField(null);
			else if (selectionType == 35)
				clickMovesCount(null);
				
			if (wallAttachmentType == 0) {
				if (selectionType == wallAttachmentStartIndex[0])
					clickUpWallAttachment(null);
				else if (selectionType == wallAttachmentStartIndex[0] + 1)
					clickLeftWallAttachment(null);
				else if (selectionType == wallAttachmentStartIndex[0] + 2)
					clickRightWallAttachment(null);
				else if (selectionType == wallAttachmentStartIndex[0] + 3)
					clickDownWallAttachment(null);
			}
		}
		
		private var allowSame:Boolean = false
		private function clickItem(selectType:int, bitmapData:BitmapData):void {
			if (contains(selectionBitmap))
				removeChild(selectionBitmap);
			if (selectionType == -6 || selectionType == -7) {
				if (selectionType != selectType) {
					firstBlock = null;
					secondBlock = null;
				}
			}
			if (selectType == 0)
				setTooltip("");
			if ((selectionType == selectType && selectionType != -3 && !allowSame) || (selectionType == -3 && selectType != -3 && selectedCell != null)) {
				if (selectionType == -5)
					clickWallBlockSeparate(null);
				else {
					selectionBitmap = new Bitmap();
					selectionType = 0;
					setTooltip("");
					selectedCell = null;
					for each (var arr:Array in wallBlockSeparationCoordinates) {
						for each (var bit:Bitmap in displayMap[arr[0]][arr[1]][J.WALL_BLOCK_SEPARATION]) {
							displayLayers[J.WALL_BLOCK_SEPARATION].removeChild(bit);
						}
						displayMap[arr[0]][arr[1]][J.WALL_BLOCK_SEPARATION] = [];
					}
					wallBlockSeparationCoordinates = [];
				}
			} else {
				if (selectionType == -4 && selectType != -5) {
					for each (arr in wallBlockSeparationCoordinates) {
						for each (bit in displayMap[arr[0]][arr[1]][J.WALL_BLOCK_SEPARATION]) {
							displayLayers[J.WALL_BLOCK_SEPARATION].removeChild(bit);
						}
						displayMap[arr[0]][arr[1]][J.WALL_BLOCK_SEPARATION] = [];
					}
					wallBlockSeparationCoordinates = [];
				}
				selectionBitmap = new Bitmap(bitmapData);
				selectionType = selectType;
			}
			selectionBitmap.alpha = 0.5;
			addChild(selectionBitmap);
			allowSame = false;
		}
		
		private function clickBlock(e:MouseEvent):void {
			setTooltip("Click an empty tile in the grid to place a normal block.");
			clickItem(1, BLOCK_BITMAPDATA[colour]);
		}
		
		private function clickWall(e:MouseEvent):void {
			setTooltip("Click an empty tile in the grid to place a wall.");
			clickItem(2, WALL_BITMAPDATA);
		}
		
		private function clickImmobileBlock(e:MouseEvent):void {
			setTooltip("Click an empty tile in the grid to place an immobile block.");
			clickItem(3, IMMOBILE_BLOCK_BITMAPDATA[colour]);
		}
		
		private function clickMovableWall(e:MouseEvent):void {
			setTooltip("Click an empty tile in the grid to place a wall block.");
			clickItem(4, BLOCK_BITMAPDATA[11]);
		}
		
		private function clickImmobileMovableWall(e:MouseEvent):void {
			setTooltip("Click an empty tile in the grid to place an immobile wall block.");
			clickItem(5, IMMOBILE_BLOCK_BITMAPDATA[11]);
		}
		
		private function clickUpForceField(e:MouseEvent):void {
			setTooltip("Click a tile in the grid to place an up force field.");
			clickItem(14, FORCE_FIELD_PASTE_BITMAPDATA[colour][0]);
		}
		
		private function clickLeftForceField(e:MouseEvent):void {
			setTooltip("Click a tile in the grid to place a left force field.");
			clickItem(15, FORCE_FIELD_PASTE_BITMAPDATA[colour][1]);
		}
		
		private function clickRightForceField(e:MouseEvent):void {
			setTooltip("Click a tile in the grid to place a right force field.");
			clickItem(16, FORCE_FIELD_PASTE_BITMAPDATA[colour][2]);
		}
		
		private function clickDownForceField(e:MouseEvent):void {
			setTooltip("Click a tile in the grid to place a down force field.");
			clickItem(17, FORCE_FIELD_PASTE_BITMAPDATA[colour][3]);
		}
		
		private function clickLocked(e:MouseEvent):void {
			setTooltip("Click a normal block in the grid to place a lock on it.");
			clickItem(22, lockedBitmap.bitmapData);
		}
		
		private function clickMovesCount(e:MouseEvent):void {
			setTooltip("Click a normal block in the grid to place a move count on it.");
			clickItem(35, MOVE_COUNT_BITMAPDATA[colour][moveCount - 1]);
		}
		
		private function clickWallMovesCount(e:MouseEvent):void {
			setTooltip("Click a wall block in the grid to place a move count on it.");
			clickItem(36, MOVE_COUNT_BITMAPDATA[11][moveCount - 1]);
		}
		
		private function clickGarbage(e:MouseEvent):void {
			setTooltip("Click a tile in the grid to delete it.");
			clickItem( -1, garbageBitmap.bitmapData);
		}
		
		private function clickWallAttachmentButton(type:int, bitmapDatas:Array, xOffset:int = 0, yOffset:int = 0):void {
			wallAttachmentType = type;
			for (var i:int = 0; i < 4; i++) {
				wallAttachments[i].removeChild(wallAttachmentBitmaps[i]);
				wallAttachments[i].addChild(wallAttachmentBitmaps[i] = new Bitmap(bitmapDatas[i]));
				wallAttachmentBitmaps[i].x = xOffset;
				wallAttachmentBitmaps[i].y = yOffset;
			}
			selectionType = 0;
			setTooltip("");
			selectedCell = null;
			if (contains(selectionBitmap))
				removeChild(selectionBitmap);
			selectionBitmap = new Bitmap();
			addChild(selectionBitmap);
		}
		
		private function clickColourChanger(e:MouseEvent):void {
			clickWallAttachmentButton(0, WALL_ATTACHMENT_BITMAPDATA[0][colour][0]);
		}
		
		private function clickBomb(e:MouseEvent):void {
			clickWallAttachmentButton(1, WALL_ATTACHMENT_BITMAPDATA[1]);
		}
		
		private function clickHinge(e:MouseEvent):void {
			clickWallAttachmentButton(2, WALL_ATTACHMENT_BITMAPDATA[2]);
		}
		
		private function clickSpike(e:MouseEvent):void {
			clickWallAttachmentButton(3, WALL_ATTACHMENT_BITMAPDATA[3], -4, -4);
		}
		
		private function clickFreezer(e:MouseEvent):void {
			clickWallAttachmentButton(4, WALL_ATTACHMENT_BITMAPDATA[4]);
		}
		
		private function clickDefroster(e:MouseEvent):void {
			clickWallAttachmentButton(5, WALL_ATTACHMENT_BITMAPDATA[5]);
		}
		
		private function clickUpWallAttachment(e:MouseEvent):void {
			setTooltip("Click a wall or wall block in the grid to add an up " + wallAttachmentString(wallAttachmentType) + " to it.");
			clickItem(wallAttachmentStartIndex[wallAttachmentType], wallAttachmentBitmaps[0].bitmapData);
		}
		
		private function clickLeftWallAttachment(e:MouseEvent):void {
			setTooltip("Click a wall or wall block in the grid to add a left " + wallAttachmentString(wallAttachmentType) + " to it.");
			clickItem(wallAttachmentStartIndex[wallAttachmentType] + 1, wallAttachmentBitmaps[1].bitmapData);
		}
		
		private function clickRightWallAttachment(e:MouseEvent):void {
			setTooltip("Click a wall or wall block in the grid to add a right " + wallAttachmentString(wallAttachmentType) + " to it.");
			clickItem(wallAttachmentStartIndex[wallAttachmentType] + 2, wallAttachmentBitmaps[2].bitmapData);
		}
		
		private function clickDownWallAttachment(e:MouseEvent):void {
			setTooltip("Click a wall or wall block in the grid to add a down " + wallAttachmentString(wallAttachmentType) + " to it.");
			clickItem(wallAttachmentStartIndex[wallAttachmentType] + 3, wallAttachmentBitmaps[3].bitmapData);
		}
		
		private function overItem(text:String):void {
			selectText.text = text;
			if (selectText.numLines > 1)
				selectText.y = 6;
			else
				selectText.y = 11;
		}
		
		private function colourToText(col:int):String {
			var str:String = "";
			switch (col) {
				case 0: str = "Grey"; break;
				case 1: str = "Red"; break;
				case 2: str = "Blue"; break;
				case 3: str = "Green"; break;
				case 4: str = "Yellow"; break;
				case 5: str = "Purple"; break;
				case 6: str = "Pink"; break;
				case 7: str = "Cyan"; break;
				case 8: str = "Orange"; break;
				case 9: str = "Dark red"; break;
				case 10: str = "Dark green"; break;
			}
			return str;
		}
		
		private function overGrey(e:MouseEvent):void {
			overItem("Grey");
		}
		
		private function overRed(e:MouseEvent):void {
			overItem("Red");
		}
		
		private function overBlue(e:MouseEvent):void {
			overItem("Blue");
		}
		
		private function overGreen(e:MouseEvent):void {
			overItem("Green");
		}
		
		private function overYellow(e:MouseEvent):void {
			overItem("Yellow");
		}
		
		private function overPurple(e:MouseEvent):void {
			overItem("Purple");
		}
		
		private function overPink(e:MouseEvent):void {
			overItem("Pink");
		}
		
		private function overCyan(e:MouseEvent):void {
			overItem("Cyan");
		}
		
		private function overOrange(e:MouseEvent):void {
			overItem("Orange");
		}
		
		private function overDarkRed(e:MouseEvent):void {
			overItem("Dark red");
		}
		
		private function overDarkGreen(e:MouseEvent):void {
			overItem("Dark green");
		}
		
		private function overBlock(e:MouseEvent):void {
			overItem(colourToText(colour) + " block");
		}
		
		private function overWall(e:MouseEvent):void {
			overItem("Wall");
		}
		
		private function overImmobileBlock(e:MouseEvent):void {
			overItem(colourToText(colour) + " immobile block");
		}
		
		private function overMovableWall(e:MouseEvent):void {
			overItem("Wall block");
		}
		
		private function overImmobileMovableWall(e:MouseEvent):void {
			overItem("Immobile wall block");
		}
		
		private function overUpForceField(e:MouseEvent):void {
			overItem(colourToText(colour) + " force field up");
		}
		
		private function overLeftForceField(e:MouseEvent):void {
			overItem(colourToText(colour) + " force field left");
		}
		
		private function overRightForceField(e:MouseEvent):void {
			overItem(colourToText(colour) + " force field right");
		}
		
		private function overDownForceField(e:MouseEvent):void {
			overItem(colourToText(colour) + " force field down");
		}
		
		private function overLocked(e:MouseEvent):void {
			overItem("Lock block");
		}
		
		private function overMovesCount(e:MouseEvent):void {
			overItem("Move count");
		}
		
		private function overWallMovesCount(e:MouseEvent):void {
			overItem("Move count");
		}
		
		private function overGarbage(e:MouseEvent):void {
			overItem("Delete a tile");
		}
		
		private function overColourChanger(e:MouseEvent):void {
			overItem(colourToText(colour) + " colour changers");
		}
		
		private function overBomb(e:MouseEvent):void {
			overItem("Bombs");
		}
		
		private function overHinge(e:MouseEvent):void {
			overItem("Hinges");
		}
		
		private function overSpike(e:MouseEvent):void {
			overItem("Spikes");
		}
		
		private function overFreezer(e:MouseEvent):void {
			overItem("Freezers");
		}
		
		private function overDefroster(e:MouseEvent):void {
			overItem("Defrosters");
		}
		
		private function overWallAttachments(type:int):String {
			var str:String = "";
			switch (type) {
				case 0: str = colourToText(colour)+ " colour changer"; break;
				case 1: str = "Bomb"; break;
				case 2: str = "Hinge"; break;
				case 3: str = "Spike"; break;
				case 4: str = "Freezer"; break;
				case 5: str = "Defroster"; break;
			}
			return str;
		}
		
		private function wallAttachmentString(type:int):String {
			var str:String = "";
			switch (type) {
				case 0: str = "colour changer"; break;
				case 1: str = "bomb"; break;
				case 2: str = "hinge"; break;
				case 3: str = "spike"; break;
				case 4: str = "freezer"; break;
				case 5: str = "defroster"; break;
			}
			return str;
		}
		
		private function overUpWallAttachment(e:MouseEvent):void {
			overItem(overWallAttachments(wallAttachmentType) + " up");
		}
		
		private function overLeftWallAttachment(e:MouseEvent):void {
			overItem(overWallAttachments(wallAttachmentType) + " left");
		}
		
		private function overRightWallAttachment(e:MouseEvent):void {
			overItem(overWallAttachments(wallAttachmentType) + " right");
		}
		
		private function overDownWallAttachment(e:MouseEvent):void {
			overItem(overWallAttachments(wallAttachmentType) + " down");
		}
		
		private function mouseOut(e:MouseEvent):void {
			selectText.text = "";
		}
		
		private var
			firstSelectionPoint:Point,
			secondSelectionPoint:Point,
			selectionSprite:Sprite = new Sprite(),
			selectionProgressSprite:Sprite = new Sprite(),
			sminX:int = 13,
			smaxX:int = 0,
			sminY:int = 13,
			smaxY:int = 0,
			selected:Boolean = false,
			firstMovePoint:Point,
			firstPoint:Point,
			secondPoint:Point,
			boundarySprite:Sprite = new Sprite(),
			boundaryProgressSprite:Sprite = new Sprite(),
			minX:int = 13,
			maxX:int = 0,
			minY:int = 13,
			maxY:int = 0;
		private function clickBoundary(e:MouseEvent):void {
			setTooltip("Drag a rectangle in the grid for setting the new boundary.");
			clickItem( -2, boundaryBitmap.bitmapData);
		}
		
		private function overBoundary(e:MouseEvent):void {
			overItem("Adjust Boundary");
		}
		
		private var
			selectedCell:ByteArray,
			selectX:int,
			selectY:int;
		private function clickSelect(e:MouseEvent):void {
			if (selectionType != 0) {
				selectedCell = null;
				clickItem(0, null);
			} else {
				setTooltip("Click a tile in the grid to copy it.");
				clickItem( -3, selectBitmap.bitmapData);
			}
		}
		
		private function prepareSelectedCell(X:int, Y:int):Boolean {
			var succeeded:Boolean = false;
			selectX = X;
			selectY = Y;
			selectedCell = new ByteArray();
			var arr:Array = [];
			for each (var obj:Array in dataMap) {
				if (obj[0] != 0) {
					if (obj[1] == X && obj[2] == Y) {
						succeeded = true;
						arr.push(obj);
					}
				}
			}
			selectedCell.writeObject(arr);
			return succeeded;
		}
		
		private function copySelectedCell(newX:int, newY:int):Array {
			selectedCell.position = 0;
			var arr:Array = selectedCell.readObject();
			for each (var obj:Array in arr) {
				obj[1] = newX;
				obj[2] = newY;
			}
			return arr;
		}
		
		private function overSelect(e:MouseEvent):void {
			overItem("Select cell to copy/ deselect");
		}
		
		private var wallBlockSeparationCoordinates:Array = [];
		private function clickWallBlockSeparate(e:MouseEvent):void {
			setTooltip("Click wall blocks to merge together.");
			clickItem( -4, wallBlockSeparateBitmap.bitmapData);
		}
		
		private function overWallBlockSeparate(e:MouseEvent):void {
			overItem("Custom wall block merge");
		}
		
		private function clickWallBlockSeparateConfirm(e:MouseEvent):void {
			if ((selectionType == -4 || selectionType == -5) && wallBlockSeparationCoordinates.length != 0) {
				pasteWallBlockSeparation(wallBlockSeparationCoordinates);
				var arr:Array = null;
				for (var k:int = 1; k < dataMap[0].length; k++) {
					if (dataMap[0][k][0] == 4) {
						arr = dataMap[0][k];
						break;
					}
				}
				if (arr == null) {
					dataMap[0].push([4]);
					arr = dataMap[0][dataMap[0].length - 1];
				}
				var byteArr:ByteArray = new ByteArray();
				byteArr.position = 0;
				byteArr.writeObject(wallBlockSeparationCoordinates);
				byteArr.position = 0;
				var coordinates:Array = byteArr.readObject();
				arr.push(coordinates);
				byteArr.clear();
				byteArr = null;
			}
			wallBlockSeparationCoordinates = [];
			clickItem(0, null);
		}
		
		private function pasteWallBlockSeparation(coordinates:Array):void {
			for each (var arr:Array in coordinates) {
				var X:int = arr[0];
				var Y:int = arr[1];
				var
					hasUp:Boolean = false,
					hasRight:Boolean = false,
					hasDown:Boolean = false,
					hasLeft:Boolean = false,
					hasUpLeft:Boolean = false,
					hasUpRight:Boolean = false,
					hasDownLeft:Boolean = false,
					hasDownRight:Boolean = false;
				for each (var arr2:Array in coordinates) {
					if (!hasUp)
						hasUp = (arr2[0] == X && arr2[1] == Y - 1);
					if (!hasRight)
						hasRight = (arr2[0] == X + 1 && arr2[1] == Y);
					if (!hasDown)
						hasDown = (arr2[0] == X && arr2[1] == Y + 1);
					if (!hasLeft)
						hasLeft = (arr2[0] == X - 1 && arr2[1] == Y);
					if (!hasUpLeft)
						hasUpLeft = (arr2[0] == X - 1 && arr2[1] == Y - 1);
					if (!hasUpRight)
						hasUpRight = (arr2[0] == X + 1 && arr2[1] == Y - 1);
					if (!hasDownLeft)
						hasDownLeft = (arr2[0] == X - 1 && arr2[1] == Y + 1);
					if (!hasDownRight)
						hasDownRight = (arr2[0] == X + 1 && arr2[1] == Y + 1);
					if (hasUp && hasRight && hasDown && hasLeft && hasUpLeft && hasUpRight && hasDownLeft && hasDownRight)
						break;
				}
				var frame:int = int(hasDown) + 2 * int(hasRight) + 4 * int(hasLeft) + 8 * int(hasUp);
				var bit:Bitmap = displayMap[X][Y][J.WALL_BLOCK_SEPARATION][0];
				if (bit)
					displayLayers[J.WALL_BLOCK_SEPARATION].removeChild(bit);
				bit = new Bitmap(WALL_BLOCK_SEPARATION_BITMAPDATA[1][frame].clone());
				bit.x = 184 + 32 * X;
				bit.y = 8 + 32 * Y;
				displayMap[X][Y][J.WALL_BLOCK_SEPARATION][0] = bit;
				displayLayers[J.WALL_BLOCK_SEPARATION].addChild(bit);
				
				if (hasUp && hasLeft && !hasUpLeft)
					bit.bitmapData.copyPixels(WALL_BLOCK_SEPARATION_BITMAPDATA[1][16], new Rectangle(0, 0, 32, 32), new Point(0, 0), null, null, true);
				if (hasUp && hasRight && !hasUpRight)
					bit.bitmapData.copyPixels(WALL_BLOCK_SEPARATION_BITMAPDATA[1][17], new Rectangle(0, 0, 32, 32), new Point(0, 0), null, null, true);
				if (hasDown && hasLeft && !hasDownLeft)
					bit.bitmapData.copyPixels(WALL_BLOCK_SEPARATION_BITMAPDATA[1][18], new Rectangle(0, 0, 32, 32), new Point(0, 0), null, null, true);
				if (hasDown && hasRight && !hasDownRight)
					bit.bitmapData.copyPixels(WALL_BLOCK_SEPARATION_BITMAPDATA[1][19], new Rectangle(0, 0, 32, 32), new Point(0, 0), null, null, true);
			}
		}
		
		private function overWallBlockSeparateConfirm(e:MouseEvent):void {
			overItem("Confirm custom wall block merge");
		}
		
		private function clickWallBlockSeparateGarbage(e:MouseEvent):void {
			setTooltip("Click a wall block in the current merge to remove it from it.");
			clickItem( -5, wallBlockSeparateGarbageBitmap.bitmapData);
		}
		
		private function overWallBlockSeparateGarbage(e:MouseEvent):void {
			overItem("Delete block in custom wall block merge");
		}
		
		private var
			firstBlock:Point,
			firstDirection:Point = new Point(),
			secondBlock:Point,
			secondDirection:Point = new Point(),
			connectionsSprite:Sprite = new Sprite(),
			connectionSprites:/*Connection*/Array = [],
			connectionProgressSprite:Sprite = new Sprite();
		private function clickBlockConnection(e:MouseEvent):void {
			firstBlock = null;
			secondBlock = null;
			setTooltip("Click a block or wall block on one of the four sides to add a fixed link to it.");
			clickItem( -6, blockConnectionBitmap.bitmapData);
		}
		
		private function overBlockConnection(e:MouseEvent):void {
			overItem("Add a fixed link between blocks");
		}
		
		private function clickBlockConnectionGarbage(e:MouseEvent):void {
			setTooltip("Click a block or wall block you want to remove a fixed link from.");
			clickItem( -7, blockConnectionGarbageBitmap.bitmapData);
		}
		
		private function overBlockConnectionGarbage(e:MouseEvent):void {
			overItem("Delete a fixed link");
		}
		
		private function setTooltip(tip:String):void {
			toolTip.text = tip;
		}
	}
}