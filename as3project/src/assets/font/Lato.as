package assets.font
{
	import net.vis4.text.fonts.EmbeddedFont;
	import net.vis4.text.fonts.SystemFont;

	
	/**
	 * ...
	 * @author gka
	 */
	public class Lato extends EmbeddedFont
	{
		
		[Embed(
			source = "Lato-Hairline.ttf", 
			fontName = "Lato Hairline",                       
			unicodeRange = "U+0020-U+00FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183",
			mimeType = "application/x-font-truetype"
		)]
		private var _lato100:Class;

		[Embed(
			source = "Lato-Light.ttf", 
			fontName = "Lato Book",                       
			unicodeRange = "U+0020-U+00FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183",
			mimeType = "application/x-font-truetype"
		)]
		private var _lato300:Class;

		[Embed(
			source = "Lato-Regular.ttf", 
			fontName = "Lato Normal",                       
			unicodeRange = "U+0020-U+00FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183",
			mimeType = "application/x-font-truetype"
		)]
		private var _lato400:Class;		

		[Embed(
			source = "Lato-Bold.ttf", 
			fontName = "Lato Bold",
			fontWeight = "bold",
			unicodeRange = "U+0020-U+00FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183",
			mimeType = "application/x-font-truetype"
		)]
		private var _lato700:Class;

		[Embed(
			source = "Lato-Black.ttf", 
			fontName = "Lato Black",                       
			unicodeRange = "U+0020-U+00FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183",
			mimeType = "application/x-font-truetype"
		)]
		private var _lato900:Class;
		
		public function Lato(props:Object) 
		{
			var weight:Object = {
				'100': 'Hairline',
				'300': 'Book',
				'400': 'Normal',
				'700': 'Bold',
				'900': 'Black'
			}

			if (props.bold) props.weight = '700';
			props.name = 'Lato ' + (props.weight ? weight[props.weight] : 'Normal');
			if (props.weight == 700) props.bold = true;

			props.antiAliasType = 'advanced';
			super(props);
		}
		
	}
	
}
