package com.neopets.util.template
{
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * This is the typical format of a simple multiline comment
 * such as for an <code>ITemplateInterface</code> interface.
 * 
 * <p><u>REVISIONS</u>:<br>
 * <table width="500" cellpadding="0">
 * <tr><th>Date</th><th>Author</th><th>Description</th></tr>
 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>Class created.</td></tr>
 * <tr><td>MM/DD/YYYY</td><td>AUTHOR</td><td>DESCRIPTION.</td></tr>
 * </table>
 * </p>
 * 
 * @example Here is a code example.  
 * <listing version="3.0" >
 * 	//Code example goes here.
 * </listing>
 *
 * <span class="hide">Any hidden comments go here.</span>
 *
*/
public interface ITemplate
{		
	
	//--------------------------------------
	//  Properties
	//--------------------------------------

	function get sample () 						: String;
	function set sample (aValue : String) 		: void;

	
	//--------------------------------------
	//  Methods
	//--------------------------------------				

	function sampleMethod (aArgument_str:String, aArgument2_str:String) : void;
	
}

}