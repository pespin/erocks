using Gst;

eRocksPlayer PLAYER;

public class eRocksPlayer : GLib.Object {

	private dynamic Element gstplayer;
	private Gst.Bus gstbus;
	private Song current_song;
	
	public eRocksPlayer(string[] args) {
		Gst.init (ref args);
		gstplayer = ElementFactory.make ("playbin", "play");
		gstbus = gstplayer.get_bus();
		gstbus.add_watch(gstbus_callback);
		
	}

	public void play(Song song) {
			this.current_song = song;
			this.gstplayer.uri = "file://"+this.current_song.path;
			
			stdout.printf("Starting to play song %s\n", this.current_song.path);
			gstplayer.set_state (State.PLAYING);
		
		}
	
	public void stop() {
		gstplayer.set_state (State.NULL);
		gstplayer.uri = null;
		}
	
	public void pause() {
		gstplayer.set_state (State.PAUSED);
		}
	
	
	public void resume() {
	
		gstplayer.set_state (State.PLAYING);

	
	}
	
	
	
	private bool gstbus_callback (Gst.Bus bus, Gst.Message message) {
        switch (message.type) {
        case MessageType.ERROR:
            GLib.Error err;
            string debug;
            message.parse_error (out err, out debug);
            stdout.printf ("Error: %s\n", err.message);
            break;
        case MessageType.EOS:
            stdout.printf ("end of stream\n");
            break;
        case MessageType.STATE_CHANGED:
            Gst.State oldstate;
            Gst.State newstate;
            Gst.State pending;
            message.parse_state_changed (out oldstate, out newstate,
                                         out pending);
            stdout.printf ("state changed: %s->%s:%s\n",
                           oldstate.to_string (), newstate.to_string (),
                           pending.to_string ());
            break;
        case MessageType.TAG:
            //Gst.TagList tag_list;
            stdout.printf ("taglist found\n");
            //message.parse_tag (out tag_list);
            //tag_list.foreach ((TagForeachFunc) foreach_tag);
            break;
        default:
            break;
        }

        return true;
    }
	
//	public Song get_song_playing();




}
