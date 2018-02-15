function checkFlash(flashURL,width,height,altImageSrc){	
	var agt = navigator.userAgent.toLowerCase(); // User Agent
		FlashMode = 0;
			if (navigator.appName == "Netscape" && navigator.plugins) {
				numPlugins = navigator.plugins.length;
				if (numPlugins > 4) {//net 4.5 default flash return 3
					for (i = 0; i < numPlugins; i++) {
						plugin = navigator.plugins[i];
						//if (plugin.description.indexOf("Flash 3") != -1 || plugin.description.indexOf("Flash 4") != -1) {
						if (numPlugins > 4){
							numTypes = plugin.length;
              for (j = 0; j < numTypes; j++) {
	              mimetype = plugin[j];
	              if (mimetype) {
									if (mimetype.enabledPlugin && (mimetype.suffixes.indexOf("swf") != -1))
										FlashMode = 1;	
									// Mac wierdness
						      if (navigator.mimeTypes["application/x-shockwave-flash"] == null)
						      	FlashMode = 0;
								}
						  }
						}
					}
		    }
				if (FlashMode == 1) {
					document.writeln("<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0' width='"+width+"' height='"+height+"'>");
					document.writeln("<param name=movie value='"+flashURL+"'>");
					document.writeln("<param name=quality value=high>");
					document.writeln("<embed src='"+flashURL+"' quality=high loop=false pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width='"+width+"' height='"+height+"'>");
					document.writeln('<noembed>Discover Texas State Technical College Discover Yourself</noembed></embed></object>');	
				}
				else{
					document.writeln("<img src='"+altImageSrc+"' border='0' alt='Discover Texas State Technical College Discover Yourself' width='"+width+"' height='"+height+"'/>");	
				}
			}
			var is_mac = (agt.indexOf("mac")!=-1);
			var is_ie  = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));
			if (is_mac && is_ie){
					document.writeln("<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs../flash/swflash.cab#version=4,0,2,0' width='"+width+"' height='"+height+"'>");
					document.writeln("<param name=movie value='"+flashURL+"'>");
					document.writeln("<param name=quality value=high>");
					document.writeln("<param name=loop value=false>");
					document.writeln("<embed src='"+flashURL+"' quality=high pluginspage='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash' type='application/x-shockwave-flash' width='"+width+"' height='"+height+"'>");
					document.writeln('<noembed>Discover Texas State Technical College Discover Yourself</noembed></embed></object>');	
			}
}
