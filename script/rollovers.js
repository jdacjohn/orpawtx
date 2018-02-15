// start script for navigation rollovers
		if (document.images) {

		news_on = new Image();
		news_on.src = "http://westtexas.tstc.edu/images/tstc_images/news_on.gif";
		
		conted_on = new Image();
		conted_on.src = "http://westtexas.tstc.edu/images/tstc_images/conted_on.gif";

		events_on = new Image();
		events_on.src = "http://westtexas.tstc.edu/images/tstc_images/events_on.gif";

			}

	imgOrig = null;

	function go(imageID,imageOn) {
		if (document.images) {
			if (imageOn) {
				imgOrig = document.images[imageID].src
				imgOn = eval(imageOn + "_on.src");
				document.images[imageID].src = imgOn;
			}

			else {
				imgOrig = document.images[imageID].src
				imgOn = eval("on.src");
				document.images[imageID].src = imgOn;
			}
		}
		else {}
	}

	function stop(imageID) {
		if (document.images) {
			document.images[imageID].src = imgOrig;
		}
		else {}
	}
// end script for navigation rollovers

function getwidth()
{
 scr = screen.width+"x"+screen.height
 gw="<img src='/images/tstc_images/pxclear.gif' width='240' height='1' border='0'/>";
 if (scr == "640x480")
 gw="<img src='/images/tstc_images/pxclear.gif' width='1' height='1' border='0'/>";
 if (scr == "800x600")
 gw="<img src='/images/tstc_images/pxclear.gif' width='30' height='1' border='0'/>";
 if (scr == "1024x768")
  gw="<img src='/images/tstc_images/pxclear.gif' width='240' height='1' border='0'/>";
  if (scr == "1152x864")
  gw="<img src='/images/tstc_images/pxclear.gif' width='348' height='1' border='0'/>";
  if (screen.width== "1280")
  gw="<img src='/images/tstc_images/pxclear.gif' width='476' height='1' border='0'/>";
  if (screen.width== "1400")
  gw="<img src='/images/tstc_images/pxclear.gif' width='596' height='1' border='0'/>";
 return gw;
 }
