//= require madmass

/********************************************************************
 * Madmass Configuration. You can put here any parameters or method
 * that will be available through the global constant CONFIG.
 ********************************************************************/
Madmass.Config = new Class.Singleton({
  initialize: function(){

    // Enables debugging info from core. Use this flag freely for your purpose too.
    this.debug = true;
    // Enables logging. Use this flag freely for your purpose too.
    this.log = true;

    /* Servers params used by ajax. This auto configuration should be enough.
     * Customize it if necessary. */
    var domain = window.location.host.split(':');
    this.server = {
      host: domain[0],
      port: domain[1],
      agent: 'commands'
    };

    /* Here will be searched gui elements declared in gui section below.
     * For example, the gui item 'Menu' will be searched as:
     *    Madmass.Gui.Menu
     *
     * So the pattern is: guiNamespace[Gui][GuiItem]
     * */
    this.guiNamespace = "Madmass";

    /* Define the permanent elements of your gui */
    this.gui = [
    //  {'Menu': {x: 0, y: 508}},
    //  {'SummaryCover': {anchor: {type: 'csspos'} }}
    ];

    /********************************************************************
     * Here you can define your application messages. Use them to
     * dispatch messages and map you message listeners.
     ********************************************************************
     *  Madmass.Messages = {
     *    event: {
     *      click: $newMsgId(),
     *      mousemove: $newMsgId(),
     *      ...
     *    },
     *    action: {
     *      compute: $newMsgId(),
     *      save: $newMsgId(),
     *      ...
     *    },
     *    rpc: {
     *      doThis: $newMsgId(),
     *      doThat: $newMsgId(),
     *      doThatSuccess: $newMsgId(),
     *      doThatError: $newMsgId(),
     *
     *      ...
     *    }
     *  }
     *
     *  where $newMsgId() returns an unique message id (number).
     *  Note: $msg is a shortcut for Madmass.Messages, so you can
     *  dispatch an event like:
     *
     *  this.send($msg.event.click, [optional data])
     **/
    this.messages = {
      // myMessage1: $newMsgId(),
      // myMessage2: $newMsgId()
    };

    // convenient variable to access messages. Example: $msg.event.click
    $msg = this.messages;

    /********************************************************************
     * Here you can define your application remote calls to agents. This
     * calls will be triggered by the registered event and differ from
     * $askAgent because you setup them once for all.
     ********************************************************************
     * Example:
     *
     * Madmass.RemoteCalls = [
     *  { on: $msg.rpc.doThis, call: {agent: 'commands', cmd: 'actions::hello', success: function(){alert('success!');}} },
     *  { on: $msg.rpc.doThat, call: {agent: 'slave', cmd: 'actions::world', success: $msg.rpc.doThatSuccess, error: $msg.rpc.doThatError } }
     * ]
     *
     **/
    this.remoteCalls = [
    ];

    /* Add here properties and methods */

  }
});
