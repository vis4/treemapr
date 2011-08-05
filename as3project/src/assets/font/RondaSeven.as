package assets.font 
{
	import net.vis4.text.fonts.EmbeddedFont;
	
	/**
	 * ...
	 * @author gka
	 */
	public class RondaSeven extends EmbeddedFont 
	{
		
		public function RondaSeven(props:Object = null) 
		{
			if (props == null) {
				props = {
					
				};
			}
			props.name = 'PF Ronda Seven';
			//props.antiAliasType = 'normal';
			props.sharpness = 100000;
			super(props);
		}
		
	}

}