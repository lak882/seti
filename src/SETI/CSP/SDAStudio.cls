Class SETI.CSP.SDAStudio Extends HS.UI.Template
{

Parameter LICENSEDPRODUCT [ Final ] = "Clinical Message Delivery,Composite Health Record,Active Analytics,Patient Index,Provider Directory";

/// Class name of application this page belongs to.
Parameter APPLICATION = "HS.UI.Application";

/// Displayed name of this page.
Property PageTitle As %ZEN.Datatype.caption [ InitialExpression = {$$$TextHTML("User/Clinician Registry")} ];

/// Security requirement
Parameter RESOURCE = "%HSAdmin_UserManagement,%HSAdmin_FacilityUserManagement";

/// Domain used for localization.
Parameter DOMAIN = "HS";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">

#menuBar {
	height: 33em;
	width: 6em;
	padding: 5px;
	margin-top:3px;
	border-right: solid gray 1px;
	border-bottom: solid gray 1px;
	background: #D3E1EE;
}

#display {
        overflow:hidden; 
        height:100%;
}

</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="SDA Studio">
<html id="titleBar" OnDrawContent="DrawTitle"/>
<!-- INSERT PORTS -->
<iframe width="100%" height="100%" src="http://localhost:52775/seti/index.html" frameBorder="0" id="display"></iframe>
<!-- INSERT PORTS -->
</page>
}

}
