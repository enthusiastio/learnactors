package lv.enthusiast.learnactors.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	// **********************************************************************************
	// **********************************************************************************
	
	
	/**
	 * Provides convenience conversion methods for Sprites and Bitmaps.
	 * 
	 * Open source. Free to use. Licensed under the MIT License.
	 * 
	 * @author	Nate Chatellier
	 * @see		http://blog.natejc.com
	 */
	public class DisplayConverter
	{
		//FLASH PLAYER 9 LIMITS
		//Although in FP10 they increased the limit to
		//4095x4095 there is the old computer programming
		//adage: Don't be greedy!
		public static const WIDTH_LIMIT:Number = 2880;
		public static const HEIGHT_LIMIT:Number = 2880;
		public static const PIXEL_LIMIT:Number = (WIDTH_LIMIT * HEIGHT_LIMIT);
		private static const TILE_OVERLAP:Number = 4;
		
		private static const ZERO_POINT : Point = new Point();
		private static var MATRIX : Matrix = new Matrix();
		
		// **********************************************************************************		
		
		/**
		 * Constructs the DisplayConverter object.
		 */
		public function DisplayConverter()
		{
			trace("DisplayConverter is a static class and should not be instantiated");
			
		} // END CONSTRUCTOR
		
		
		
		// **********************************************************************************
		

		
		
		/**
		 * Converts a Bitmap to a Sprite.
		 *
		 * @param	bitmap		The Bitmap that should be converted.
		 * @param	smoothing	Whether or not the bitmap is smoothed when scaled.
		 * @return				The converted Sprite object.
		 * 
		 * @see					http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/Bitmap.html#smoothing
		 */
		public static function bitmapToSprite(bitmap:Bitmap, smoothing:Boolean = false):Sprite
		{
			var sprite:Sprite = new Sprite();
			sprite.addChild( new Bitmap(bitmap.bitmapData.clone(), "auto", smoothing) );
			return sprite;
			
		} // END FUNCTION bitmapToSprite
		
		
		// **********************************************************************************
		
		
		public static function getVisibleBounds(object:DisplayObject):Rectangle
		{
			MATRIX.identity();
			var matBounds:Rectangle = object.getBounds(object);
			MATRIX.tx = -matBounds.x;
			MATRIX.ty = -matBounds.y;
			
			var data:BitmapData = new BitmapData(object.width, object.height, true, 0x00000000);
			data.draw(object, MATRIX);
			
			var bounds : Rectangle = data.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
			data.dispose();
			
			bounds.x += matBounds.x;
			bounds.y += matBounds.y;
			
			return bounds;
		}
		
		/**
		 * Converts a Sprite to a Bitmap.
		 *
		 * @param	sprite		The Sprite that should be converted.
		 * @param	smoothing	Whether or not the bitmap is smoothed when scaled.
		 * @return				The converted Bitmap object.
		 * 
		 * @see					http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/BitmapData.html#draw()
		 */
		public static function spriteToBitmap(sprite:DisplayObject, rect:Rectangle, smoothing:Boolean = false, trim:Boolean = false, enableAlpha:Boolean = true):Bitmap
		{
			MATRIX.identity();
			MATRIX.tx = -rect.x;
			MATRIX.ty = -rect.y;
			
			var bitmapRes:Bitmap;
			var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, enableAlpha, 0x00000000);		
			bitmapData.draw(sprite, MATRIX);
			
			if (trim)
			{
				var visibleBounds : Rectangle = bitmapData.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
				
				var trimmedBitmapData:BitmapData = new BitmapData(visibleBounds.width, visibleBounds.height, true, 0x00000000);			
				trimmedBitmapData.copyPixels(bitmapData, visibleBounds, ZERO_POINT);
				
				rect.x += visibleBounds.x;
				rect.y += visibleBounds.y;
				bitmapRes = new Bitmap(trimmedBitmapData, "auto", smoothing);
				
				bitmapData.dispose();
				
			}
			else
			{				
				bitmapRes = new Bitmap(bitmapData, "auto", smoothing);
			}
			return bitmapRes;
		} // END FUNCTION spriteToBitmap
		
		public static function spriteToScaledBitmap(sprite:Sprite, rect:Rectangle, scale:Number, smoothing:Boolean = false, trim:Boolean = false, enableAlpha:Boolean=true):Bitmap
		{
			MATRIX.identity();
			MATRIX.tx = -rect.x*scale;
			MATRIX.ty = -rect.y*scale;
			MATRIX.a = scale;
			MATRIX.d = scale;
			
			var bitmapData:BitmapData = new BitmapData(rect.width*scale, rect.height*scale, enableAlpha, 0x00FFFFFF);				
			bitmapData.draw(sprite, MATRIX);
			
			if (trim)
			{		
				var visibleBounds : Rectangle = bitmapData.getColorBoundsRect(0xFFFFFFFF, 0x000000, false);
				
				var trimmedBitmapData:BitmapData = new BitmapData(visibleBounds.width, visibleBounds.height, true, 0x00000000);			
				trimmedBitmapData.copyPixels(bitmapData, visibleBounds, ZERO_POINT);
				
				rect.x += visibleBounds.x/scale;
				rect.y += visibleBounds.y/scale;
				
				bitmapData.dispose();
				
				return new Bitmap(trimmedBitmapData, "auto", smoothing);
			}
			else
			{				
				return new Bitmap(bitmapData, "auto", smoothing);
			}
			
		} // END FUNCTION spriteToBitmap
		
		
		//this creates a tiled bitmap from an abnormally large image.
		//it splits it up into smaller chunks that flash won't complain about
		public static function CreateTiledSprite(sprite:Sprite, rect:Rectangle, scale:Number, smoothing:Boolean = false, trim:Boolean = false, enableAlpha:Boolean=true):Sprite
		{
			var i:int;
			var j:int;
			
			var pixelSize:Number = (rect.width * scale) * (rect.height * scale);  
			var tiledSprite:Sprite = new Sprite;
			
			//compute the number of divisions we'll have
			var newWidth:Number = rect.width * scale;
			var newHeight:Number = rect.height * scale;
			
			var wDivs:Number = Math.ceil(newWidth / WIDTH_LIMIT);
			var hDivs:Number = Math.ceil(newHeight / HEIGHT_LIMIT);
			
			//compute the new bitmap width-wise first
			//then height-wise
			var posX:Number;
			var posY:Number;
			
			var curBitmap:Bitmap;
			var curBitmapData:BitmapData;
			
			var curWidth:Number;
			var curHeight:Number;
			
			var clipRect:Rectangle = new Rectangle(0, 0, WIDTH_LIMIT, HEIGHT_LIMIT);
			
			MATRIX.identity();
			MATRIX.tx = -rect.x*scale;
			MATRIX.ty = -rect.y*scale;
			MATRIX.a = scale;
			MATRIX.d = scale;
			
			var bmpStartX:Number;
			var bmpStartY:Number;
			
			for(i = 0; i < hDivs; ++i)
			{
				posY = (i * HEIGHT_LIMIT) - (i*TILE_OVERLAP);
				
				//must always be positive
				bmpStartY = (i * HEIGHT_LIMIT) - (i*TILE_OVERLAP);
				
				curHeight = (bmpStartY+HEIGHT_LIMIT < newHeight) ? HEIGHT_LIMIT : (newHeight - bmpStartY);
				
				for(j = 0; j < wDivs; ++j)
				{
					posX = (j * WIDTH_LIMIT) - (j*TILE_OVERLAP);
					
					//must always be positive
					bmpStartX = (j * WIDTH_LIMIT) - (j*TILE_OVERLAP);
					
					//make it WIDTH_LIMIT or the remainder
					curWidth =  (bmpStartX+WIDTH_LIMIT < newWidth) ? WIDTH_LIMIT : (newWidth - bmpStartX);						
					
					curBitmapData = new BitmapData(curWidth, curHeight, enableAlpha, 0);
					
					//move the rectangle "forward"
					MATRIX.tx = -bmpStartX;
					MATRIX.ty = -bmpStartY;
					MATRIX.a = scale;
					MATRIX.d = scale;
					
					//adjust the width
					clipRect.width = curWidth;
					clipRect.height = curHeight;
					
					curBitmapData.draw(sprite, MATRIX, null, null, clipRect, smoothing);
					
					//position and add it, with an overlap of TILE_OVERLAP pixels
					curBitmap = new Bitmap(curBitmapData, "auto", smoothing);
					curBitmap.x = posX;
					curBitmap.y = posY;
					tiledSprite.addChild(curBitmap);					
				}
			}
			
			return tiledSprite;		
		}
		
		public static function spriteToXYScaledBitmap(sprite:Sprite, rect:Rectangle, scaleX:Number, scaleY:Number, smoothing:Boolean = false):Bitmap
		{
			var bitmapData:BitmapData = new BitmapData(rect.width*scaleX, rect.height*scaleY, true, 0x00FFFFFF);
			
			MATRIX.identity();
			MATRIX.tx = -rect.x*scaleX;
			MATRIX.ty = -rect.y*scaleY;
			MATRIX.a = scaleX;
			MATRIX.d = scaleY;
			
			bitmapData.draw(sprite, MATRIX);
			
			return new Bitmap(bitmapData, "auto", smoothing);
			
		} // END FUNCTION spriteToBitmap
		
		// **********************************************************************************
		// **********************************************************************************
		
		
	} // END CLASS DisplayConverter
} // END PACKAGE