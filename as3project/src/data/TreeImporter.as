package data 
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.StringUtil;
	import net.vis4.treemap.data.Tree;
	
	/**
	 * ...
	 * @author gka
	 */
	public class TreeImporter 
	{
		
		public static function importTree(rawfile:String):Tree
		{
			// guess file type
			switch (guessFileType(rawfile)) {
				case 'xml':
					try {
						var xml:XML = new XML(rawfile);
						return XMLTreeImporter.importTree(xml, XMLTreeImporter.describeData(xml));
					} catch (e:Error) {
						// error while parsing xml file, maybe corrupt
						throw new Error('could not parse xml file');
					}
					break;
				case 'json':
					try {
						var json:Object = JSON.decode(rawfile, false);
						return JSONTreeImporter.importTree(json);
					} catch (e:Error) {
						// error while parsing xml file, maybe corrupt
						throw new Error('could not parse json file');
					}
					break;
				case 'csv':
				default:
					try {
						return CSVTreeImporter.importTree(rawfile);
					} catch (e:Error) {
						throw new Error('could not parse csv file');
					}
					break;
			}
			
			return null;
		}
		
		public static function guessFileType(rawfile:String):String
		{
			if (StringUtil.beginsWith(StringUtil.trim(rawfile), '<?xml')) return 'xml';
			if (StringUtil.beginsWith(StringUtil.trim(rawfile), '{') || StringUtil.beginsWith(StringUtil.trim(rawfile), '[')) return 'json';
			return 'csv';
			
		}
		
	}

}