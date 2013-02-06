// Browser type as detected by getBrowser()
var browser = '';

// Default app state URL to use when no fragment ID present
var defaultUrl = '';

// Last-known app state URL
var curUrl = document.location.href;

// Initial URL (used only by IE)
var initialUrl = document.location.href;

// History frame source URL prefix (used only by IE)
var historyFrameSourcePrefix = 'historyFrame.html?';

// History maintenance (used only by Safari)
var curHistoryLength = -1;
var historyHash = new Array();

/* Autodetect browser type; sets browser var to 'IE', 'Safari', 'Firefox' or empty string. */
function getBrowser()
{
    var name = navigator.appName;
    var agent = navigator.userAgent.toLowerCase();

    if (name.indexOf('Microsoft') != -1)
    {
        if (agent.indexOf('mac') == -1)
        {
            browser = 'IE';
            // note that Mac IE is considered to be uncategorized
        }
    }
    else if (agent.indexOf('safari') != -1)
    {
        browser = 'Safari';
    }
    else if (agent.indexOf('firefox') != -1)
    {
        browser = 'Firefox';
    }
}

/* Get the Flash player object for performing ExternalInterface callbacks. */
function getPlayer()
{
    var player = document.getElementById(getPlayerId());
    
    if (player == null)
        player = document.getElementsByTagName('object')[0];
    
    if (player == null || player.object == null)
        player = document.getElementsByTagName('embed')[0];

    return player;
}

/* Get the current location hash excluding the '#' symbol. */
function getHash()
{
   // It would be nice if we could use document.location.hash here,
   // but it's faulty sometimes.
   var idx = document.location.href.indexOf('#');
   return (idx >= 0) ? document.location.href.substr(idx+1) : '';
}

/* Set the current browser URL; called from inside URLKit to propagate
 * the application state out to the container.
 */
function setBrowserUrl(flexAppUrl)
{
   var pos = document.location.href.indexOf('#');
   var baseUrl = pos != -1 ? document.location.href.substr(0, pos) : document.location.href;
   var newUrl = baseUrl + '#' + flexAppUrl;
   if (document.location.href != newUrl && document.location.href + '#' != newUrl)
   {
       curUrl = newUrl;
       addHistoryEntry(baseUrl, newUrl, flexAppUrl);
       curHistoryLength = history.length;
   }
   return false;
}

/* Add a history entry to the browser.
 *   baseUrl: the portion of the location prior to the '#'
 *   newUrl: the entire new URL, including '#' and following fragment
 *   flexAppUrl: the portion of the location following the '#' only
 */
function addHistoryEntry(baseUrl, newUrl, flexAppUrl)
{
    if (browser == 'IE')
    {
        //Check to see if we are being asked to do a navigate for the first
        //history entry, and if so ignore, because it's coming from the creation
        //of the history iframe
        if (flexAppUrl == defaultUrl && document.location.href == initialUrl)
        {
            curUrl = initialUrl;
            return;
        }
        if (!flexAppUrl)
        {
            newUrl = baseUrl + '#' + defaultUrl;
        }
        else
        {
       	 	// for IE, tell the history frame to go somewhere without a '#'
       	 	// in order to get this entry into the browser history.
            getHistoryFrame().src = historyFrameSourcePrefix + flexAppUrl;
        }
        document.location.href = newUrl;
    }
    else
    {
	    if (browser == 'Safari')
	    {
	    	// for Safari, submit a form whose action points to the desired URL
	        getFormElement().innerHTML = '<form name="historyForm" action="#' + flexAppUrl + '" method="GET"></form>';
	        document.forms.historyForm.submit();
	        // We also have to maintain the history by hand for Safari
			historyHash[history.length] = flexAppUrl;
	   }
	   else
	   {
	   		// Otherwise, write an anchor into the page and tell the browser to go there
		    addAnchor(flexAppUrl);
	        document.location.hash = flexAppUrl;
	   }
    }
}

/* Called periodically to poll to see if we need to detect navigation that has occurred */
function checkForUrlChange()
{
    if (browser == 'IE')
    {
        if (curUrl != document.location.href)
        {
             //This occurs when the user has navigated to a specific URL
             //within the app, and didn't use browser back/forward
             //IE seems to have a bug where it stops updating the URL it
             //shows the end-user at this point, but programatically it
             //appears to be correct.  Do a full app reload to get around
             //this issue.
             curUrl = document.location.href;
             document.location.reload();
        }
    }
    else if (browser == 'Safari')
    {
    	// For Safari, we have to check to see if history.length changed.
        if (curHistoryLength >= 0 && history.length != curHistoryLength)
        {
        	// If it did change, then we have to look the old state up
        	// in our hand-maintained array since document.location.hash
        	// won't have changed, then call back into URLKit.
        	curHistoryLength = history.length;
            var flexAppUrl = historyHash[curHistoryLength];
            if (flexAppUrl == '')
                flexAppUrl = defaultUrl;
            getPlayer().setPlayerUrl(flexAppUrl);
        }
    }
    else
    {
        if (curUrl != document.location.href)
        {
        	// Firefox changed; do a callback into URLKit to tell it.
            curUrl = document.location.href;
            var flexAppUrl = getHash();
            if (flexAppUrl == '')
                flexAppUrl = defaultUrl;
            getPlayer().setPlayerUrl(flexAppUrl);
        }
    }
   setTimeout(checkForUrlChange, 250);
}

function setDefaultUrl(def)
{
   defaultUrl = def;
                    //trailing ? is important else an extra frame gets added to the history
                    //when navigating back to the first page.  Alternatively could check
                    //in history frame navigation to compare # and ?.
	if (browser == 'IE')
	{
	   getHistoryFrame().src = historyFrameSourcePrefix + defaultUrl;
    }
    else if (browser == 'Safari')
    {
    	curHistoryLength = history.length;
    	historyHash[curHistoryLength] = defaultUrl;
	}
}

function setTitle(title)
{
	document.title = title;
}
// Added for IE Fix
function getTitle()
{
	return document.title;
}

/* Write an anchor into the page to legitimize it as a URL for Firefox et al. */
function addAnchor(flexAppUrl)
{
   if (document.getElementsByName(flexAppUrl).length == 0)
   {
       getAnchorElement().innerHTML += "<a name='" + flexAppUrl + "'>" + flexAppUrl + "</a>";
   }
}

// Accessor functions for obtaining specific elements of the page.

function getHistoryFrame()
{
    return document.getElementById('historyFrame');
}

function getAnchorElement()
{
    return document.getElementById('anchorDiv');
}

function getFormElement()
{
    return document.getElementById('formDiv');
}

// Initialization

getBrowser();
setTimeout(checkForUrlChange, 250);
