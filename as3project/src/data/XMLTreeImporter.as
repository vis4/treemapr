package data 
{
	import net.vis4.treemap.data.Tree;
	import ui.MiniTreemap;
	/**
	 * ...
	 * @author gka
	 */
	public class XMLTreeImporter
	{
		
		// two possible formats: nested, flat
		
		public static function importTree(xml:XML, desc:DataDescription):Tree
		{
			if (desc.nested) {
				
			} else {
				
			}
			return null;
		}
		
		public static function describeData(xml:XML):DataDescription
		{
			var nested:Boolean = false, columns:Array = [], node:XML, subnode:XML, childrenProperty:String;
			
			var rootTagName:String = xml.name().localName;
			trace(rootTagName, xml.children().length());
			
			// look for root tag names
			
			var nodeCount:uint = 0;
			
			for each (node in xml.children()) {
				if (node.name().localName == rootTagName) {
					nested = true;
					childrenProperty = '';
				}				
				if (node.children().length() > 0) {
					for each (subnode in node.children()) {
						if (subnode.nodeKind() == 'element' && subnode.name().localName == rootTagName) {
							nested = true;
							childrenProperty = node.name().localName;
						}
					}
				}
			}
			
			if (nested) trace('nested tree', childrenProperty);
			
			// find properties
			
			if (nested) {
				extractAttributes(columns, childrenProperty, rootTagName, xml); 
			} else {
				var nodeTagName:String;
				// loop through all level 1 children
				for each (node in xml.children()) {
					if (node.nodeKind() == 'element') {
						for each (subnode in node.@* ) {
							if (columns.indexOf(String(subnode.name())) < 0) columns.push(String(subnode.name()));
						}
						for each (subnode in node.children() ) {
							if (subnode.nodeKind() == 'element') {
								if (columns.indexOf(String(subnode.name())) < 0) columns.push(String(subnode.name()));
							}
						}
					}
				}
			}
		
			return new DataDescription(nested, columns, childrenProperty);
		}
		
		
		
		protected static function extractAttributes(columns:Array, childrenProperty:String, nodeTag:String, node:XML):void
		{
			for each (var a:XML in node.@* ) {
				if (columns.indexOf(String(a.name())) < 0) columns.push(String(a.name()));
			}
			if (childrenProperty === '') { 
				for each (a in node.children()) {
					if (a.nodeKind() == 'element' && String(a.name()) == nodeTag) {
						extractAttributes(columns, childrenProperty, nodeTag, a);
					}
				}
			} else {
				for each (a in node.children()) {
					if (a.nodeKind() == 'element') {
						if (columns.indexOf(String(a.name())) < 0) {
							columns.push(String(a.name()));
						}
						if (String(a.name()) == childrenProperty) {
							for each (var b:XML in a.children()) {
								if (b.nodeKind() == 'element' && String(b.name()) == nodeTag) {
									extractAttributes(columns, childrenProperty, nodeTag, b);
								}
							}
						}
					}
				}
			}
			/*TODO: doesn't recognize all properties*/
		}
		
	}

}