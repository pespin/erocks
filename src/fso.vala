#if _FSO_
[DBus (name = "org.freesmartphone.ousaged", timeout = 120000)]
public interface FSOusaged: GLib.Object {

	public abstract void request_resource(string resource) throws IOError;
	public abstract void release_resource(string resource) throws IOError;


}
#endif
