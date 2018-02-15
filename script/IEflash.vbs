Sub checkFlash(flashURL,width,height,altImageSrc)
		on error resume next
    var Flashmode
    FlashMode = IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.3"))

    If FlashMode = False Then
        FlashMode = IsObject(CreateObject("ShockwaveFlash.ShockwaveFlash.4"))
    End If

    If FlashMode = True Then
        document.write "<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0' width='"+width+"' height='"+height+"'>"
				document.write "	<param name='movie' value='"+flashURL+"'>"
				document.write "	<param name='quality' value='high'>"
				document.write("    <param name='loop' value='false'>")
				document.write "	<embed src='"+flashURL+"' quality='high' type='application/x-shockwave-flash' width='"+width+"' height='"+height+"'></embed>"
'				document.write "	<embed src='../fla/contact_us.swf' quality='high' type='application/x-shockwave-flash' width='530' height='335'></embed>"
				document.write "</object>"
    Else
        document.write "<img src='"+altImageSrc+"' border='0' usemap='#noFlashImg'>"
    End If
	End Sub