package  {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import graphics.*;

	/**
	 * ...
	 * @author Frankie Wilde
	 */

	public class Resources {

		static public const SHAKE_BUTTON:MovieClip = new ShakeButton();
		static public const MORE_BRICKS_BUTTON:MovieClip = new MoreBricksButton();
		static public const EXIT_BUTTON:MovieClip = new ExitButton();
		static public const RESET_BUTTON:MovieClip = new ResetButton();
		
		static public const BRICK_01:Sprite = new Brick01();
		static public const BRICK_02:Sprite = new Brick02();
		static public const BRICK_03:Sprite = new Brick03();
		
		static public const AXE_01:Sprite = new Axe01();
		static public const AXE_02:Sprite = new Axe02();
		static public const SHOVEL:Sprite = new Shovel();
		
		static public const SILHOUETTE_01:Sprite = new Silhouette01();
		static public const SILHOUETTE_02:Sprite = new Silhouette02();
		static public const SILHOUETTE_03:Sprite = new Silhouette03();
		static public const SILHOUETTE_04:Sprite = new Silhouette04();
		static public const SILHOUETTE_05:Sprite = new Silhouette05();
		static public const SILHOUETTE_06:Sprite = new Silhouette06();
		
		static public const SILHOUETTES:Vector.<Sprite> = new <Sprite>[
			//SILHOUETTE_01,
			SILHOUETTE_02,
			SILHOUETTE_03,
			SILHOUETTE_04,
			SILHOUETTE_05,
			//SILHOUETTE_06,
			AXE_01,
			//AXE_02,
			SHOVEL,
		];
		static public const BRICKS:Vector.<Sprite> = new <Sprite>[
			BRICK_01,
			BRICK_02,
			BRICK_03,
		];
		
		
		[Embed(source='../obj/goblins.mp3')]
		public static const GOBLINS_MP3:Class;
		
	}

}
