<!--<script type="text/javascript" language="javascript"> -->

/* General scripts used by the Orpa site */

function toggle(elementId,siteRoot) {
  if (document.getElementById(elementId).style.display == 'none') {
    document.getElementById(elementId).style.display = '';
    document.getElementById('expand_' + elementId).src = siteRoot + '/images/buttons/collapse.png';
  } else {
    document.getElementById(elementId).style.display = 'none';
    document.getElementById('expand_' + elementId).src = siteRoot + '/images/buttons/expand.png';
  }
}

function toggleList(elementId) {
  if (document.getElementById(elementId).style.display == 'none') {
    document.getElementById(elementId).style.display = '';
  } else {
    document.getElementById(elementId).style.display = 'none';
  }
}

function showList(elementId) {
  if (document.getElementById(elementId).style.display == 'none') {
    document.getElementById(elementId).style.display = '';
  }
}

function hideList(elementId) {
  if (document.getElementById(elementId).style.display != 'none') {
    document.getElementById(elementId).style.display = 'none';
  }
}


function calcRows(aString) {
  x = parseInt(aString.length() / 80);
  return x + 1;

}

function toggleVocDisplay(elementId) {
	// Hide the previously shown item
	if (document.vocListForm.lastShown.value != "") {
		document.getElementById(document.vocListForm.lastShown.value).style.display = 'none';
	}
  if (document.getElementById(elementId).style.display == 'none') {
    document.getElementById(elementId).style.display = '';
  } else {
    document.getElementById(elementId).style.display = 'none';
  }
}

<!-- </script> -->