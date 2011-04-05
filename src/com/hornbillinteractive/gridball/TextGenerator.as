package com.hornbillinteractive.gridball
{
	import flash.text.engine.*;
	
	public class TextGenerator
	{
		[Embed(source="/data/Nouveau_IBM.ttf", fontName="nouveau_ibm", mimeType="application/x-font-truetype")]
		private static var NouveauIBMFont:Class;
		
		public var font:FontDescription;
		
		public function TextGenerator()
		{
			font = new FontDescription("nouveau_ibm", "normal", "normal", FontLookup.EMBEDDED_CFF);
		}
		
		public function generateTextLine(text:String,size:Number,color:uint):TextLine
		{
			var textFormat:ElementFormat = new ElementFormat(font, size);
			textFormat.color = color;
			
			var textElement:TextElement = new TextElement(text, textFormat);
			var textBlock:TextBlock = new TextBlock();
			textBlock.content = textElement;
			
			return textBlock.createTextLine(null, 1000);
		}
		
		public function generateParagraph(text:String,size:Number,color:uint):Array
		{
			var textFormat:ElementFormat = new ElementFormat(font, size);
			textFormat.color = color;
			
			var textElement:TextElement = new TextElement(text, textFormat);
			var textBlock:TextBlock = new TextBlock();
			textBlock.textJustifier = new SpaceJustifier("en", LineJustification.ALL_BUT_LAST, true);
			textBlock.content = textElement;
			
			var lineArray:Array = new Array();
			var line:TextLine = textBlock.createTextLine(null,600);
			while(line)
			{
				lineArray.push(line);
				line = textBlock.createTextLine(line,600);
			}
			
			return lineArray
		}
	}
}