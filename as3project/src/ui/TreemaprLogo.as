package ui
{
	import assets.font.Lato;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import math.Random;
	import net.vis4.text.Label;
	
	/**
	 * ...
	 * @author gka
	 */
	public class TreemaprLogo extends Sprite 
	{
		
		public function TreemaprLogo(main:Sprite) 
		{
			new Label('TREEMAPR', new Lato( { color: 0xffffff, size: 30, weight: 300 } )).place(45, 5, this);
			Random.randomSeed();
			var randomValues:Array = [];
			var i:uint = Random.integer(4, 10);
			while (i-->1) {
				randomValues.push(Random.integer(1, 30));
			}
			
			addChild(new MiniTreemap(randomValues, new Rectangle(10, 12, 30, 26)));
			
			main.addChild(this);
		}
		
	}

}